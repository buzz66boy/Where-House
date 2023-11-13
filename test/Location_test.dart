import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'package:wherehouse/database/Location.dart';
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
        'CREATE TABLE IF NOT EXISTS Location('
            'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'defaultLocation INTEGER'
            ')',
      );
    }, version: 1);
  });

  // Tear down and close the database after tests
  tearDown(() async {
    final databasePath = await getDatabasesPath();
    await deleteDatabase(join(databasePath, 'WhereHouse.db'));
  });


  test('Get Location', () async {
    Location testLocation = Location(name:'Lab1', defaultLocation: 1);
    await testLocation.setLocation();
    // Ensure that getting a location returns a Location object
    Location location = await Location.getLocation(testLocation.uid);
    expect(location, isA<Location>());
  });

  test('Set Location', () async {
    Location testLocation = Location(name:'Lab1', defaultLocation: 1);
    await testLocation.setLocation();
    // Ensure that setting a location returns true
    bool result = await testLocation.setLocation();
    expect(result, true);

    // Ensure that the uid is updated after setting the location
    expect(testLocation.uid, greaterThan(-1));
  });

  test('Location from Map', () {
    // Ensure that creating a Location from a map returns a Location object
    Location locationFromMap = Location.fromMap({
      'uid': 1,
      'name': 'Mapped Location',
      'defaultLocation': 0,
    });
    expect(locationFromMap, isA<Location>());
    expect(locationFromMap.uid, matcher.equals(1));
    expect(locationFromMap.name, matcher.equals('Mapped Location'));
    expect(locationFromMap.defaultLocation, matcher.equals(0));
  });

  test('Location to Map', () async {
    Location testLocation = Location(name:'Lab1', defaultLocation: 1);
    await testLocation.setLocation();
    // Ensure that converting a Location to a map returns the expected map
    Map<String, dynamic> locationMap = testLocation.toMap();
    expect(locationMap, isA<Map>());
    expect(locationMap['uid'], matcher.equals(testLocation.uid));
    expect(locationMap['name'], matcher.equals(testLocation.name));
    expect(locationMap['defaultLocation'], matcher.equals(testLocation.defaultLocation));
  });

  test('Location toString', () async {
    Location testLocation = Location(name:'Lab1', defaultLocation: 1);
    await testLocation.setLocation();
    // Ensure that calling toString on a Location returns the expected string
    String locationString = testLocation.toString();
    expect(locationString, isA<String>());
    expect(locationString, contains('uid: ${testLocation.uid}'));
    expect(locationString, contains('name: ${testLocation.name}'));
    expect(locationString, contains('defaultLocation: ${testLocation.defaultLocation}'));
  });
}
