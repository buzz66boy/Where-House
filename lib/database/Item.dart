import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

class Item {
  late int uid;
  String name;
  String description;
  List<String> barcodes;
  int locationUID;

  Item({
    this.uid = 0,
    required this.name,
    required this.description,
    required this.barcodes,
    required this.locationUID,
  });

  static Future<Item> getItem(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query('Item', where: 'uid = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return Item(
        uid: results[0]['uid'],
        name: results[0]['name'],
        description: results[0]['description'],
        barcodes: results[0]['barcodes'].split(','),
        locationUID: results[0]['locationUID'],
      );
    } else {
      throw Exception("Item not found in the database");
    }
  }

  Future<bool> setItem() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.insert(
        'Item',
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

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      uid: map['uid'],
      name: map['name'],
      description: map['description'],
      barcodes: (map['barcodes'] as String).split(','),
      locationUID: map['locationUID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'barcodes': barcodes.join(','),
      'locationUID': locationUID,
    };
  }



  @override
  String toString() {
    return 'Item{uid: $uid, name: $name, description: $description, barcodes: $barcodes, locationQuantities: $locationUID}';
  }
}


