import 'dart:io';

import 'package:offlinedatabase/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
class DatabaseHandler {
  DatabaseHandler._();

  static final DatabaseHandler db = DatabaseHandler._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    String path = join(directory.path, "MyDatabase.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE users ("
              "nama TEXT,"
              "email TEXT "
              ")");
        });
  }


  addData(User user) async {
    final db = await database;
    var raw = await db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<User>> getAllData() async {
    final db = await database;
    var response = await db.query("users");
    List<User> list = response.map((c) => User.fromMap(c)).toList();
    return list;
  }

  Future <User> getSingleData(String email) async {
    final db = await database;

    List<Map> results = await db.query("users", where: 'id = ?', whereArgs: [email]);

    if (results.length > 0) {
      return new User.fromMap(results.first);
    }

    return null;
  }

  deleteData(String email) async {
    final db = await database;
    return db.delete("users", where: "email = ?", whereArgs: [email]);
  }

  Future updateUser(User user) async {
    final db = await database;
    await db.update("users", user.toMap(), where: "email = ?", whereArgs: [user.email]);
  }

  deleteAllData() async {
    final db = await database;
    db.delete("users");
  }

}