import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/collections_model.dart';
import 'package:super_ge/models/entries_model.dart';
import 'package:super_ge/views/mandob_home.dart';

import 'mandob_home_controller.dart';

/// A controller for adding a new entry for a specific collection.
///
/// This class manages the form state, validation, and submission logic
/// for creating a single new entry associated with a collection.
class AddNewEntryController extends GetxController {
  // The collection for which the new entry is being added.
  CollectionsModel? collection;

  // A global key for the form to handle validation.
  final formKey = GlobalKey<FormState>();

  // Text editing controllers for the entry details.
  final clientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final currentLocationController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  // A flag to indicate if the controller is currently processing a request.
  bool isLoading = false;

  @override
  void onInit() {
    // Retrieve the collection model passed as an argument.
    collection = Get.arguments?['model'] as CollectionsModel?;
    super.onInit();
  }

  /// Submits the new entry form.
  ///
  /// This method validates the form inputs, checks against available quantity
  /// and price ranges, and then creates the new entry in Firebase. It also
  /// updates the collection's quantity.
  submit() async {
    if (collection == null) return;

    // Validate the entered quantity against the available quantity.
    num newQuantity = collection!.quantity - num.parse(quantityController.text);
    if (newQuantity < 0) {
      // Corrected logic to check if newQuantity is less than 0
      Get.snackbar(
        'خطأ',
        'الكمية المدخلة أكبر من الكمية المتبقية للتصنيف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      // Validate the entered price against the allowed selling price range.
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
        // Add the new entry to the 'entries' subcollection in Firebase.
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

        // Update the quantity of the collection.
        await FirebaseService.collectionsCollection.doc(collection!.id).update({
          'quantity': newQuantity,
        });

        Get.snackbar(
          'تم',
          'تم اضافة المدخل بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading = false;
        update();
        // Show a dialog for confirmation and sharing options.
        submitDialog();
        // Refresh the collections list on the representative's home screen.
        Get.put(MandobHomeController()).getCollections();
      } on FirebaseException catch (e) {
        isLoading = false;
        update(); // Added update to reflect loading state change on error
        Get.snackbar(
          'خطأ',
          e.message.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Shows a dialog after successful submission with options to navigate
  /// home or share the entry details via WhatsApp.
  submitDialog() {
    Get.defaultDialog(
      title: "تمت الاضافه",
      middleText: "تم اضافة المدخل بنجاح",
      textConfirm: "حسنا",
      textCancel: "مشاركة علي الواتساب",
      onConfirm: () => Get.offAll(() => const MandobHome()),
      onCancel: () {
        // Share the entry details using the share_plus package.
        Share.share(
          """
اسم العميل : ${clientNameController.text.trim()}
رقم الجوال : ${phoneController.text.trim()}
العنوان : ${addressController.text.trim()}
الموقع الحالي : ${currentLocationController.text.trim()}
الكمية : ${quantityController.text.trim()}
السعر : ${priceController.text.trim()}
""",
          subject: "مدخل جديد",
        );
      },
    );
  }

  @override
  void onClose() {
    // Dispose all text editing controllers to free up resources.
    clientNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    currentLocationController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
