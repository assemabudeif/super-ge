import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/admin_home_controller.dart';
import 'package:super_ge/core/functions/logout.dart';
import 'package:super_ge/core/theme/app_colors.dart';
import 'package:super_ge/views/add_new_collection.dart';
import 'package:super_ge/views/all_mandob.dart';
import 'package:super_ge/views/all_notes.dart';
import 'package:super_ge/views/bills_view.dart';
import 'package:super_ge/views/entries_view.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminHomeController>(
      init: AdminHomeController(),
      builder: (AdminHomeController controller) {
        return Scaffold(
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
                        'المدير',
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
                  title: const Text('المندوبين'),
                  onTap: () {
                    Get.to(() => const AllMandob());
                  },
                ),
                Divider(),
                ListTile(
                  title: const Text('الملاحظات'),
                  onTap: () {
                    Get.to(() => const AllNotes());
                  },
                ),
                Divider(),
                ListTile(
                  title: const Text('الفواتير'),
                  onTap: () {
                    Get.to(() => const BillsView());
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
            title: const Text('لوحة التحكم'),
            centerTitle: true,
            actions: [
              if (controller.exporting)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                IconButton(
                  icon: Row(
                    children: [
                      Text(
                        "انشاء اكسيل",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Icon(
                        FontAwesomeIcons.fileCsv,
                      ),
                    ],
                  ),
                  onPressed: () {
                    controller.exportExcel();
                  },
                ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الاصناف",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "الارباح الكليه ${num.parse(controller.allProfits()).toStringAsFixed(2)} جنيه",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                      return Card(
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
                              child: Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.to(
                                        () => EntriesView(),
                                        arguments: {
                                          'id': category.id,
                                          'gomlahPrice': category.gomlahPrice,
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                    iconAlignment: IconAlignment.end,
                                    label: const Text(
                                      'كل المدخلات',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
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
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      controller.deleteCategory(category.id);
                                    },
                                  ),
                                ],
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
                                        'اعلى سعر',
                                        category.endSellPrice,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetailItem(
                                        'سعر الجملة',
                                        category.gomlahPrice,
                                      ),
                                      _buildDetailItem(
                                        "الارباح",
                                        category.profits ?? 0,
                                      ),
                                      _buildDetailItem(
                                        'الكمية',
                                        category.quantity,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(
                        () => const AddNewCollection(),
                      );
                    },
                    label: const Text(
                      "اضافة صنف جديد",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
