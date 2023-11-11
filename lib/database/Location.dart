import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class Location {
  late int uid;
  String name;
  int defaultLocation;

  Location({
    this.uid = -1,
    required this.name,
    required this.defaultLocation,
  });

  static Future<Location> getLocation(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query('Location', where: 'UID = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return Location(
        uid: results[0]['uid'],
        name: results[0]['name'],
        defaultLocation: results[0]['defaultLocation'],
      );
    } else {
      throw Exception("Location not found in the database");
    }
  }

  Future<bool> setLocation() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      uid = await db.insert(
        'Location',
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

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      uid: map['uid'],
      name: map['name'],
      defaultLocation: map['defaultLocation'],
    );
  }

  Map<String, dynamic> toMap() {

    if (uid > -1) {
      return {
        'uid': uid,
        'name': name,
        'defaultLocation': defaultLocation,
      };
    } else {
      return {
        'name': name,
        'defaultLocation': defaultLocation,
      };
    }
  }

  @override
  String toString() {
    return 'Location{uid: $uid, name: $name, defaultLocation: $defaultLocation}';
  }
}
