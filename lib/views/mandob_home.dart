import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/functions/logout.dart';
import 'package:super_ge/core/theme/app_colors.dart';
import 'package:super_ge/views/add_new_client_entry.dart';
import 'package:super_ge/views/all_notes.dart';

import 'add_new_entry.dart';
import '../controllers/mandob_home_controller.dart';

class MandobHome extends GetView<MandobHomeController> {
  const MandobHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MandobHomeController>(
      init: MandobHomeController(),
      builder: (controller) => Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة التحكم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'المندوب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'الاسم: ${controller.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'رقم الموبايل: ${controller.phone}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('الملاحظات'),
                onTap: () {
                  Get.to(() => const AllNotes());
                },
              ),
              Divider(),
              ListTile(
                title: const Text('تسجيل الخروج'),
                onTap: () {
                  logout();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('لوحة التحكم المندوب'),
          centerTitle: true,
        ),
        body: AddNewClientEntry(),
        /*CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "الاصناف",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (controller.isLoading)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              )
            else ...[
              if (controller.categories.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Text("لا يوجد اصناف"),
                  ),
                ),
              SliverList.list(
                children: List.generate(
                  controller.categories.length,
                  (index) {
                    final category = controller.categories[index];
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => AddNewEntry(),
                          arguments: {
                            'model': category,
                          },
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(16),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // قسم العنوان بخلفية متدرجة
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF3F51B5),
                                    Color(0xFF2196F3)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ),
                            // قسم التفاصيل
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetailItem(
                                        'اقل سعر',
                                        category.startSellPrice,
                                      ),
                                      _buildDetailItem(
                                        'الكمية',
                                        category.quantity,
                                      ),
                                      _buildDetailItem(
                                        'اعلى سعر',
                                        category.endSellPrice,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),*/
      ),
    );
  }

  Widget _buildDetailItem(String label, num value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
