import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/note_model.dart';

/// A controller for managing all notes, separated by type (client and representative).
///
/// This class handles fetching all notes from Firebase, categorizing them,
/// and provides functionality for deleting a note.
class AllNotesController extends GetxController {
  // A list to hold all notes related to clients.
  List<NoteModel> clientNotes = [];
  // A list to hold all notes related to representatives (mandobs).
  List<NoteModel> mandobNotes = [];

  // A flag to indicate if data is currently being loaded.
  bool isLoading = false;

  @override
  void onInit() {
    // Fetch all notes when the controller is initialized.
    getNotes();
    super.onInit();
  }

  /// Fetches all notes from Firebase and separates them into client and representative lists.
  Future<void> getNotes() async {
    isLoading = true;
    update();
    try {
      final result = await FirebaseService.notesCollection.get();
      // Filter and map notes for clients.
      clientNotes = result.docs
          .where((e) => e.data()['type'] == 'client')
          .map(
            (e) => NoteModel.fromJson(
              e.data(),
              id: e.id,
            ),
          )
          .toList();

      // Filter and map notes for representatives.
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

  /// Deletes a note after confirmation.
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
          // Delete the note document from Firebase.
          await FirebaseService.notesCollection.doc(id).delete();
          isLoading = false;
          Get.snackbar(
            'تم',
            'تم حذف الملاحظة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Refresh the notes list.
          getNotes();
          Navigator.pop(Get.context!); // Close the dialog.
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
