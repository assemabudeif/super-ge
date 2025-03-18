import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/note_model.dart';

class AllNotesController extends GetxController {
  List<NoteModel> clientNotes = [];
  List<NoteModel> mandobNotes = [];

  bool isLoading = false;

  @override
  void onInit() {
    getNotes();
    super.onInit();
  }

  Future<void> getNotes() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.notesCollection.get();
      clientNotes = result.docs
          .where((e) => e.data()['type'] == 'client')
          .map(
            (e) => NoteModel.fromJson(
              e.data(),
              id: e.id,
            ),
          )
          .toList();

      mandobNotes = result.docs
          .where((e) => e.data()['type'] == 'mandob')
          .map(
            (e) => NoteModel.fromJson(
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

  deleteNote(String id) {
    Get.defaultDialog(
      title: 'حذف الملاحظة',
      middleText: 'هل انت متاكد من حذف هذا الملاحظة؟',
      textConfirm: 'نعم',
      textCancel: 'لا',
      onConfirm: () async {
        isLoading = true;
        update();
        try {
          await FirebaseService.notesCollection.doc(id).delete();
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف الملاحظة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          getNotes();
          Navigator.pop(Get.context!);
        } on FirebaseException catch (e) {
          isLoading = false;
          Get.snackbar(
            'خطأ',
            e.message.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
