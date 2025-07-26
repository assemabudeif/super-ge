import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';

/// A controller for managing bills.
///
/// This class handles fetching all bills from Firebase and provides
/// functionality for deleting a bill.
class BillsController extends GetxController {
  // A list to hold all the bill data.
  List<Map<String, dynamic>> bills = [];
  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;

  @override
  void onInit() {
    // Fetch all bills when the controller is initialized.
    fetchBills();
    super.onInit();
  }

  /// Fetches all bills from the Firebase 'bills' collection, ordered by timestamp.
  Future<void> fetchBills() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.billsCollection
          .orderBy('timestamp', descending: true)
          .get();
      // Map the documents to a list of maps, including the document ID.
      bills = result.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل الفواتير',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading = false;
    update();
  }

  /// Deletes a bill from Firebase.
  Future<void> deleteBill(String billId) async {
    try {
      // Delete the bill document from Firebase.
      await FirebaseService.billsCollection.doc(billId).delete();
      // Remove the bill from the local list.
      bills.removeWhere((bill) => bill['id'] == billId);
      update();
      Get.snackbar('تم', 'تم حذف الفاتورة بنجاح',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء حذف الفاتورة',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
