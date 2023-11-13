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


  test('Add Location', () async {
    LocationManager testLocationManager = LocationManager();
    bool result = await testLocationManager.addLocation('Test Location', 1);
    expect(result, true);
  });

  test('Remove Location', () async {
    LocationManager testLocationManager = LocationManager();
    await testLocationManager.addLocation('Test Location', 1);

    // Retrieve the location by name
    List<Location> locations = await testLocationManager.queryLocations('Test Location');
    expect(locations, isNotEmpty);

    // Remove the added location
    bool removeResult = await testLocationManager.removeLocation(locations[0].uid);
    expect(removeResult, true);
  });

  test('Edit Location', () async {
    LocationManager testLocationManager = LocationManager();
    await testLocationManager.addLocation('Test Location', 1);

    // Retrieve the location by name
    List<Location> locations = await testLocationManager.queryLocations('Test Location');
    expect(locations, isNotEmpty);

    // Edit the added location
    String newName = 'Updated Location';
    Location? editedLocation = await testLocationManager.editLocation(
      uid: locations[0].uid,
      name: newName,
    );

    // Ensure the edited location is not null and has the updated name
    expect(editedLocation, isNotNull);
    expect(editedLocation!.name, matcher.equals(newName));
  });

  test('Query Locations', () async {
    LocationManager testLocationManager = LocationManager();
    await testLocationManager.addLocation('Location 1', 1);
    await testLocationManager.addLocation('Location 2', 0);

    // Query locations with a specific name
    List<Location> queriedLocations = await testLocationManager.queryLocations('Location 1');
    expect(queriedLocations, hasLength(1));
    expect(queriedLocations[0].name, matcher.equals('Location 1'));

    // Query all locations
    List<Location> allLocations = await testLocationManager.queryLocations();
    expect(allLocations, hasLength(greaterThanOrEqualTo(2)));
  });

   test('Export and Import Locations', () async {
    LocationManager testLocationManager = LocationManager();
    await testLocationManager.addLocation('Export Location 1', 1);
    await testLocationManager.addLocation('Export Location 2', 0);

    bool exportResult = await testLocationManager.exportLocations('locations_export.json');
    expect(exportResult, true);

    // Import locations from the exported file

    bool importResult = await testLocationManager.importLocations('locations_export.json');
    expect(importResult, true);

  });
}
