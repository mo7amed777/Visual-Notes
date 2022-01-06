import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visual_notes/controllers/notes_controller.dart';

import 'package:visual_notes/services/note_handle.dart';

class Home extends StatelessWidget {
  final NotesController _notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Notes'),
      ),
      body: GetBuilder<NotesController>(
        init: _notesController,
        builder: (controller) => controller.notes.isEmpty
            ? const Center(child: Text('No Notes Added yet!'))
            : ListView.builder(
                itemCount: controller.notes.length,
                itemBuilder: (context, index) => Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                  key: Key(controller.notes[index].id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _notesController.deleteNote(controller.notes[index].id!);
                  },
                  child: InkWell(
                    onTap: () => editNote(
                        controller.notes[index], controller.notes[index].id!),
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(controller.notes[index].title.toString()),
                        trailing: controller.notes[index].status == 'Opened'
                            ? traillingWidgets(controller, index,
                                Icons.check_circle, Colors.green)
                            : traillingWidgets(
                                controller, index, Icons.close, Colors.red),
                        isThreeLine: true,
                        subtitle: controller.notes[index].desc != null
                            ? controller.notes[index].desc!.length > 20
                                ? Text(controller.notes[index].desc!
                                        .substring(0, 16) +
                                    '...')
                                : Text(controller.notes[index].desc ?? '')
                            : const Text(''),
                        leading: CircleAvatar(
                          child: Text(
                            controller.notes[index].picture == null
                                ? 'Note'
                                : '',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.black,
                          backgroundImage:
                              controller.notes[index].picture == null
                                  ? null
                                  : FileImage(
                                      File(controller.notes[index].picture!),
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: const FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: addNewNote,
      ),
    );
  }

  Column traillingWidgets(
      NotesController controller, int index, IconData iconData, Color color) {
    return Column(
      children: [
        Icon(
          iconData,
          color: color,
          size: 20,
        ),
        Text(controller.notes[index].date ?? ''),
      ],
    );
  }
}
