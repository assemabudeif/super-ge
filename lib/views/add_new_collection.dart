import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_new_collection_controller.dart';

/// A screen for adding a new collection (category).
///
/// This view provides a form for an admin to create a new collection by
/// providing details such as name, selling price range, wholesale price, and quantity.
/// It features a modern UI with a gradient background and a card-based form.
class AddNewCollection extends StatelessWidget {
  const AddNewCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewCollectionController>(
      init: AddNewCollectionController(),
      builder: (AddNewCollectionController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('إضافة تصنيف جديد'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              // A modern gradient background.
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3F51B5),
                  Color(0xFF2196F3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'إضافة تصنيف جديد',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Name Text Field
                          TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              labelText: 'الاسم',
                              hintText: 'أدخل الاسم',
                              prefixIcon: const Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال الاسم';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Start Sell Price Text Field
                          TextFormField(
                            controller: controller.startSellPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'اقل سعر',
                              hintText: 'ادخل اقل سعر للبيع',
                              prefixIcon: const Icon(Icons.attach_money),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال اقل سعر للبيع';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'الرجاء إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // End Sell Price Text Field
                          TextFormField(
                            controller: controller.endSellPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'اعلى سعر',
                              hintText: 'أدخل اعلى سعر للبيع',
                              prefixIcon: const Icon(Icons.money_off),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال اعلى سعر للبيع';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'الرجاء إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Wholesale Price Text Field
                          TextFormField(
                            controller: controller.gomlahPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'سعر الجملة',
                              hintText: 'أدخل سعر الجملة',
                              prefixIcon: const Icon(Icons.money),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال سعر الجملة';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'الرجاء إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Quantity Text Field
                          TextFormField(
                            controller: controller.quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'الكمية',
                              hintText: 'أدخل الكمية',
                              prefixIcon:
                                  const Icon(Icons.format_list_numbered),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'الرجاء إدخال الكمية';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'الرجاء إدخال رقم صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          // Loading indicator or Submit button
                          if (controller.isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.submitForm,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'إضافة المجموعة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
