import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

class Item {
  int uid;
  String name;
  String description;
  List<String> barcodes;
  String locationQuantitiesJson;
  int defaultLocation;

  Item({
    required this.uid,
    required this.name,
    required this.description,
    required this.barcodes,
    required this.locationQuantitiesJson,
    required this.defaultLocation,
  });

  static Future<Item> getItem(int uid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query('Item', where: 'UID = ?', whereArgs: [uid]);
    await db.close();

    if (results.isNotEmpty) {
      return Item(
        uid: results[0]['uid'],
        name: results[0]['name'],
        description: results[0]['description'],
        barcodes: results[0]['barcodes'].split(','),
        locationQuantitiesJson: encodeLocationQuantities(results[0]['checkedOutItems']),
        defaultLocation: results[0]['defaultLocation'],
      );
    } else {
      throw Exception("Item not found in the database");
    }
  }

  Future<bool> setItem() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.update('Item', toMap(), where: 'uid = ?', whereArgs: [this.uid]);
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
      'description': description,
      'barcodes': barcodes.join(','),
      'locationQuantities': jsonEncode(locationQuantitiesJson),
      'defaultLocation': defaultLocation,
    };
  }


  static String encodeLocationQuantities(Map<int, int> locationQuantities) {
    Map<String, int> stringKeyMap = locationQuantities.map((key, value) => MapEntry(key.toString(), value));
    return jsonEncode(stringKeyMap);
  }

  static Map<int, int> decodeLocationQuantities(String json) {
    Map<String, int> stringKeyMap = Map<String, int>.from(jsonDecode(json));
    Map<int, int> intKeyMap = stringKeyMap.map((key, value) => MapEntry(int.parse(key), value));
    return intKeyMap;
  }

  @override
  String toString() {
    return 'Item{uid: $uid, name: $name, description: $description, barcodes: $barcodes, locationQuantities: $locationQuantitiesJson, defaultLocation: $defaultLocation}';
  }
}

