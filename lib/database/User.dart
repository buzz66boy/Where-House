import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class User {
  int uid;
  String name;
  String checkedOutItemsJson;

  User({
    required this.uid,
    required this.name,
    required this.checkedOutItemsJson,
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
        checkedOutItemsJson: encodeCheckedOutItems(results[0]['checkedOutItems']),// changed to encode to meet
        // parameters
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
      'checkedOutItems': jsonEncode(checkedOutItemsJson),
    };
  }


  static String encodeCheckedOutItems(Map<int, int> checkedOutItems) {
    Map<String, int> stringKeyMap = checkedOutItems.map((key, value) => MapEntry(key.toString(), value));
    return jsonEncode(stringKeyMap);
  }

  static Map<int, int> decodeCheckedOutItems(String json) {
    Map<String, int> stringKeyMap = Map<String, int>.from(jsonDecode(json));
    Map<int, int> intKeyMap = stringKeyMap.map((key, value) => MapEntry(int.parse(key), value));
    return intKeyMap;
  }

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, checkedOutItems: $checkedOutItemsJson}';
  }
}