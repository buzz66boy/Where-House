import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class User {
  int uid;
  String name;
  Map<int, int> checkedOutItems;

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
        checkedOutItems: _decodeCheckedOutItems(results[0]['checkedOutItems']),
      );
    } else {
      throw Exception("User not found in the database");
    }
  }

  Future<bool> setUser() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.update('User', toMap(), where: 'uid = ?', whereArgs: [this.uid]);
      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'checkedOutItems': _encodeCheckedOutItems(checkedOutItems),
    };
  }

  static String _encodeCheckedOutItems(Map<int, int> checkedOutItems) {
    return jsonEncode(checkedOutItems);
  }

  static Map<int, int> _decodeCheckedOutItems(dynamic json) {
    return jsonDecode(json);
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, checkedOutItems: $checkedOutItems}';
  }
}
