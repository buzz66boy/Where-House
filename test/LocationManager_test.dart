import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;



Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late LocationManager locationManager;

  locationManager = LocationManager();

  await locationManager.initializeDatabase();



  test('Add Duplicate Location', () async {
    // Arrange
    LocationManager locationManager = LocationManager();

    // Act
    bool success1 = await locationManager.addLocation(2, 'Location A', 10);
    bool success2 = await locationManager.addLocation(2, 'Location B', 20);

    // Assert
    expect(success1, isTrue);
    expect(success2, isFalse);
  });

  test('Remove Location', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(3, 'Location C', 30);

    // Act
    bool success = await locationManager.removeLocation(3);

    // Assert
    expect(success, isTrue);
  });

  test('Remove Non-existent Location', () async {
    // Arrange
    LocationManager locationManager = LocationManager();

    // Act
    bool success = await locationManager.removeLocation(999);

    // Assert
    expect(success, isFalse);
  });

  test('Edit Location', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(4, 'Location D', 40);

    // Act
    Location? editedLocation = await locationManager.editLocation(uid: 4, name: 'Edited Location', defaultLocation: 44);

    // Assert
    expect(editedLocation, isNotNull);
    expect(editedLocation!.name, matcher.equals('Edited Location'));
    expect(editedLocation.defaultLocation, matcher.equals(44));
  });

  test('Edit Non-existent Location', () async {
    // Arrange
    LocationManager locationManager = LocationManager();

    // Act
    Location? editedLocation = await locationManager.editLocation(uid: 999, name: 'Edited Location', defaultLocation: 99);

    // Assert
    expect(editedLocation, isNull);
  });

  test('Query Locations', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(5, 'Location E1', 50);
    await locationManager.addLocation(6, 'Location E2', 60);

    // Act
    List<Location> locations = await locationManager.queryLocations();

    // Assert
    expect(locations.length, matcher.equals(2));
    expect(locations[0].uid, matcher.equals(5));
    expect(locations[1].uid, matcher.equals(6));
  });

  test('Query Locations with Filter', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(7, 'Location F1', 70);
    await locationManager.addLocation(8, 'Location F2', 80);

    // Act
    List<Location> locations = await locationManager.queryLocations('F1');

    // Assert
    expect(locations.length, matcher.equals(1));
    expect(locations[0].uid, matcher.equals(7));
  });

  test('Export Locations', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(9, 'Location G1', 90);
    await locationManager.addLocation(10, 'Location G2', 100);

    // Act
    bool success = await locationManager.exportLocations('locations_export.json');

    // Assert
    expect(success, isTrue);
  });

  test('Import Locations', () async {
    // Arrange
    LocationManager locationManager = LocationManager();
    await locationManager.addLocation(11, 'Location H1', 110);
    await locationManager.addLocation(12, 'Location H2', 120);

    // Act
    bool success = await locationManager.importLocations('locations_export.json');

    // Assert
    expect(success, isTrue);
  });
}