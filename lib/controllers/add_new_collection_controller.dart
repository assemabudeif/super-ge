import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/admin_home_controller.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';

class AddNewCollectionController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startSellPriceController =
      TextEditingController();
  final TextEditingController endSellPriceController = TextEditingController();
  final TextEditingController gomlahPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    startSellPriceController.dispose();
    endSellPriceController.dispose();
    gomlahPriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      update();

      final String name = nameController.text.trim();
      final int startSellPrice =
          int.parse(startSellPriceController.text.trim());
      final int endSellPrice = int.parse(endSellPriceController.text.trim());
      final int gomlahPrice = int.parse(gomlahPriceController.text.trim());
      final int quantity = int.parse(quantityController.text.trim());

      if (startSellPrice > endSellPrice) {
        isLoading = false;
        update();
        Get.snackbar(
          'خطأ',
          'اقل سعر البيع يجب ان يكون اقل من اعلى سعر البيع',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        FirebaseService.collectionsCollection.add(
          CollectionsModel(
                  name: name,
                  startSellPrice: startSellPrice,
                  endSellPrice: endSellPrice,
                  gomlahPrice: gomlahPrice,
                  quantity: quantity)
              .toJson(),
        );
        Get.back();
        Get.snackbar(
          'تم',
          'تم اضافة التصنيف بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.put(AdminHomeController()).getCollections();
        isLoading = false;
        update();
      } catch (e) {
        isLoading = false;
        update();
        Get.snackbar(
          'خطأ',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
