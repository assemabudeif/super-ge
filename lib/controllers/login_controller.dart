import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/views/admin_home.dart';
import 'package:super_ge/views/mandob_home.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var phone = ''.obs;
  var password = ''.obs;
  var hidePassword = true.obs;
  bool isLoading = false;

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      isLoading = true;
      update();
      try {
        final result = await FirebaseService.usersCollection
            .where('phone', isEqualTo: phone.value)
            .where('password', isEqualTo: password.value)
            .get();

        if (result.docs.isNotEmpty) {
          AppPreferences.instance.saveUserId(result.docs[0].id);
          AppPreferences.instance.saveName(result.docs[0].data()['name']);
          AppPreferences.instance.savePhone(result.docs[0].data()['phone']);
          AppPreferences.instance.saveUserType(
            result.docs[0].data()['user_type'],
          );
          log(result.docs[0].data().toString());
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
      }
    }
  }
}
