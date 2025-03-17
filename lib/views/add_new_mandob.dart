import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_mandob_controller.dart';

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
                  if (controller.isLoading)
                    Center(child: const CircularProgressIndicator())
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
