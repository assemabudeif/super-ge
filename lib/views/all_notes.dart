import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/controllers/all_notes_controller.dart';
import 'package:super_ge/models/note_model.dart';

import 'add_new_note.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllNotesController>(
      init: AllNotesController(),
      builder: (AllNotesController controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('الملاحظات'),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'عملاء',
                  ),
                  Tab(
                    text: 'مندوبين',
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Get.to(() => const AddNewNote());
              },
            ),
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      AllNotesWidget(
                        notes: controller.clientNotes,
                        deleteNote: controller.deleteNote,
                      ),
                      AllNotesWidget(
                        notes: controller.mandobNotes,
                        deleteNote: controller.deleteNote,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class AllNotesWidget extends StatelessWidget {
  const AllNotesWidget({
    super.key,
    required this.notes,
    required this.deleteNote,
  });

  final List<NoteModel> notes;
  final Function(String id) deleteNote;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text('لا يوجد ملاحظات'),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(notes[index].name),
          subtitle: Text('${notes[index].amount} جنيه'),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteNote(notes[index].id!);
            },
          ),
        );
      },
    );
  }
}
