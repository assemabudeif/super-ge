import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';

import '../controllers/entries_controller.dart';
import '../widgets/entry_widget.dart';

/// A screen that displays all the financial entries for a specific collection.
///
/// This view shows a list of all entries associated with a collection, allowing
/// the user to see the details of each transaction. For admin users, it also
/// displays the total profits for the collection. A refresh button is available
/// to fetch the latest data.
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
              // Refresh button to refetch entries.
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  controller.getEntries();
                },
              ),
              // Display total profits for admin users.
              if (AppPreferences.instance.getUserType() == 'admin') ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Center(
                    child: Text(
                      "الارباح: ${num.parse(controller.allProfits()).toStringAsFixed(2)} جنيه",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ]
            ],
          ),
          body: CustomScrollView(
            slivers: [
              // Show a loading indicator while fetching data.
              if (controller.isLoading)
                SliverFillRemaining(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                // Show a message if no entries are available.
                if (controller.entries.isEmpty)
                  SliverFillRemaining(
                    child: const Center(
                      child: Text('لا يوجد مدخلات'),
                    ),
                  ),
                // Display the list of entries.
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
