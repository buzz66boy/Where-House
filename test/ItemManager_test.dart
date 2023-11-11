import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/ItemManager.dart';
import 'package:wherehouse/database/Item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;



Future main() async {
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });
  test('Simple test', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
          await db
              .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
        });
    // Insert some data
    await db.insert('Test', {'value': 'my_value'});
    // Check content
    expect(await db.query('Test'), [
      {'id': 1, 'value': 'my_value'}
    ]);

    await db.close();
  });


  test('Add and retrieve item', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    const itemName = 'Test Item';
    const itemDescription = 'Test Description';
    const itemBarcodes = ['123', '456'];
    const locationUID = 1;

    final added = await itemManager.addItem(
      itemName,
      itemDescription,
      itemBarcodes,
      locationUID,
    );

    expect(added, isTrue);

    final items = await itemManager.queryItems(itemName);
    expect(items, hasLength(1));

    final retrievedItem = items.first;
    expect(retrievedItem.name, matcher.equals(itemName));
    expect(retrievedItem.description, matcher.equals(itemDescription));
    expect(retrievedItem.barcodes, matcher.equals(itemBarcodes));
    expect(retrievedItem.locationUID, matcher.equals(locationUID));
  });

  test('Remove item', () async {

    const itemName = 'Test Item';
    const itemDescription = 'Test Description';
    const itemBarcodes = ['123', '456'];
    const locationUID = 1;

    await itemManager.addItem(
      itemName,
      itemDescription,
      itemBarcodes,
      locationUID,
    );

    final itemsBeforeRemoval = await itemManager.queryItems(itemName);
    expect(itemsBeforeRemoval, hasLength(1));

    final itemUid = itemsBeforeRemoval.first.uid;
    final removed = await itemManager.removeItem(itemUid);

    expect(removed, true);

    final itemsAfterRemoval = await itemManager.queryItems(itemName);
    expect(itemsAfterRemoval, isEmpty);
  });

  test('Edit item', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    const itemName = 'Test Item';
    const itemDescription = 'Test Description';
    const itemBarcodes = ['123', '456'];
    const locationUID = 1;

    await itemManager.addItem(
      itemName,
      itemDescription,
      itemBarcodes,
      locationUID,
    );

    final itemsBeforeEdit = await itemManager.queryItems(itemName);
    expect(itemsBeforeEdit, hasLength(1));

    final itemUid = itemsBeforeEdit.first.uid;

    const editedItemName = 'Edited Item';
    const editedItemDescription = 'Edited Description';
    const editedItemBarcodes = ['789', '012'];
    const editedLocationUID = 2;

    final edited = await itemManager.editItem(
      uid: itemUid,
      name: editedItemName,
      barcodes: editedItemBarcodes,
      description: editedItemDescription,
      locationUID: editedLocationUID,
    );

    expect(edited, isNotNull);

    final itemsAfterEdit = await itemManager.queryItems(editedItemName);
    expect(itemsAfterEdit, hasLength(1));

    final editedItem = itemsAfterEdit.first;
    expect(editedItem.name, matcher.equals(editedItemName));
    expect(editedItem.description, matcher.equals(editedItemDescription));
    expect(editedItem.barcodes, matcher.equals(editedItemBarcodes));
    expect(editedItem.locationUID, matcher.equals(editedLocationUID));
  });
}