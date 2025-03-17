import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';

class MandobHomeController extends GetxController {
  List<CollectionsModel> categories = [];
  bool isLoading = false;

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
}
