import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';

class AdminHomeController extends GetxController {
  List<CollectionsModel> categories = [];
  bool isLoading = false;
  final name = AppPreferences.instance.getName();
  final phone = AppPreferences.instance.getPhone();

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
}
