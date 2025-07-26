import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_entry_controller.dart';

/// A screen for adding a single new financial entry for a specific collection.
///
/// This view provides a form for a representative to input client details,
/// quantity, and price for a single item type. This is an alternative to the
/// more complex bill creation screen (`AddNewClientEntry`).
class AddNewEntry extends StatelessWidget {
  const AddNewEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewEntryController>(
      init: AddNewEntryController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم المندوب'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'نموذج البيانات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Client Name Text Field
                      TextFormField(
                        controller: controller.clientNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم العميل',
                          hintText: 'أدخل اسم العميل',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال اسم العميل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Phone Number Text Field
                      TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          hintText: 'أدخل رقم الهاتف',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Address Text Field
                      TextFormField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          labelText: 'العنوان',
                          hintText: 'أدخل العنوان',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال العنوان';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Current Location Text Field
                      TextFormField(
                        controller: controller.currentLocationController,
                        decoration: InputDecoration(
                          labelText: 'الموقع الحالي',
                          hintText: 'أدخل الموقع الحالي',
                          prefixIcon: const Icon(Icons.map),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال الموقع الحالي';
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
                          prefixIcon: const Icon(Icons.format_list_numbered),
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
                      const SizedBox(height: 16),
                      // Price Text Field
                      TextFormField(
                        controller: controller.priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'السعر',
                          hintText: 'أدخل السعر',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال السعر';
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return 'الرجاء إدخال رقم صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      if (controller.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'إرسال',
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
  }
}
