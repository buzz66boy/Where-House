import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:matcher/src/equals_matcher.dart' as matcher;



Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late LocationManager locationManager;

  locationManager = LocationManager();

  await locationManager.initializeDatabase();


  test('Add and Query Location', () async {

    const int uid = 1;
    const String name = 'Warehouse A';
    const int defaultLocation = 1;

    // Add location
    final result = await locationManager.addLocation(1, 'LocationName', 42);

    // Perform assertions based on the result
    expect(result, isTrue);


    // Query location
    List<Location> locations = await locationManager.queryLocations();
    expect(locations, hasLength(1));

    // Verify location details
    expect(locations[0].uid, uid);
    expect(locations[0].name, name);
    expect(locations[0].defaultLocation, defaultLocation);
  });

  test('Remove Location', () async {
    const int uid = 1;
    const String name = 'Warehouse A';
    const int defaultLocation = 101;

    // Add location
    bool locationAdded = await locationManager.addLocation(
        uid, name, defaultLocation);
    expect(locationAdded, isTrue);

    // Remove location
    bool locationRemoved = await locationManager.removeLocation(uid);
    expect(locationRemoved, isTrue);

    // Query locations, should be empty
    List<Location> locations = await locationManager.queryLocations();
    expect(locations, isEmpty);
  });

  // Add more LocationManager tests as needed...

  test('Get Location', () async {
    const int uid = 1;
    const String name = 'Warehouse A';
    const int defaultLocation = 101;

    // Create and set location
    Location location = Location(
        uid: uid, name: name, defaultLocation: defaultLocation);
    bool setLocationResult = await location.setLocation();
    expect(setLocationResult, isTrue);

    // Retrieve location
    Location retrievedLocation = await Location.getLocation(uid);

    // Verify location details
    expect(retrievedLocation.uid, uid);
    expect(retrievedLocation.name, name);
    expect(retrievedLocation.defaultLocation, defaultLocation);
  });
}