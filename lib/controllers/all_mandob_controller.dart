import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/user_model.dart';

/// A controller for managing the list of all representatives (Mandobs).
///
/// This class handles fetching the list of representatives from Firebase
/// and provides functionality for deleting a representative.
class AllMandobController extends GetxController {
  // A list to hold all the representative user models.
  List<UserModel> mandobs = [];
  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;

  @override
  void onInit() {
    // Fetch the list of representatives when the controller is initialized.
    getMandobs();
    super.onInit();
  }

  /// Fetches all users with the 'mandob' user type from Firebase.
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

  /// Deletes a representative after confirmation.
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
          // Delete the user document from Firebase.
          await FirebaseService.usersCollection.doc(id).delete();
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف المندوب بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Refresh the list of representatives.
          getMandobs();
          Navigator.pop(Get.context!); // Close the dialog.
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
