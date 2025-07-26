import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_note_controller.dart';

/// A screen for adding a new note.
///
/// This view provides a form for a user to create a new note, specifying
/// a name (for a client or representative), an amount, and the type of note
/// (client or representative) using a dropdown menu.
class AddNewNote extends StatelessWidget {
  const AddNewNote({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewNoteController>(
      init: AddNewNoteController(),
      builder: (AddNewNoteController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('إضافة ملاحظة جديدة'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // Name Text Field
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(labelText: 'الاسم'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Amount Text Field
                  TextFormField(
                    controller: controller.amountController,
                    decoration: const InputDecoration(labelText: 'المبلغ'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'المبلغ مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Note Type Dropdown
                  DropdownButtonFormField<NoteType>(
                    value: controller.selectedType,
                    onChanged: (value) {
                      controller.changeType(value!);
                    },
                    items: NoteType.values.map((NoteType type) {
                      return DropdownMenuItem<NoteType>(
                        value: type,
                        child: Text(type.text),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'النوع',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Loading indicator or Submit button
                  if (controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.submitForm,
                        child: const Text('حفظ الملاحظة'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
