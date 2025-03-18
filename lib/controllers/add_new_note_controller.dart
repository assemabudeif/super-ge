import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/firebase_service.dart';
import 'package:super_ge/models/note_model.dart';

import 'all_notes_controller.dart';

enum NoteType { client, mandob }

extension NoteTypeExtension on NoteType {
  String get text => switch (this) {
        NoteType.client => 'عميل',
        NoteType.mandob => 'مندوب',
      };
}

class AddNewNoteController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  NoteType selectedType = NoteType.client;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void changeType(NoteType value) {
    selectedType = value;
    update();
  }

  Future<void> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      isLoading = true;
      update();
      try {
        final note = NoteModel(
          name: nameController.text,
          amount: amountController.text,
          type: selectedType.name,
        );
        await FirebaseService.notesCollection.add(note.toJson());
        Get.back();
        Get.snackbar(
          'تم',
          'تم اضافة الملاحظة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading = false;
        update();
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
