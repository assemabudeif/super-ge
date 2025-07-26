import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';
import 'package:super_ge/models/entries_model.dart';

/// A controller for the admin's home screen.
///
/// This class manages the state and logic for the admin dashboard, including
/// fetching collections (categories), calculating profits, and exporting data to Excel.
class AdminHomeController extends GetxController {
  // A list to hold all the collections (categories).
  List<CollectionsModel> categories = [];

  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;

  // Retrieves the admin's name and phone from shared preferences.
  final name = AppPreferences.instance.getName();
  final phone = AppPreferences.instance.getPhone();

  // A flag to indicate if an Excel export is in progress.
  bool exporting = false;

  @override
  Future<void> onInit() async {
    // Initialize the controller by fetching necessary data.
    await getCollections();
    await _initEntries();
    await calculateProfits();
    super.onInit();
  }

  /// Fetches all collections from the Firebase Firestore.
  Future<void> getCollections() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.collectionsCollection.get();
      categories = result.docs
          .map(
            (e) => CollectionsModel.fromJson(
              e.data(),
              e.id,
            ),
          )
          .toList();
      isLoading = false;
    } on FirebaseException catch (e) {
      isLoading = false;
      Get.snackbar(
        'خطأ',
        e.message.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  /// Calculates the profits for each collection.
  calculateProfits() async {
    for (var element in categories) {
      element.profits = await getCollectionProfits(element);
    }
    update();
  }

  /// Calculates the total profit for a single collection.
  ///
  /// Profit is calculated as (selling price - wholesale price) * quantity for each entry.
  Future<num> getCollectionProfits(CollectionsModel collection) async {
    num sum = 0;
    final entries =
        await FirebaseService.entriesCollection(collection.id!).get();

    for (var element in entries.docs) {
      sum += (element['price'] - collection.gomlahPrice) * element['quantity'];
    }

    return sum;
  }

  /// Initializes the entries for each category.
  _initEntries() async {
    for (int i = 0; i < categories.length; i++) {
      categories[i].entries = await _getEntry(categories[i].id!);
    }
    update();
  }

  /// Fetches all entries for a specific collection ID.
  Future<List<EntriesModel>> _getEntry(String id) async {
    List<EntriesModel> entries = [];
    final result = await FirebaseService.entriesCollection(id).get();

    for (var element in result.docs) {
      entries.add(EntriesModel.fromJson(element.data(), id: element.id));
    }
    return entries;
  }

  /// Deletes a category after confirmation.
  void deleteCategory(String? id) {
    Get.defaultDialog(
      title: 'حذف التصنيف',
      middleText: 'هل انت متاكد من حذف هذا التصنيف؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      onConfirm: () async {
        isLoading = true;
        update();
        try {
          Get.back();
          // Delete the collection document from Firebase.
          await FirebaseService.collectionsCollection.doc(id).delete();
          // Remove the category from the local list.
          categories.removeWhere((element) => element.id == id);
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف التصنيف بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Refresh the list of collections.
          getCollections();
        } on FirebaseException catch (e) {
          isLoading = false;
          Get.snackbar(
            'خطأ',
            e.message.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        update();
      },
    );
  }

  /// Calculates the total profit across all categories.
  String allProfits() {
    num sum = 0;
    for (var element in categories) {
      sum += element.profits ?? 0;
    }
    return sum.toString();
  }

  /// Exports all client entries to an Excel file.
  exportExcel() async {
    try {
      // Get current date and time for the filename.
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';

      final fileName = 'تقرير_العملاء_$dateStr - $timeStr.xlsx';

      // Request storage permission.
      PermissionStatus manageStatus =
          await Permission.manageExternalStorage.status;

      log('Initial Manage Status: $manageStatus');
      log((await Permission.manageExternalStorage.request()).name);

      if (!manageStatus.isGranted) {
        await Permission.manageExternalStorage.request();
        // Re-check status after request
        manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          Get.snackbar(
            'خطأ',
            'لا يوجد صلاحية للتخزين على الهاتف',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      exporting = true;
      update();

      var excel = Excel.createExcel();
      final List<String> headers = [
        'اسم العميل',
        'العنوان',
        'الموقع الحالي',
        'رقم الهاتف',
        'السعر',
        'الكمية',
      ];

      // Create a new sheet for each category and populate it with data.
      for (int i = 0; i < categories.length; i++) {
        Sheet sheetObject = excel[categories[i].name];
        // Add headers to the sheet.
        for (int index = 0; index < headers.length; index++) {
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 0))
              .value = TextCellValue(headers[index]);
        }
        // Add entry data to the sheet.
        for (int j = 0; j < categories[i].entries.length; j++) {
          final entry = categories[i].entries[j];
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: j + 1))
              .value = TextCellValue(entry.clientName);
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: j + 1))
              .value = TextCellValue(entry.address);
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: j + 1))
              .value = TextCellValue(entry.currentLocation);
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: j + 1))
              .value = TextCellValue(entry.phoneNumber);
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: j + 1))
              .value = TextCellValue(entry.price.toString());
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: j + 1))
              .value = TextCellValue(entry.quantity.toString());
        }
      }

      var bytes = excel.save();
      // Save the file to the device's Download directory.
      var downloadPath = Directory('/storage/emulated/0/Download');

      File('${downloadPath.path}/$fileName').writeAsBytes(bytes!);
      exporting = false;
      Get.snackbar(
        'تم',
        'تم انشاء الملف بنجاح في مجلد التحميلات',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      log('Excel file saved to: ${downloadPath.path}/$fileName');
      update();
    } catch (e) {
      // Catching a generic exception is better here
      exporting = false;
      Get.snackbar(
        'خطأ',
        e.toString(), // Provide more specific error message
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      update();
    }
  }
}
