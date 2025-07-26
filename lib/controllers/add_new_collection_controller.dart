import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/admin_home_controller.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';

/// A controller class for managing the addition of new collections.
///
/// This class handles the form state, validation, and submission logic
/// for creating a new collection in the application.
class AddNewCollectionController extends GetxController {
  // A global key for the form to handle validation.
  final formKey = GlobalKey<FormState>();

  // Text editing controllers for the collection details.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startSellPriceController =
      TextEditingController();
  final TextEditingController endSellPriceController = TextEditingController();
  final TextEditingController gomlahPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // A flag to indicate if the controller is currently processing a request.
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose all text editing controllers to free up resources.
    nameController.dispose();
    startSellPriceController.dispose();
    endSellPriceController.dispose();
    gomlahPriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  /// Submits the form to create a new collection.
  ///
  /// This method validates the form, parses the input values, performs
  /// additional validation (e.g., start price vs. end price), and then
  /// adds the new collection to Firebase.
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

      // Validate that the start selling price is not greater than the end selling price.
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
        // Add the new collection to the Firebase 'collections' collection.
        FirebaseService.collectionsCollection.add(
          CollectionsModel(
                  name: name,
                  startSellPrice: startSellPrice,
                  endSellPrice: endSellPrice,
                  gomlahPrice: gomlahPrice,
                  quantity: quantity)
              .toJson(),
        );
        Get.back(); // Go back to the previous screen.
        Get.snackbar(
          'تم',
          'تم اضافة التصنيف بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh the collections list on the admin home screen.
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
