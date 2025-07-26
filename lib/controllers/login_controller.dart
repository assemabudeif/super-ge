import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/views/admin_home.dart';
import 'package:super_ge/views/mandob_home.dart';

/// A controller for handling user login.
///
/// This class manages the form state, validation, and submission logic
/// for user authentication. It communicates with Firebase to verify user
/// credentials and navigates to the appropriate home screen based on user type.
class LoginController extends GetxController {
  // A global key for the form to handle validation.
  final formKey = GlobalKey<FormState>();
  // Observable variables for phone, password, and password visibility.
  var phone = ''.obs;
  var password = ''.obs;
  var hidePassword = true.obs;
  // A flag to indicate if the login process is in progress.
  bool isLoading = false;

  /// Toggles the visibility of the password field.
  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  /// Attempts to log in the user with the provided credentials.
  ///
  /// This method validates the form, queries Firebase for a matching user,
  /// saves user data to shared preferences upon successful login, and navigates
  /// to the corresponding home screen (`AdminHome` or `MandobHome`).
  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      isLoading = true;
      update();
      try {
        // Query Firebase for a user with matching phone and password.
        final result = await FirebaseService.usersCollection
            .where('phone', isEqualTo: phone.value)
            .where('password', isEqualTo: password.value)
            .get();

        if (result.docs.isNotEmpty) {
          // Save user information to shared preferences.
          AppPreferences.instance.saveUserId(result.docs[0].id);
          AppPreferences.instance.saveName(result.docs[0].data()['name']);
          AppPreferences.instance.savePhone(result.docs[0].data()['phone']);
          AppPreferences.instance.saveUserType(
            result.docs[0].data()['user_type'],
          );
          log(result.docs[0].data().toString());
          // Navigate to the appropriate screen based on user type.
          if (result.docs[0].data()['user_type'] == 'admin') {
            Get.off(
              () => const AdminHome(),
            );
          } else {
            Get.off(
              () => const MandobHome(),
            );
          }
        } else {
          // Show an error if no matching user is found.
          Get.snackbar(
            'خطأ',
            'اسم المستخدم او كلمة المرور غير صحيحة',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

        isLoading = false;
        update();
      } catch (e) {
        log(e.toString());
        isLoading = false;
        update();
        // Show a generic error snackbar in case of an exception.
        Get.snackbar(
          'خطأ',
          'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
