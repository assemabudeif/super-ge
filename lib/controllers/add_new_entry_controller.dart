import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';
import 'package:super_ge/models/entries_model.dart';

import 'mandob_home_controller.dart';

class AddNewEntryController extends GetxController {
  CollectionsModel? collection;
  final formKey = GlobalKey<FormState>();
  final clientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final currentLocationController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  bool isLoading = false;

  @override
  void onInit() {
    collection = Get.arguments?['model'] as CollectionsModel?;

    super.onInit();
  }

  submit() async {
    if (collection == null) return;
    int newQuantity = collection!.quantity - int.parse(quantityController.text);
    if (newQuantity <= 0) {
      Get.snackbar(
        'خطأ',
        'الكميه المتبقيه للتصنيف اقل من الكميه المدخله',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      if (num.parse(priceController.text) > collection!.endSellPrice ||
          num.parse(priceController.text) < collection!.startSellPrice) {
        Get.snackbar(
          'خطأ',
          'السعر يجب ان يكون بين ${collection!.startSellPrice} و ${collection!.endSellPrice}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      isLoading = true;
      update();
      try {
        await FirebaseService.entriesCollection(collection?.id ?? '').add(
          EntriesModel(
            clientName: clientNameController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            address: addressController.text.trim(),
            currentLocation: currentLocationController.text.trim(),
            quantity: int.parse(quantityController.text.trim()),
            price: int.parse(
              priceController.text.trim(),
            ),
          ).toJson(),
        );

        await FirebaseService.collectionsCollection.doc(collection!.id).update({
          'quantity': newQuantity,
        });

        Get.back();

        Get.snackbar(
          'تم',
          'تم اضافة المدخل بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading = false;
        update();
        Get.put(MandobHomeController()).getCollections();
      } on FirebaseException catch (e) {
        isLoading = false;
        Get.snackbar(
          'خطأ',
          e.message.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void onClose() {
    clientNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    currentLocationController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
