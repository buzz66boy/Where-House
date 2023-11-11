import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class User {
  int uid;
  String name;
  List<int> checkedOutItems;

  User({
    required this.uid,
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
      await db.insert(
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
      uid: map['uid'],
      name: map['name'],
      checkedOutItems: List<int>.from(jsonDecode(map['checkedOutItems'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'checkedOutItems': jsonEncode(checkedOutItems),
    };
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, checkedOutItems: $checkedOutItems}';
  }
}
