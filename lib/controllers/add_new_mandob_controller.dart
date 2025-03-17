import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/user_model.dart';

import 'all_mandob_controller.dart';

class AddNewMandobController extends GetxController {
  final fromKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> submitForm() async {
    if (fromKey.currentState?.validate() ?? false) {
      isLoading = true;
      update();

      final user = UserModel(
        name: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
        userType: "mandob",
      );

      try {
        await FirebaseService.usersCollection.add(user.toJson());

        Get.snackbar(
          'تم',
          'تم اضافة المندوب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await Get.put(AllMandobController()).getMandobs();
        isLoading = false;
        Navigator.pop(Get.context!);

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
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
