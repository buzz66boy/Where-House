import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'Item.dart';

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
          'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, '
          'description TEXT, '
          'barcodes TEXT, '
          'locationUID INTEGER, '
          'FOREIGN KEY (locationUID) REFERENCES Location(uid)'
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
        await db.execute(
          'CREATE TABLE IF NOT EXISTS Transaction('
          'transactionUid INTEGER PRIMARY KEY, '
          'userUid INTEGER, '
          'itemUid INTEGER, '
          'locationUid INTEGER, '
          'FOREIGN KEY (userUid) REFERENCES User(uid), '
          'FOREIGN KEY (itemUid) REFERENCES Item(uid), '
          'FOREIGN KEY (locationUid) REFERENCES Location(uid)'
          ')',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS LocationItemCount('
          'locationUid INTEGER, '
          'itemUid INTEGER, '
          'itemCount INTEGER, '
          'PRIMARY KEY (locationUid, itemUid), '
          'FOREIGN KEY (locationUid) REFERENCES Location(uid), '
          'FOREIGN KEY (itemUid) REFERENCES Item(uid)'
          ')',
        );
      },
      version: 1,
    );
  }

  Future<Item?> addItem(
    String name,
    String description,
    List<String> barcodes,
    int locationUID,
  ) async {
    try {
      database = await openDatabase('WhereHouse.db');

      Item newItem = Item(
        name: name,
        description: description,
        barcodes: barcodes,
        locationUID: locationUID,
      );

      bool success = await newItem.setItem();
      if (success) {
        // print('made it here');
        if (locationUID >= 0) {
          await updateItemCount(locationUID, newItem.uid, 1);
        }
        // print(newItem.uid);
        Item addedItem = await Item.getItem(newItem.uid);

        return addedItem;
      }

      print('END of function');
      return null;
    } catch (e) {
      print('Error adding item: $e');
      return null;
    }
  }

  Future<bool> removeItem(int uid) async {
    try {
      Item itemToRemove = await Item.getItem(uid);
      database = await openDatabase('WhereHouse.db');

      int rowsDeleted =
          await database.delete('Item', where: 'uid = ?', whereArgs: [uid]);

      if (rowsDeleted > 0) {
        // await updateItemCount(itemToRemove.locationUID, uid, -1);
        //FIXME: delete
      }

      return rowsDeleted > 0;
    } catch (e) {
      print("Error Deleting: $e");
      return false;
    }
  }

  Future<Item?> editItem({
    required int uid,
    String? name,
    List<String>? barcodes,
    String? description,
    int? locationUID,
  }) async {
    Item existingItem = await Item.getItem(uid);
    database = await openDatabase('WhereHouse.db');

    if (existingItem.uid == uid) {
      if (name != null) existingItem.name = name;
      if (barcodes != null) existingItem.barcodes = barcodes;

      if (description != null) existingItem.description = description;

      if (locationUID != null) existingItem.locationUID = locationUID;

      try {
        await existingItem.setItem();
        return existingItem;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> deleteLocationFromLocationItemCount(int locationUid) async {
    database = await openDatabase('WhereHouse.db');
    int count = await database.delete(
      'LocationItemCount',
      where: 'locationUid = ?',
      whereArgs: [locationUid],
    );
    return true;
  }

  Future<bool> deleteItemFromLocationItemCount(int itemUid) async {
    database = await openDatabase('WhereHouse.db');
    int count = await database.delete(
      'LocationItemCount',
      where: 'itemUid = ?',
      whereArgs: [itemUid],
    );
    return true;
  }

  Future<bool> updateItemCount(
      int locationUid, int itemUid, int itemCount) async {
    if (locationUid < 0) {
      throw FormatException(
          "Trying to update quantity for negative location id");
    }
    try {
      database = await openDatabase('WhereHouse.db');
      // Check if the key pair already exists
      List<Map> result = await database.query(
        'LocationItemCount',
        columns: ['itemCount'],
        where: 'locationUid = ? AND itemUid = ?',
        whereArgs: [locationUid, itemUid],
      );

      if (result.isNotEmpty) {
        if (itemCount > 0) {
          await database.update(
            'LocationItemCount',
            {'itemCount': itemCount},
            where: 'locationUid = ? AND itemUid = ?',
            whereArgs: [locationUid, itemUid],
          );
        } else {
          await database.delete(
            'LocationItemCount',
            where: 'locationUid = ? AND itemUid = ?',
            whereArgs: [locationUid, itemUid],
          );
        }
      } else if (itemCount > 0) {
        await database.insert(
          'LocationItemCount',
          {
            'locationUid': locationUid,
            'itemUid': itemUid,
            'itemCount': itemCount,
          },
        );
      }

      return true;
    } catch (e) {
      print('Error updating item count: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> queryItemCount(
      {int? locationUid, int? itemUid}) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Map<String, dynamic>> results;

      if (itemUid != null) {
        // Query based on itemUid
        results = await database.query(
          'LocationItemCount',
          where: 'itemUid = ?',
          whereArgs: [itemUid],
        );
      } else if (locationUid != null) {
        // Query based on locationUid
        results = await database.query(
          'LocationItemCount',
          where: 'locationUid = ?',
          whereArgs: [locationUid],
        );
      } else {
        return null;
      }

      if (results.isNotEmpty) {
        return results;
      } else {
        return null;
      }
    } catch (e) {
      print('Error querying item row: $e');
      return null;
    }
  }

  Future<List<Item>> queryItems([String query = '']) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Map> results;

      if (query.isNotEmpty) {
        results = await database.query('Item',
            where:
                'name LIKE ? OR uid LIKE ? OR description LIKE ? OR barcodes LIKE ? OR locationUID LIKE ?',
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
          locationUID: item['locationUID'],
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

      List<Map<String, dynamic>> itemMaps =
          List<Map<String, dynamic>>.from(jsonDecode(fileContent));
      List<Item> items =
          itemMaps.map((itemMap) => Item.fromMap(itemMap)).toList();

      for (Item item in items) {
        await addItem(
            item.name, item.description, item.barcodes, item.locationUID);
      }

      return true;
    } catch (e) {
      print('Error importing items: $e');
      return false;
    }
  }
}
