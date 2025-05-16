import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';

class BillsController extends GetxController {
  List<Map<String, dynamic>> bills = [];
  bool isLoading = false;

  @override
  void onInit() {
    fetchBills();
    super.onInit();
  }

  Future<void> fetchBills() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.billsCollection
          .orderBy('timestamp', descending: true)
          .get();
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

  Future<void> deleteBill(String billId) async {
    try {
      await FirebaseService.billsCollection.doc(billId).delete();
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
