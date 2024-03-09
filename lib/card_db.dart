// 1. Import the necessary statement
/*
* card.dart - transfer data between UI and DatabaseHelper class
* path.dart - to access dart core utility function related to file paths
* sqflite - manipulate SQLite database */

import 'package:membership_card_pocket/card.dart';
//import 'package:membership_card_pocket/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 2. Class DatabaseHelper
class DatabaseHelper {
  // 2.1 Initialize database name (card_db.db) and db version
  static final _databaseName = "carddb.db";
  static final _databaseVersion = 1;

  // 2.2 Initialize table name (cards_table) with three attributes
  static final table = 'cards_table';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDatas = 'datas';

  // 2.3 Declare a singleton class using _privateConstructor object
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // 2.4 Only have a single app-wide reference to the database
  static Database _database;

  // 2.5 Method to get database (Future option) of type Future<Database>
  Future<Database> get database async {
    if (_database != null) return _database;
    // 2.5.1 Lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // 2.5.2 Opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    // 2.5.3 openDatabase method - to open SQLite database
    return await openDatabase(path,
        version: _databaseVersion,
        // 2.5.4 onCreate method - to write code while a db is created for 1st time
        onCreate: _onCreate);
  }

  // 2.5.5 SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // 2.5.6 db.execute method - execute SQL queries
    await db.execute('''CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnDatas TEXT NOT NULL
          )
          ''');
  }

  // The Helper methods

  // 2.6 insert method - insert card details into table
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Card card) async {
    Database db = await instance.database;
    return await db.insert(table, {'name': card.name, 'datas': card.datas});
  }

  // 2.7 get all cards in the database
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // 2.8 Retrieve specific card name
  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }

  // 2.9 Get number of data in the table
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // 2.10 Update the table
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.

  Future<int> update(Card card) async {
    Database db = await instance.database;
    int id = card.toMap()['id'];
    return await db
        .update(table, card.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // 2.11 Delete the selected data
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
