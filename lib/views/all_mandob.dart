import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/all_mandob_controller.dart';

import 'add_new_mandob.dart';

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
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddNewMandob());
            },
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemCount: controller.mandobs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.mandobs[index].name),
                      subtitle: Text(controller.mandobs[index].phone),
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
