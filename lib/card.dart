import 'package:membership_card_pocket/card_db.dart';

// 1. Create class Card
class Card {
  int id;
  String name;
  //int miles;
  String datas;

  // 1.1. Class constructor
  Card(this.id, this.name, this.datas);

  // 1.2. fromMap method - data manipulation method
  Card.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    datas = map['datas'];
  }

  // 1.3. toMap method - convert card object into Map object
  Map<String, dynamic> toMap() {
    return {
      // 1.4 Object from Class DatabaseHelper - (dbhelper.dart)
      // table attributes from table cards_table
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnDatas: datas,
    };
  }
}
