import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

class Item {
  int uid;
  String name;
  String description;
  List<String> barcodes;
  Map<int, int> locationQuantities;
  int defaultLocation;

  Item({
    required this.uid,
    required this.name,
    required this.description,
    required this.barcodes,
    required this.locationQuantities,
    required this.defaultLocation,
  });

  // Method to fetch an item from the database by UID
  static Future<Item> getItem(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query(
        'Item', where: 'UID = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return Item(
        uid: results[0]['uid'],
        name: results[0]['name'],
        description: results[0]['description'],
        barcodes: results[0]['barcodes'].split(','),
        locationQuantities: Map<int, int>.from(
            results[0]['locationQuantities']),
        defaultLocation: results[0]['defaultLocation'],
      );
    } else {
      throw Exception("Item not found in the database");
    }
  }

  // Method to update an item in the database
  Future<bool> setItem() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.update(
          'Item', this.toMap(), where: 'uid = ?', whereArgs: [this.uid]);
      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  // Method to convert the item into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'barcodes': barcodes.join(','),
      'locationQuantities': locationQuantities,
      'defaultLocation': defaultLocation,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $uid, name: $name, age: $description, barcodes: $barcodes, Location Quantities: $locationQuantities, default location: $defaultLocation}';
  }


}

