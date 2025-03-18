import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/entries_model.dart';

class EntriesController extends GetxController {
  List<EntriesModel> entries = [];
  String collectionId = '';
  bool isLoading = false;
  num gomlahPrice = 0;

  @override
  void onInit() {
    collectionId = Get.arguments?['id'] ?? '';
    gomlahPrice = Get.arguments?['gomlahPrice'] ?? 0;
    getEntries();
    super.onInit();
  }

  Future<void> getEntries() async {
    isLoading = true;
    update();
    try {
      final result =
          await FirebaseService.entriesCollection(collectionId).get();
      entries = result.docs
          .map(
            (e) => EntriesModel.fromJson(
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

  String allProfits() {
    num sum = 0;
    for (var element in entries) {
      sum += (element.price - gomlahPrice);
    }
    return sum.toString();
  }
}
