import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/add_new_client_entry_controller.dart';
import 'package:super_ge/core/theme/app_colors.dart';

/// A screen for adding a new client entry, which includes creating a new bill.
///
/// This view allows the user (a representative) to input client information,
/// select items from available collections, specify quantities and prices,
/// and submit the information to create a new bill and associated financial entries.
class AddNewClientEntry extends StatelessWidget {
  const AddNewClientEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewClientEntryController>(
      init: AddNewClientEntryController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('إضافة فاتورة جديدة'),
          centerTitle: true,
        ),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client Information Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'معلومات العميل',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Client Name Text Field
                              TextFormField(
                                controller: controller.clientNameController,
                                decoration: InputDecoration(
                                  labelText: 'اسم العميل',
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
                                controller:
                                    controller.currentLocationController,
                                decoration: InputDecoration(
                                  labelText: 'الموقع الحالي',
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Collections Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'التصنيفات',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Dynamically generate a list of available collections.
                              ...controller.availableCollections.map(
                                (collection) => Column(
                                  children: [
                                    CheckboxListTile(
                                      title: Text(collection.name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الكمية المتوفرة: ${collection.quantity}',
                                          ),
                                          Text(
                                            'السعر: ${collection.startSellPrice} - ${collection.endSellPrice} جنيه',
                                          ),
                                        ],
                                      ),
                                      value: controller.selectedCollections
                                          .contains(collection),
                                      onChanged: (_) => controller
                                          .toggleCollection(collection),
                                    ),
                                    // Show quantity and price fields if the collection is selected.
                                    if (controller.selectedCollections
                                        .contains(collection))
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            // Quantity Text Field
                                            Expanded(
                                              child: TextFormField(
                                                controller: controller
                                                        .quantityControllers[
                                                    collection.id!],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'الكمية',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'الرجاء إدخال الكمية';
                                                  }
                                                  if (int.tryParse(
                                                          value.trim()) ==
                                                      null) {
                                                    return 'الرجاء إدخال رقم صحيح';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Price Text Field
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    controller.priceControllers[
                                                        collection.id!],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: 'السعر',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'الرجاء إدخال السعر';
                                                  }
                                                  if (double.tryParse(
                                                          value.trim()) ==
                                                      null) {
                                                    return 'الرجاء إدخال رقم صحيح';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Total Price Display
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                "الاجمالي: ${controller.totalPrice} جنيه",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إضافة',
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
    );
  }
}
