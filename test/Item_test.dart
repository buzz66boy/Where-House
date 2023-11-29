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
    }, version: 1);
  });

  // Tear down and close the database after tests
  tearDown(() async {
    final databasePath = await getDatabasesPath();
    await deleteDatabase(join(databasePath, 'WhereHouse.db'));
  });

  test('Get Item', () async {
    Item testItem = Item(name:'Chalk', description: "White", barcodes: ['123','456'], locationUID: 89);

    await testItem.setItem();
    Item retrievedItem = await Item.getItem(testItem.uid);
    expect(retrievedItem, isNotNull);
    expect(retrievedItem.uid, matcher.equals(testItem.uid));
  });

  test('Set Item', () async {
    Item testItem = Item(name:'Chalk', description: "White", barcodes: ['123','456'], locationUID: 89);

    bool result = await testItem.setItem();
    expect(result, true);

    // Ensure that the item has been set in the database
    Item retrievedItem = await Item.getItem(testItem.uid);
    expect(retrievedItem, isNotNull);
    expect(retrievedItem.uid, matcher.equals(testItem.uid));
  });

  test('From Map', () {
    // Ensure that creating an item from a map returns a non-null Item object
    Map<String, dynamic> itemMap = {
      'uid': 1,
      'name': 'Test Item',
      'description': 'Test Description',
      'barcodes': '12345,67890',
      'locationUID': 1,
    };
    Item mappedItem = Item.fromMap(itemMap);
    expect(mappedItem, isNotNull);
    expect(mappedItem.uid, matcher.equals(1));
    expect(mappedItem.name, matcher.equals('Test Item'));
    expect(mappedItem.description, matcher.equals('Test Description'));
    expect(mappedItem.barcodes, matcher.equals(['12345', '67890']));
    expect(mappedItem.locationUID, matcher.equals(1));
  });

  test('To Map', () async {
    Item testItem = Item(name:'Chalk', description: "White", barcodes: ['123','456'], locationUID: 89);

    await testItem.setItem();
    // Ensure that converting an item to a map returns a non-null map
    Map<String, dynamic> itemMap = testItem.toMap();
    expect(itemMap, isNotNull);
    expect(itemMap['uid'], matcher.equals(testItem.uid));
    expect(itemMap['name'], matcher.equals('Chalk'));
    expect(itemMap['description'], matcher.equals('White'));
    expect(itemMap['barcodes'], matcher.equals('123,456'));
    expect(itemMap['locationUID'], matcher.equals(89));
  });

  test('ToString', () async{
    Item testItem = Item(name:'Chalk', description: "White", barcodes: ['123','456'], locationUID: 89);

    await testItem.setItem();
    // Ensure that converting an item to a string returns a non-null string
    String itemString = testItem.toString();
    expect(itemString, isNotNull);
    expect(itemString.contains('uid: ${testItem.uid}'), true);
    expect(itemString.contains('name: ${testItem.name}'), true);
    expect(itemString.contains('description: ${testItem.description}'), true);
    expect(itemString.contains('barcodes: ${testItem.barcodes}'), true);
    expect(itemString.contains('locationQuantities: ${testItem.locationUID}'), true);
  });
}


