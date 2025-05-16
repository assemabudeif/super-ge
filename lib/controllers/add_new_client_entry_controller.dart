import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';
import 'package:super_ge/models/entries_model.dart';
import 'package:pdf/widgets.dart' as pw;

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
    getCollections();
    super.onInit();
  }

  Future<void> getCollections() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.collectionsCollection.get();
      availableCollections = result.docs
          .map((e) => CollectionsModel.fromJson(e.data(), e.id))
          .toList();
      isLoading = false;
    } catch (e) {
      isLoading = false;
      Get.snackbar(
        'خطأ',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  void toggleCollection(CollectionsModel collection) {
    if (selectedCollections.contains(collection)) {
      selectedCollections.remove(collection);
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
    if (formKey.currentState!.validate()) {
      if (selectedCollections.isEmpty) {
        Get.snackbar(
          'خطأ',
          'الرجاء اختيار تصنيف واحد على الأقل',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading = true;
      update();

      try {
        for (var collection in selectedCollections) {
          final quantity = int.parse(quantityControllers[collection.id!]!.text);
          final price = double.parse(priceControllers[collection.id!]!.text);

          if (quantity > collection.quantity) {
            Get.snackbar(
              'خطأ',
              'الكمية المدخلة للتصنيف ${collection.name} أكبر من الكمية المتوفرة',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            isLoading = false;
            update();
            return;
          }

          if (price < collection.startSellPrice ||
              price > collection.endSellPrice) {
            Get.snackbar(
              'خطأ',
              'السعر المدخل للتصنيف ${collection.name} يجب أن يكون بين ${collection.startSellPrice} و ${collection.endSellPrice}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            isLoading = false;
            update();
            return;
          }

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
          await FirebaseService.collectionsCollection
              .doc(collection.id)
              .update({
            'quantity': collection.quantity - quantity,
          });
        }

        // Share bill
        await shareBill();

        Get.snackbar(
          'تم',
          'تم إضافة المدخلات بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clientNameController.clear();
        phoneController.clear();
        addressController.clear();
        currentLocationController.clear();
        selectedCollections.clear();
        quantityControllers.clear();
        priceControllers.clear();
        availableCollections.clear();
        await getCollections();

        isLoading = false;
        update();
      } catch (e) {
        Get.snackbar(
          'خطأ',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      isLoading = false;
      update();
    }
  }

  Future<void> shareBill() async {
    final bill = await createBill(
      selectedCollections,
      clientNameController.text.trim(),
      phoneController.text.trim(),
      addressController.text.trim(),
      currentLocationController.text.trim(),
    );
    await shareBillAsPdf(bill);
    await saveBillToFirebase();
  }

  Future<Uint8List> createBill(
    List<CollectionsModel> collections,
    String clientName,
    String phoneNumber,
    String address,
    String currentLocation,
  ) async {
    final pdfDoc = pw.Document();

    pdfDoc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('الاسم: $clientName', style: pw.TextStyle(fontSize: 20)),
            pw.Text('رقم الهاتف: $phoneNumber',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('العنوان: $address', style: pw.TextStyle(fontSize: 20)),
            pw.Text('الموقع الحالي: $currentLocation',
                style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['الاسم', 'الكمية', 'السعر'],
              data: collections.map((e) {
                return [
                  e.name,
                  quantityControllers[e.id!]!.text,
                  priceControllers[e.id!]!.text,
                ];
              }).toList(),
              cellStyle: pw.TextStyle(fontSize: 15),
              headerStyle:
                  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    return await pdfDoc.save();
  }

  Future<void> shareBillAsPdf(Uint8List pdf) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/bill.pdf').create();
    await file.writeAsBytes(pdf);
    // final uri = Uri.parse(file.path);
    await SharePlus.instance.share(
      ShareParams(
          title: 'فاتورة',
          text: 'فاتورة جديدة',
          subject: 'فاتورة جديدة',
          files: [
            XFile(file.path),
          ]),
    );
  }

  Future<void> saveBillToFirebase() async {
    await FirebaseService.billsCollection.add({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'client_name': clientNameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'current_location': currentLocationController.text,
      'collections': selectedCollections.map((e) {
        return {
          'name': e.name,
          'quantity': int.parse(quantityControllers[e.id!]!.text),
          'price': double.parse(priceControllers[e.id!]!.text),
        };
      }).toList(),
    });
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
