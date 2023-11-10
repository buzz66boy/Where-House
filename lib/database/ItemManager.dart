import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'Item.dart';
//import 'pathtoAccountingLog.dart'

class ItemManager {
  late Database database;

  ItemManager() {
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
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
        await db.execute(
          'CREATE TABLE IF NOT EXISTS Location('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'defaultLocation INTEGER'
              ')',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS User('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'checkedOutItems TEXT'
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
      database = await openDatabase('WhereHouse.db');
      final result = await database.query(
        'Item',
        where: 'uid = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {

        return false;
      }
      String locationQuantitiesJson = encodeLocationQuantities(locationQuantities);
      Item newItem = Item(
        uid: uid,
        name: name,
        description: description,
        barcodes: barcodes,
        locationQuantities: locationQuantitiesJson,
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
      database = await openDatabase('WhereHouse.db');
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
    database = await openDatabase('WhereHouse.db');
    Item existingItem = await Item.getItem(uid);

    if (existingItem.uid == uid) {

      if (name != null) existingItem.name = name;
      if (barcodes != null) existingItem.barcodes = barcodes;

      if (description != null) existingItem.description = description;

      if (locationQuantities != null) existingItem.locationQuantities = encodeLocationQuantities(locationQuantities);

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

  Future<List<Item>> queryItems([String query = '']) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Map> results;

      if (query.isNotEmpty) {
        results = await database.query('Item',
            where: 'name LIKE ? OR UID LIKE ? OR description LIKE ? OR barcodes LIKE ? OR location LIKE ?',
            whereArgs: List.filled(5, '%$query%'));
      } else {
        results = await database.query('Item');
      }

      return results.map((item) {
        return Item(
          uid: item['uid'],
          name: item['name'],
          description: item['description'],
          barcodes: item['barcodes'].split(','),
          locationQuantities: jsonDecode(item['locationQuantities']),
          defaultLocation: item['defaultLocation'],
        );
      }).toList();
    } catch (e) {
        print(e);
        return [];
    }
  }


  // Export items to a file
  Future<bool> exportItems(String outfileLocation) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Item> items = await queryItems('');

      String itemsJson = jsonEncode(items.map((item) => item.toMap()).toList());

      await File(outfileLocation).writeAsString(itemsJson);
      return true;
    } catch (e) {
        print('Error exporting items: $e');
        return false;
    }
  }

  // Import items from a file
  Future<bool> importItems(String infileLocation) async {
    try {
      String fileContent = await File(infileLocation).readAsString();

      List<Map<String, dynamic>> itemMaps = List<Map<String, dynamic>>.from(jsonDecode(fileContent));
      List<Item> items = itemMaps.map((itemMap) => Item.fromMap(itemMap)).toList();

      for (Item item in items) {

        await addItem(item.uid, item.name, item.description, item.barcodes, item.locationQuantities as Map<int, int>, item.defaultLocation);
      }

      return true;
    } catch (e) {
        print('Error importing items: $e');
        return false;
    }
  }

  static String encodeLocationQuantities(Map<int, int> locationQuantities) {
    Map<String, int> stringKeyMap = locationQuantities.map((key, value) => MapEntry(key.toString(), value));
    return jsonEncode(stringKeyMap);
  }
}






