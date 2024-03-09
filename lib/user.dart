import 'package:membership_card_pocket/database_helper.dart';

// 1. Create class user
class User {
  int id;
  String username;
  String password;

  // 1.1. Class constructor
  User(this.id, this.username, this.password);

  // 1.2. fromMap method - data manipulation method
  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    username = map['username'];
    password = map['password'];
  }


  // 1.3. toMap method - convert car object into Map object
  Map<String, dynamic> toMap() {
    return {
      // 1.4 Object from Class DatabaseHelper - (dbhelper.dart)
      // table attributes from table cars_table
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: username,
      DatabaseHelper.columnPassword: password,
    };
  }
}
