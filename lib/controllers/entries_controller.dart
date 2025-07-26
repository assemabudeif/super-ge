import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/entries_model.dart';

/// A controller for managing entries within a specific collection.
///
/// This class handles fetching all entries for a given collection from Firebase,
/// calculating total profits for those entries, and provides functionality for deleting an entry.
class EntriesController extends GetxController {
  // A list to hold all the entry models for the collection.
  List<EntriesModel> entries = [];
  // The ID of the collection whose entries are being managed.
  String collectionId = '';
  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;
  // The wholesale price for the collection, used to calculate profits.
  num gomlahPrice = 0;

  @override
  void onInit() {
    // Retrieve arguments passed from the previous screen.
    collectionId = Get.arguments?['id'] ?? '';
    gomlahPrice = Get.arguments?['gomlahPrice'] ?? 0;
    // Fetch the entries when the controller is initialized.
    getEntries();
    super.onInit();
  }

  /// Fetches all entries for the current `collectionId` from Firebase.
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

  /// Deletes an entry after confirmation.
  Future<void> deleteEntry(String id) async {
    Get.defaultDialog(
      title: 'حذف القائمة',
      middleText: 'هل انت متاكد من حذف هذه القائمة؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      onConfirm: () async {
        Get.back();
        isLoading = true;
        update();
        try {
          // Delete the entry document from the subcollection in Firebase.
          await FirebaseService.entriesCollection(collectionId)
              .doc(id)
              .delete();
          // Remove the entry from the local list.
          entries.removeWhere((element) => element.id == id);
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف القائمة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
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
      },
    );
  }

  /// Calculates the total profit for all entries in the list.
  ///
  /// Profit is calculated as (entry price - wholesale price) * quantity for each entry.
  String allProfits() {
    num sum = 0;
    for (var element in entries) {
      sum += (element.price - gomlahPrice) * element.quantity;
    }
    return sum.toString();
  }
}
