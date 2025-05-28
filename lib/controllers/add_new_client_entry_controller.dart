import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';
import 'package:super_ge/models/entries_model.dart';
import 'package:pdf/widgets.dart' as pw;

import 'mandob_home_controller.dart';

class AddNewClientEntryController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final clientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final currentLocationController = TextEditingController();

  List<CollectionsModel> availableCollections = [];
  List<CollectionsModel> selectedCollections = [];
  Map<String, TextEditingController> quantityControllers = {};
  Map<String, TextEditingController> priceControllers = {};
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getCollections();
  }

  Future<void> getCollections() async {
    try {
      isLoading = true;
      update();

      final result = await FirebaseService.collectionsCollection.get();
      availableCollections = result.docs
          .map((e) => CollectionsModel.fromJson(e.data(), e.id))
          .toList();
    } catch (e) {
      _showErrorSnackbar('خطأ في تحميل البيانات: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  void toggleCollection(CollectionsModel collection) {
    if (collection.id == null) return;

    if (selectedCollections.contains(collection)) {
      selectedCollections.remove(collection);
      quantityControllers[collection.id!]?.dispose();
      priceControllers[collection.id!]?.dispose();
      quantityControllers.remove(collection.id);
      priceControllers.remove(collection.id);
    } else {
      selectedCollections.add(collection);
      quantityControllers[collection.id!] = TextEditingController();
      priceControllers[collection.id!] = TextEditingController();
    }
    update();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCollections.isEmpty) {
      _showErrorSnackbar('الرجاء اختيار تصنيف واحد على الأقل');
      return;
    }

    try {
      isLoading = true;
      update();

      // Validate all inputs before processing
      if (!_validateAllInputs()) {
        isLoading = false;
        update();
        return;
      }

      // Process all entries
      await _processEntries();

      // Share bill
      await _shareBill();

      // Clear form and refresh data
      await _clearFormAndRefresh();

      _showSuccessSnackbar('تم إضافة المدخلات بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في الحفظ: ${e.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }

  bool _validateAllInputs() {
    for (var collection in selectedCollections) {
      if (collection.id == null) continue;

      final quantityText = quantityControllers[collection.id!]?.text ?? '';
      final priceText = priceControllers[collection.id!]?.text ?? '';

      if (quantityText.isEmpty || priceText.isEmpty) {
        _showErrorSnackbar(
            'الرجاء إدخال الكمية والسعر لجميع التصنيفات المختارة');
        return false;
      }

      final quantity = int.tryParse(quantityText);
      final price = double.tryParse(priceText);

      if (quantity == null || quantity <= 0) {
        _showErrorSnackbar(
            'الكمية المدخلة للتصنيف ${collection.name} غير صحيحة');
        return false;
      }

      if (price == null || price <= 0) {
        _showErrorSnackbar('السعر المدخل للتصنيف ${collection.name} غير صحيح');
        return false;
      }

      if (quantity > collection.quantity) {
        _showErrorSnackbar(
            'الكمية المدخلة للتصنيف ${collection.name} أكبر من الكمية المتوفرة (${collection.quantity})');
        return false;
      }

      if (price < collection.startSellPrice ||
          price > collection.endSellPrice) {
        _showErrorSnackbar(
            'السعر المدخل للتصنيف ${collection.name} يجب أن يكون بين ${collection.startSellPrice} و ${collection.endSellPrice} جنيه');
        return false;
      }
    }
    return true;
  }

  Future<void> _processEntries() async {
    for (var collection in selectedCollections) {
      if (collection.id == null) continue;

      final quantity = int.parse(quantityControllers[collection.id!]!.text);
      final price = double.parse(priceControllers[collection.id!]!.text);

      // Add entry
      await FirebaseService.entriesCollection(collection.id!).add(
        EntriesModel(
          clientName: clientNameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          address: addressController.text.trim(),
          currentLocation: currentLocationController.text.trim(),
          quantity: quantity,
          price: price,
        ).toJson(),
      );

      // Update collection quantity
      await FirebaseService.collectionsCollection.doc(collection.id).update({
        'quantity': collection.quantity - quantity,
      });
    }
  }

  Future<void> _shareBill() async {
    try {
      final bill = await createBill(
        selectedCollections,
        clientNameController.text.trim(),
        phoneController.text.trim(),
        addressController.text.trim(),
        currentLocationController.text.trim(),
      );

      if (bill.isNotEmpty) {
        await shareBillAsPdf(bill);
        await saveBillToFirebase();
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في إنشاء الفاتورة: ${e.toString()}');
    }
  }

  Future<void> _clearFormAndRefresh() async {
    clientNameController.clear();
    phoneController.clear();
    addressController.clear();
    currentLocationController.clear();

    // Dispose controllers before clearing
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    for (var controller in priceControllers.values) {
      controller.dispose();
    }

    selectedCollections.clear();
    quantityControllers.clear();
    priceControllers.clear();

    update();
    await getCollections();
  }

  // Helper method to format numbers in Arabic
  String _formatArabicNumber(String number) {
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = number;
    for (int i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], arabicDigits[i]);
    }
    return result;
  }

  // Helper method to format price with Egyptian Pound currency
  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ج.م';
  }

  // Helper method to format price in words (optional)
  String _formatPriceInWords(double price) {
    return '${price.toStringAsFixed(2)} جنيه مصري';
  }

  Future<Uint8List> createBill(
    List<CollectionsModel> collections,
    String clientName,
    String phoneNumber,
    String address,
    String currentLocation,
  ) async {
    try {
      // Check and request storage permission
      if (!await _requestStoragePermission()) {
        return Uint8List.fromList([]);
      }

      final pdfDoc = pw.Document();
      final arabicFont = await _loadArabicFont();

      pdfDoc.addPage(
        pw.MultiPage(
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFont,
          ),
          textDirection: pw.TextDirection.rtl,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            _buildPdfContent(
                collections, clientName, phoneNumber, address, currentLocation),
          ],
        ),
      );

      return await pdfDoc.save();
    } catch (e) {
      _showErrorSnackbar('خطأ في إنشاء ملف PDF: ${e.toString()}');
      return Uint8List.fromList([]);
    }
  }

  Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();

      if (!status.isGranted) {
        _showErrorSnackbar('لا يوجد صلاحية للتخزين على الهاتف');
        return false;
      }
    }
    return true;
  }

  Future<pw.Font> _loadArabicFont() async {
    try {
      // Try to load the Arabic font
      final fontData = await rootBundle.load("assets/fonts/HacenTunisia.ttf");
      return pw.Font.ttf(fontData);
    } catch (e) {
      try {
        // Fallback to another common Arabic font
        final fontData =
            await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
        return pw.Font.ttf(fontData);
      } catch (e2) {
        // Last fallback - use a basic font that supports Arabic
        return pw.Font.helvetica();
      }
    }
  }

  pw.Widget _buildPdfContent(
    List<CollectionsModel> collections,
    String clientName,
    String phoneNumber,
    String address,
    String currentLocation,
  ) {
    final total = _calculateTotal(collections);
    final mandobName = Get.find<MandobHomeController>().name ?? 'غير محدد';
    final currentDate = DateTime.now();
    final formattedDate =
        '${currentDate.day}/${currentDate.month}/${currentDate.year} - ${currentDate.hour}:${currentDate.minute.toString().padLeft(2, '0')}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Center(
            child: pw.Text(
              'فاتورة مبيعات',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
          ),
        ),

        pw.SizedBox(height: 20),

        // Client Information
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'بيانات العميل',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                textDirection: pw.TextDirection.rtl,
              ),
              pw.SizedBox(height: 10),
              _buildInfoRow('الاسم:', clientName),
              _buildInfoRow('رقم الهاتف:', phoneNumber),
              _buildInfoRow('العنوان:', address),
              _buildInfoRow('الموقع الحالي:', currentLocation),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // Items Table
        pw.Text(
          'تفاصيل الفاتورة',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          textDirection: pw.TextDirection.rtl,
        ),

        pw.SizedBox(height: 10),

        _buildItemsTable(collections),

        pw.SizedBox(height: 20),

        // Total Section
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    _formatPrice(total),
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.Text(
                    'المجموع الكلي:',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'المبلغ بالكلمات: ${_formatPriceInWords(total)}',
                style:
                    pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
                textDirection: pw.TextDirection.rtl,
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 30),

        // Footer Information
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'المندوب: $mandobName',
                  style: const pw.TextStyle(fontSize: 16),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'التوقيع: _______________',
                  style: const pw.TextStyle(fontSize: 14),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'تاريخ الفاتورة: $formattedDate',
                  style: const pw.TextStyle(fontSize: 16),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'العملة: الجنيه المصري (ج.م)',
                  style: const pw.TextStyle(fontSize: 14),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 20),

        // Footer note
        pw.Center(
          child: pw.Text(
            'شكراً لتعاملكم معنا',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            textDirection: pw.TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 14),
              textDirection: pw.TextDirection.rtl,
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              textDirection: pw.TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(List<CollectionsModel> collections) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const pw.FlexColumnWidth(3), // Name
        1: const pw.FlexColumnWidth(1), // Quantity
        2: const pw.FlexColumnWidth(2), // Price
        3: const pw.FlexColumnWidth(2), // Subtotal
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('اسم الصنف', isHeader: true),
            _buildTableCell('الكمية', isHeader: true),
            _buildTableCell('سعر الوحدة (ج.م)', isHeader: true),
            _buildTableCell('المجموع (ج.م)', isHeader: true),
          ],
        ),
        // Data rows
        ...collections.map((collection) {
          if (collection.id == null) {
            return pw.TableRow(children: [
              _buildTableCell(''),
              _buildTableCell(''),
              _buildTableCell(''),
              _buildTableCell(''),
            ]);
          }

          final quantity = int.parse(quantityControllers[collection.id!]!.text);
          final price = double.parse(priceControllers[collection.id!]!.text);
          final subtotal = quantity * price;

          return pw.TableRow(
            children: [
              _buildTableCell(collection.name),
              _buildTableCell(quantity.toString()),
              _buildTableCell(price.toStringAsFixed(2)),
              _buildTableCell(subtotal.toStringAsFixed(2)),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  double _calculateTotal(List<CollectionsModel> collections) {
    return collections.fold<double>(
      0,
      (previousValue, element) {
        if (element.id == null) return previousValue;

        final quantity =
            int.tryParse(quantityControllers[element.id!]?.text ?? '0') ?? 0;
        final price =
            double.tryParse(priceControllers[element.id!]?.text ?? '0') ?? 0;
        return previousValue + (quantity * price);
      },
    );
  }

  Future<void> shareBillAsPdf(Uint8List pdf) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final clientName =
          clientNameController.text.trim().replaceAll(RegExp(r'[^\w\s-]'), '');
      final fileName =
          'فاتورة_${clientName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(pdf);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'فاتورة جديدة لصالح: ${clientNameController.text}',
        subject: 'الفاتورة لصالح: ${clientNameController.text}',
      );
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الفاتورة: ${e.toString()}');
    }
  }

  Future<void> saveBillToFirebase() async {
    try {
      final mandobName = Get.find<MandobHomeController>().name ?? 'غير محدد';

      await FirebaseService.billsCollection.add({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'client_name': clientNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'current_location': currentLocationController.text.trim(),
        'collections': selectedCollections.map((e) {
          if (e.id == null) return {};

          final quantity = int.parse(quantityControllers[e.id!]!.text);
          final price = double.parse(priceControllers[e.id!]!.text);
          return {
            'id': e.id,
            'name': e.name,
            'quantity': quantity,
            'price': price,
            'subtotal': quantity * price,
          };
        }).toList(),
        'mandob_name': mandobName,
        'total': _calculateTotal(selectedCollections),
        'currency': 'EGP', // Egyptian Pound
        'bill_date': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _showErrorSnackbar('خطأ في حفظ الفاتورة: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'تم',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    clientNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    currentLocationController.dispose();

    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    for (var controller in priceControllers.values) {
      controller.dispose();
    }

    super.onClose();
  }
}
