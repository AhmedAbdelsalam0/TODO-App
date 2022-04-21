import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  // A function to create database
  static Future<void> initDB() async {
    if (_db != null) {
      // if there are already database , so we don't need to create new one
      print("Not Null DB!");
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + "task.db";
        print("In Database Path");
        _db = await openDatabase(
          _path,
          version: _version,
          onCreate: (Database db, int version) async {
            print("Create New Database");
            await db.execute(
              'CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, '
              'note TEXT, '
              'date STRING, '
              'startTime STRING, '
              'endTime STRING, '
              'remind INTEGER, '
              'repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER'
              ')',
            );
            print("Database Is Created!");
          },
        );
      } catch (e) {
        print("Error has occurred!!!\n$e");
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print("Insert Something!");
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      print("We Are Here!");
      return 90000;
    }
  }

  static Future<int> delete(Task task) async {
    print("Delete Something!");
    return await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print("Delete All Tasks!");
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("Query for Something!");
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print("Update Something!");
    return await _db!.rawUpdate(
      '''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''',
      [1, id],
    );
  }
}
