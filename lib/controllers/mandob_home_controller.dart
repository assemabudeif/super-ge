import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';

/// A controller for the representative's (Mandob's) home screen.
///
/// This class manages the state and logic for the representative's dashboard,
/// primarily fetching the list of available collections (categories) from Firebase.
class MandobHomeController extends GetxController {
  // A list to hold all the collection models.
  List<CollectionsModel> categories = [];
  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;
  // Retrieves the representative's name and phone from shared preferences.
  final name = AppPreferences.instance.getName();
  final phone = AppPreferences.instance.getPhone();

  @override
  void onInit() {
    // Fetch the collections when the controller is initialized.
    getCollections();
    super.onInit();
  }

  /// Fetches all collections from the Firebase Firestore.
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
