import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/user_model.dart';

import 'all_mandob_controller.dart';

/// A controller for adding a new representative (Mandob).
///
/// This class manages the form state, validation, and submission logic
/// for creating a new representative user in the system.
class AddNewMandobController extends GetxController {
  // A global key for the form to handle validation.
  final fromKey = GlobalKey<FormState>();

  // Text editing controllers for the representative's details.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // A flag to indicate if the controller is currently processing a request.
  bool isLoading = false;

  /// Submits the form to create a new representative.
  ///
  /// This method validates the form, creates a `UserModel` instance,
  /// and adds it to the Firebase 'users' collection.
  Future<void> submitForm() async {
    if (fromKey.currentState?.validate() ?? false) {
      isLoading = true;
      update();

      // Create a UserModel instance for the new representative.
      final user = UserModel(
        name: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
        userType: "mandob", // Set user type to 'mandob'.
      );

      try {
        // Add the new user to the Firebase 'users' collection.
        await FirebaseService.usersCollection.add(user.toJson());

        Get.snackbar(
          'تم',
          'تم اضافة المندوب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh the list of representatives on the 'AllMandobScreen'.
        await Get.put(AllMandobController()).getMandobs();
        isLoading = false;
        Navigator.pop(Get.context!); // Go back to the previous screen.

        update();
      } catch (e) {
        isLoading = false;
        update();
        Get.snackbar(
          'خطأ',
          'حدث خطأ في اضافة المندوب',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    // Dispose all text editing controllers to free up resources.
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
