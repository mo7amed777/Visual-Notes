import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:visual_notes/models/note.dart';
import 'package:visual_notes/services/db_connection.dart';

class NotesController extends GetxController {
  final DBConnection _dbConnection = DBConnection();
  Database? _db;
  List<Note> notes = [];
  @override
  void onInit() async {
    await _dbConnection.open();
    _db = _dbConnection.database;
    await getNotes();
    super.onInit();
  }

  @override
  void onClose() async {
    await _dbConnection.close();
    super.onClose();
  }

  Future getNotes() async {
    notes.clear();
    List<Map> notesRes = await _db!.rawQuery('SELECT * FROM Notes');
    for (Map note in notesRes.reversed) {
      Note n = Note.fromMap(note);
      notes.add(n);
    }
    update();
  }

  void createNote(Note note) async {
    _dbConnection.insert(note: note);
    await getNotes();
  }

  void deleteNote(int id) async {
    _dbConnection.delete(id: id);
    await getNotes();
  }

  void updateNote(Note note, int id) async {
    _dbConnection.update(note: note, id: id);
    await getNotes();
  }
}
