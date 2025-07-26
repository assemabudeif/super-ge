import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/note_model.dart';

import 'all_notes_controller.dart';

/// An enum to define the type of the note, either for a client or a representative.
enum NoteType { client, mandob }

/// An extension on [NoteType] to provide a display text for each type.
extension NoteTypeExtension on NoteType {
  String get text => switch (this) {
        NoteType.client => 'عميل',
        NoteType.mandob => 'مندوب',
      };
}

/// A controller for adding a new note.
///
/// This class manages the form state, validation, and submission logic
/// for creating a new note for either a client or a representative.
class AddNewNoteController extends GetxController {
  // A global key for the form to handle validation.
  final formKey = GlobalKey<FormState>();

  // Text editing controllers for the note details.
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  // The currently selected note type.
  NoteType selectedType = NoteType.client;

  // A flag to indicate if the controller is currently processing a request.
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose all text editing controllers to free up resources.
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  /// Changes the selected note type.
  void changeType(NoteType value) {
    selectedType = value;
    update();
  }

  /// Submits the form to create a new note.
  ///
  /// This method validates the form, creates a `NoteModel` instance,
  /// and adds it to the Firebase 'notes' collection.
  Future<void> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      isLoading = true;
      update();
      try {
        // Create a NoteModel instance from the form data.
        final note = NoteModel(
          name: nameController.text,
          amount: amountController.text,
          type: selectedType.name,
        );
        // Add the new note to the Firebase 'notes' collection.
        await FirebaseService.notesCollection.add(note.toJson());
        Get.back(); // Go back to the previous screen.
        Get.snackbar(
          'تم',
          'تم اضافة الملاحظة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading = false;
        update();
        // Refresh the notes list on the 'AllNotesScreen'.
        await Get.put(AllNotesController()).getNotes();
      } catch (e) {
        Get.snackbar(
          'خطأ',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading = false;
        update();
      }
    }
  }
}
