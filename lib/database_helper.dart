import 'package:membership_card_pocket/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'main.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'my_table';
  static final columnId = '_id';
  static final columnName = 'username';
  static final columnPassword = 'password';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  //static Database _database;

  Future<Database> get database async =>
      _database ??= await _initDatabase();

  // this opens the database (and creates it if it doesn't exist)
   _initDatabase() async {
    //var databasesPath = await getDatabasesPath();
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);

  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $table (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnPassword TEXT NOT NULL
              )
              ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  /*
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }
  */
  Future<int> insert(User user) async {
    Database db = await instance.database;
    print("insert");
    return await db.insert(table, {'username': user.username, 'password': user.password});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(username) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$username%'");
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var result = await db.query(table);
    List<User> users = result.isNotEmpty ? result.map((c) => User.fromMap(c)).toList() : [];
    print("Done for queryallusers()");
    return users;
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    print("queryrowcount()");
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table')
    );
  }

  Future<int> update(User user) async {
    Database db = await instance.database;
    int id = user.toMap()['id'];
    return await db
        .update(table, user.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUser(String username) async{
    Database db = await instance.database;
    return await db.query("SELECT DISTINCT columnId where: %$columnName% = ?");
  }

  //query one specific user
  Future<List<Map<String, dynamic>>> queryUser(String username) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnName = ?', whereArgs: [username]);
  }

  //check the user and password is match
  Future<bool> checkLogin(String username, String password) async {
    final user = await queryUser(username);
    if (user.isNotEmpty && user[0]['password'] == password) {
      print("check login: T");
      return true;
    } else {
      print("check login: F");
      return false;
    }
  }
}
