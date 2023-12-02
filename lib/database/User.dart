import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class User {
  late int uid;
  String name;
  List<dynamic> checkedOutItems;

  User({
    this.uid = -1,
    required this.name,
    required this.checkedOutItems,
  });

  static Future<User> getUser(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results =
    await db.query('User', where: 'UID = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return User(
        uid: results[0]['uid'],
        name: results[0]['name'],
        checkedOutItems: List<int>.from(jsonDecode(results[0]['checkedOutItems'])),
      );
    } else {
      throw Exception("User not found in the database");
    }
  }

  Future<bool> setUser() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      uid = await db.insert(
        'User',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      checkedOutItems: List<int>.from(jsonDecode(map['checkedOutItems'])),
    );
  }

  Map<String, dynamic> toMap() {

    if (uid > -1) {
      return {
        'uid': uid,
        'name': name,
        'checkedOutItems': jsonEncode(checkedOutItems),
      };
    } else {
      return {
        'name': name,
        'checkedOutItems': jsonEncode(checkedOutItems),
      };
    }
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, checkedOutItems: $checkedOutItems}';
  }
}
