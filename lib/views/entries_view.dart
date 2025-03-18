import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';

import '../controllers/entries_controller.dart';
import '../widgets/entry_widget.dart';

class EntriesView extends StatelessWidget {
  const EntriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EntriesController>(
      init: EntriesController(),
      builder: (EntriesController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('المدخلات'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  controller.getEntries();
                },
              ),
              if (AppPreferences.instance.getUserType() == 'admin') ...[
                Text(
                  "الارباح: ${num.parse(controller.allProfits()).toStringAsFixed(2)} جنيه",
                ),
                const SizedBox(
                  width: 16,
                ),
              ]
            ],
          ),
          body: CustomScrollView(
            slivers: [
              if (controller.isLoading)
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                if (controller.entries.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text('لا يوجد مدخلات'),
                    ),
                  ),
                SliverList.separated(
                  itemCount: controller.entries.length,
                  itemBuilder: (context, index) {
                    return EntryWidget(
                      model: controller.entries[index],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
