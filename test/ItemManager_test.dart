import 'dart:convert';


import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/ItemManager.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;

void main() {
  // Set up sqflite_common_ffi before running tests
  setUp(() async {
void main() {
  // Set up sqflite_common_ffi before running tests
  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    final databasePath = await getDatabasesPath();
    await openDatabase(
        join(databasePath, 'WhereHouse.db'), onCreate: (db, version) async {
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
        'CREATE TABLE IF NOT EXISTS LocationItemCount('
            'locationUid INTEGER, '
            'itemUid INTEGER, '
            'itemCount INTEGER, '
            'PRIMARY KEY (locationUid, itemUid), '
            'FOREIGN KEY (locationUid) REFERENCES Location(uid), '
            'FOREIGN KEY (itemUid) REFERENCES Item(uid)'
            ')',
      );
    }, version: 1);
  });

  // Tear down and close the database after tests
  tearDown(() async {
    final databasePath = await getDatabasesPath();
    await deleteDatabase(join(databasePath, 'WhereHouse.db'));
  });


  test('Add Item', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that adding an item returns a non-null Item object
    Item? newItem = await itemManager.addItem(
      'Test Item',
      'Test Description',
      ['12345', '67890'],
      1,
    );
    expect(newItem, isNotNull);

    // Ensure that the item has been added to the database
    Item? retrievedItem = await Item.getItem(newItem!.uid);
    expect(retrievedItem, isNotNull);
    expect(retrievedItem!.uid, matcher.equals(newItem.uid));
  });

  test('Remove Item', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that removing an item returns true
    Item? newItem = await itemManager.addItem(
      'Test Item',
      'Test Description',
      ['12345', '67890'],
      1,
    );
    expect(newItem, isNotNull);

    bool result = await itemManager.removeItem(newItem!.uid);
    expect(result, true);

    // Ensure that the item has been removed from the database
    Item? retrievedItem = await Item.getItem(newItem.uid);
    expect(retrievedItem, isNull);
  });

  test('Edit Item', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that editing an item returns a non-null Item object
    Item? newItem = await itemManager.addItem(
      'Test Item',
      'Test Description',
      ['12345', '67890'],
      1,
    );
    expect(newItem, isNotNull);

    Item? editedItem = await itemManager.editItem(
      uid: newItem!.uid,
      name: 'Edited Item',
      barcodes: ['11111', '22222'],
      description: 'Edited Description',
      locationUID: 2,
    );
    expect(editedItem, isNotNull);

    // Ensure that the item has been edited in the database
    Item? retrievedItem = await Item.getItem(editedItem!.uid);
    expect(retrievedItem, isNotNull);
    expect(retrievedItem.uid, matcher.equals(editedItem.uid));
    expect(retrievedItem.name, matcher.equals('Edited Item'));
    expect(retrievedItem.barcodes, matcher.equals(['11111', '22222']));
    expect(retrievedItem.description, matcher.equals('Edited Description'));
    expect(retrievedItem.locationUID, matcher.equals(2));
  });

  test('Update Item Count', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that updating item count returns true
    bool result = await itemManager.updateItemCount(1, 1, 5);
    expect(result, true);

    // Ensure that the item count has been updated in the database
    List<Map<String, dynamic>>? itemCount = await itemManager.queryItemCount(
      locationUid: 1,
      itemUid: 1,
    );
    expect(itemCount, isNotNull);
    expect(itemCount!.isNotEmpty, true);
    expect(itemCount[0]['itemCount'], matcher.equals(5));
  });

  test('Query Item Count', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that querying item count returns a non-null list
    List<Map<String, dynamic>>? itemCount = await itemManager.queryItemCount(
      locationUid: 1,
      itemUid: 1,
    );
    expect(itemCount, isNotNull);
  });

  test('Query Items', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that querying items returns a non-empty list
    List<Item> items = await itemManager.queryItems();
    expect(items, isNotNull);
    expect(items.isNotEmpty, true);
  });

  test('Export Items', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that exporting items returns true
    bool result = await itemManager.exportItems('test_export.json');
    expect(result, true);
  });

  test('Import Items', () async {
    ItemManager itemManager = ItemManager();
    // Ensure that importing items returns true
    bool result = await itemManager.importItems('test_export.json');
    expect(result, true);
  });
}