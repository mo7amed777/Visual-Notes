import 'package:visual_notes/models/note.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  static const String dataBase = '/notes.db', table = 'Notes';
  Database? _db;

  get database => _db;

  Future open() async {
    var dbPath = await getDatabasesPath();
    _db = await openDatabase(
      dbPath + dataBase,
      version: 1,
    );
    await _db?.execute('''
           create table if not exists $table (id integer primary key autoincrement,
           title text,picture text,desc text, date text, status integer)
           ''');
  }

  Future insert({required Note note}) async {
    await _db!.insert(table, note.toMap());
  }

  Future update({required Note note, required int id}) async {
    await _db!.update(table, note.toMap(), where: 'id = $id');
  }

  Future delete({required int id}) async {
    await _db!.delete(table, where: 'id = $id');
  }

  Future close() async {
    await _db!.close();
  }
}
