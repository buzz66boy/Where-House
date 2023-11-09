import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'Item.dart';
//import 'pathtoAccountingLog.dart'

class ItemManager {
  late Database database;

  ItemManager() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'WhereHouse.db');

    database = await openDatabase(
      path,
      onCreate: (db, version) async {

        await db.execute(
          'CREATE TABLE IF NOT EXISTS Item('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'description TEXT, '
              'barcodes TEXT, '
              'locationQuantities TEXT, '
              'defaultLocation INTEGER'
              ')',
        );
      },
      version: 1,
    );
  }

  Future<bool> addItem(
      int uid,
      String name,
      String description,
      List<String> barcodes,
      Map<int, int> locationQuantities,
      int defaultLocation,
      ) async {
    try {
      final result = await database.query(
        'Item',
        where: 'uid = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {

        return false;
      }
      String locationQuantitiesJson = Item.encodeLocationQuantities(locationQuantities);
      Item newItem = Item(
        uid: uid,
        name: name,
        description: description,
        barcodes: barcodes,
        locationQuantitiesJson: locationQuantitiesJson,
        defaultLocation: defaultLocation,
      );

      bool success = await newItem.setItem();

      return success;
    } catch (e) {
      print('Error adding item: $e');
      return false;
    }
  }


  Future<bool> removeItem(int uid) async {
    try {
      int rowsDeleted = await database.delete(
          'items', where: 'UID = ?', whereArgs: [uid]);
      return rowsDeleted > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Item?> editItem({
    required int uid,
    String? name,
    List<String>? barcodes,
    String? description,
    Map<int, int>? locationQuantities,
    int? defaultLocation,
  }) async {
    Item existingItem = await Item.getItem(uid);

    if (existingItem.uid == uid) {

      if (name != null) existingItem.name = name;
      if (barcodes != null) existingItem.barcodes = barcodes;

      if (description != null) existingItem.description = description;

      if (locationQuantities != null) existingItem.locationQuantitiesJson = Item.encodeLocationQuantities(locationQuantities);

      if (defaultLocation != null) existingItem.defaultLocation = defaultLocation;

      try {
        await existingItem
            .setItem();
        return existingItem;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Item>> queryItems(String query) async {
    try {
      List<Map> results = await database.query('Item',
          where: 'name LIKE ? OR UID LIKE ? OR description LIKE ? OR barcodes LIKE ? OR location LIKE ?',
          whereArgs: List.filled(5, '%$query%'));
      return results.map((item) {
        return Item(
          uid: item['uid'],
          name: item['name'],
          description: item['description'],
          barcodes: item['barcodes'].split(','),
          locationQuantitiesJson: Item.encodeLocationQuantities(item['checkedOutItems']),
          defaultLocation: item['defaultLocation'],
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Map<int, int> _decodeLocationQuantities(String json) {
    return Map<int, int>.from(jsonDecode(json));
  }
}




