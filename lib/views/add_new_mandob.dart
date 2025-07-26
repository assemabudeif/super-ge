import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_mandob_controller.dart';

/// A screen for adding a new representative (Mandob).
///
/// This view provides a simple form for an admin to create a new representative
/// by providing their name, phone number, and a password.
class AddNewMandob extends StatelessWidget {
  const AddNewMandob({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewMandobController>(
      init: AddNewMandobController(),
      builder: (AddNewMandobController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('اضافة مندوب'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.fromKey,
              child: Column(
                children: [
                  // Name Text Field
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(labelText: 'اسم المندوب'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Phone Number Text Field
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: const InputDecoration(labelText: 'رقم المندوب'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرقم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Text Field
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمة المرور مطلوبة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Loading indicator or Submit button
                  if (controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.submitForm();
                        },
                        child: const Text('اضافة مندوب'),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
