import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/user_model.dart';

class AllMandobController extends GetxController {
  List<UserModel> mandobs = [];
  bool isLoading = false;

  @override
  void onInit() {
    getMandobs();
    super.onInit();
  }

  Future<void> getMandobs() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.usersCollection
          .where('user_type', isEqualTo: 'mandob')
          .get();
      mandobs = result.docs
          .map(
            (e) => UserModel.fromJson(
              e.data(),
              id: e.id,
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

  void deleteMandob(String? id) {
    Get.defaultDialog(
      title: 'حذف المندوب',
      middleText: 'هل انت متاكد من حذف هذا المندوب؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      onConfirm: () async {
        isLoading = true;
        update();
        try {
          await FirebaseService.usersCollection.doc(id).delete();
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف المندوب بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          getMandobs();
          Navigator.pop(Get.context!);
        } on FirebaseException catch (e) {
          isLoading = false;
          Get.snackbar(
            'خطأ',
            e.message.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
