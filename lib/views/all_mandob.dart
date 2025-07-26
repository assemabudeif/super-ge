import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/all_mandob_controller.dart';

import 'add_new_mandob.dart';

/// A screen that displays a list of all representatives (Mandobs).
///
/// This view shows a list of all registered representatives, allowing an admin
/// to see their names and phone numbers. It also provides an option to delete
/// a representative and a floating action button to navigate to the `AddNewMandob` screen.
class AllMandob extends StatelessWidget {
  const AllMandob({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllMandobController>(
      init: AllMandobController(),
      builder: (AllMandobController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('جميع المندوبين'),
          ),
          // A button to navigate to the screen for adding a new representative.
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddNewMandob());
            },
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              // Build a list of representatives.
              : ListView.separated(
                  itemCount: controller.mandobs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.mandobs[index].name),
                      subtitle: Text(controller.mandobs[index].phone),
                      // Button to delete a representative.
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          controller.deleteMandob(controller.mandobs[index].id);
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
