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

class AdminHomeController extends GetxController {
  List<CollectionsModel> categories = [];
  bool isLoading = false;
  final name = AppPreferences.instance.getName();
  final phone = AppPreferences.instance.getPhone();
  bool exporting = false;

  @override
  Future<void> onInit() async {
    await getCollections();
    await _initEntries();

    await calculateProfits();

    super.onInit();
  }

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

  calculateProfits() async {
    for (var element in categories) {
      element.profits = await getCollectionProfits(element);
    }
    update();
  }

  Future<num> getCollectionProfits(CollectionsModel collection) async {
    num sum = 0;
    final entries =
        await FirebaseService.entriesCollection(collection.id!).get();

    for (var element in entries.docs) {
      sum += (element['price'] - collection.gomlahPrice) * element['quantity'];
    }

    return sum;
  }

  _initEntries() async {
    for (int i = 0; i < categories.length; i++) {
      categories[i].entries = await _getEntry(categories[i].id!);
    }
    update();
  }

  Future<List<EntriesModel>> _getEntry(String id) async {
    List<EntriesModel> entries = [];
    final result = await FirebaseService.entriesCollection(id).get();

    for (var element in result.docs) {
      entries.add(EntriesModel.fromJson(element.data(), id: element.id));
    }
    return entries;
  }

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
          await FirebaseService.collectionsCollection.doc(id).delete();
          categories.removeWhere((element) => element.id == id);
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف التصنيف بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
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

  String allProfits() {
    num sum = 0;
    for (var element in categories) {
      sum += element.profits ?? 0;
    }
    return sum.toString();
  }

  exportExcel() async {
    try {
      // Get current date and time in Arabic format
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';

      final fileName = 'تقرير_العملاء_$dateStr - $timeStr.xlsx';

      PermissionStatus manageStatus =
          await Permission.manageExternalStorage.status;

      log('Initial Manage Status: $manageStatus');
      log((await Permission.manageExternalStorage.request()).name);

      if (!manageStatus.isGranted) {
        await Permission.manageExternalStorage.request();

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
      for (int i = 0; i < categories.length; i++) {
        Sheet sheetObject = excel[categories[i].name];
        for (int index = 0; index < headers.length; index++) {
          sheetObject
              .cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 0))
              .value = TextCellValue(headers[index]);
        }
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
      var downloadPath = Directory('/storage/emulated/0/Download');

      File('${downloadPath.path}/$fileName').writeAsBytes(bytes!);
      exporting = false;
      Get.snackbar(
        'تم',
        'تم انشاء الملف بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      log('${downloadPath.path}/$fileName');
      update();
    } on FirebaseException catch (e) {
      exporting = false;
      Get.snackbar(
        'خطأ',
        e.message.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      update();
    }
  }
}
