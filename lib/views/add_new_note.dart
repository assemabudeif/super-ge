import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_note_controller.dart';

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
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(labelText: 'اسم العميل'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  ),
                  const SizedBox(height: 16),
                  if (controller.isLoading)
                    Center(child: const CircularProgressIndicator())
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
