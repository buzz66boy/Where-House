import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/LocationManager.dart';
import 'package:wherehouse/database/Location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;

void main() {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Get Location', () async {
    // Arrange
    Location newLocation = Location(
      uid: 1,
      name: 'Test Location',
      defaultLocation: 42,
    );

    // Act
    await newLocation.setLocation();
    Location retrievedLocation = await Location.getLocation(1);

    // Assert
    expect(retrievedLocation.uid, matcher.equals(newLocation.uid));
    expect(retrievedLocation.name, matcher.equals(newLocation.name));
    expect(retrievedLocation.defaultLocation, matcher.equals(newLocation.defaultLocation));
  });

  test('Location Not Found', () async {
    // Arrange & Act
    Future<Location> getLocationFuture = Location.getLocation(999);

    // Assert
    expect(getLocationFuture, throwsA(isA<Exception>()));
  });

  test('Set Location', () async {
    // Arrange
    Location newLocation = Location(
      uid: 2,
      name: 'Another Location',
      defaultLocation: 73,
    );

    bool success = await newLocation.setLocation();

    expect(success, isTrue);

  });

  test('Location To Map', () {
    // Arrange
    Location testLocation = Location(
      uid: 3,
      name: 'Test Location 3',
      defaultLocation: 99,
    );

    Map<String, dynamic> locationMap = testLocation.toMap();

    expect(locationMap['uid'], matcher.equals(3));
    expect(locationMap['name'], matcher.equals('Test Location 3'));
    expect(locationMap['defaultLocation'], matcher.equals(99));
  });

  test('Location From Map', () {

    Map<String, dynamic> locationMap = {
      'uid': 4,
      'name': 'Test Location 4',
      'defaultLocation': 123,
    };

    Location testLocation = Location.fromMap(locationMap);

    expect(testLocation.uid, matcher.equals(4));
    expect(testLocation.name, matcher.equals('Test Location 4'));
    expect(testLocation.defaultLocation, matcher.equals(123));
  });

  test('Location To String', () {

    Location testLocation = Location(
      uid: 5,
      name: 'Test Location 5',
      defaultLocation: 321,
    );

    String locationString = testLocation.toString();

    expect(locationString, matcher.equals('Location{uid: 5, name: Test Location 5, defaultLocation: 321}'));
  });
}