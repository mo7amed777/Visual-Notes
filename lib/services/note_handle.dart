import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes/controllers/notes_controller.dart';
import 'package:visual_notes/controllers/status_controller.dart';
import 'package:visual_notes/models/note.dart';
import 'dart:async';
import 'package:visual_notes/widgets/input_field.dart';

final NotesController _notesController = Get.put(NotesController());
final StatusController _statusController = Get.put(StatusController());
TextEditingController _titleController = TextEditingController();
TextEditingController _descController = TextEditingController();
TextEditingController _dateTimeController = TextEditingController();
String? _picture;
final ImagePicker _picker = ImagePicker();
addNewNote() async {
  await Get.dialog(
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Add New Note'),
              inputField(_titleController, 'Title'),
              inputField(_descController, 'Description', lines: 3),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: const Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                controller: _dateTimeController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      label: const Text('Capture Image'),
                      icon: const Icon(Icons.camera_alt),
                      onPressed: captureImage,
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      label: const Text('Pick Image'),
                      icon: const Icon(Icons.camera),
                      onPressed: pickImage,
                    ),
                  ),
                ],
              ),
              DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<String>(
                    value: _statusController.status.value,
                    hint: const Text('Select Status'),
                    items: const [
                      DropdownMenuItem(
                        child: Text('Opened'),
                        value: 'Opened',
                      ),
                      DropdownMenuItem(
                        child: Text('Closed'),
                        value: 'Closed',
                      ),
                    ],
                    onChanged: (value) => _statusController.checkStatus(value!),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: const Text(
                          'Create',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Note note = Note(
                            title: _titleController.text,
                            desc: _descController.text,
                            picture: _picture,
                            date: _dateTimeController.text,
                            status: _statusController.status.value,
                          );
                          _notesController.createNote(note);
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

editNote(Note note, int id) async {
  _titleController = TextEditingController(text: note.title);
  _descController = TextEditingController(text: note.desc);
  _statusController.status.value = note.status!;
  _dateTimeController = TextEditingController(text: note.date);

  await Get.dialog(
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Edit Note'),
              inputField(_titleController, 'Title'),
              inputField(_descController, 'Description', lines: 3),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: const Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                controller: _dateTimeController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      label: const Text('Capture Image'),
                      icon: const Icon(Icons.camera_alt),
                      onPressed: captureImage,
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      label: const Text('Pick Image'),
                      icon: const Icon(Icons.camera),
                      onPressed: pickImage,
                    ),
                  ),
                ],
              ),
              DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<String>(
                    value: _statusController.status.value,
                    hint: const Text('Select Status'),
                    items: const [
                      DropdownMenuItem(
                        child: Text('Opened'),
                        value: 'Opened',
                      ),
                      DropdownMenuItem(
                        child: Text('Closed'),
                        value: 'Closed',
                      ),
                    ],
                    onChanged: (value) => _statusController.checkStatus(value!),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Note note = Note(
                            title: _titleController.text,
                            desc: _descController.text,
                            picture: _picture,
                            date: _dateTimeController.text,
                            status: _statusController.status.value,
                          );
                          _notesController.updateNote(note, id);
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: InkWell(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  _picture = image?.path;
  Timer(const Duration(seconds: 2), () => Get.back());
  Get.dialog(
    const Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 30,
    ),
  );
}

void captureImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  _picture = image?.path;
  Timer(const Duration(seconds: 2), () => Get.back());

  Get.dialog(
    const Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 30,
    ),
    transitionDuration: const Duration(seconds: 1),
  );
}
