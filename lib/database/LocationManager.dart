import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Location.dart';
//import 'pathtoAccountingLog.dart'


class LocationManager {
  late Database database;

  LocationManager() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'WhereHouse.db');

    database = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS Location('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'defaultLocation INTEGER'
              ')',
        );
      },
      version: 1,
    );
  }

  // Add location method
  Future<bool> addLocation(
      int uid,
      String name,
      int defaultLocation,
      ) async {
    try {
      final result = await database.query(
        'Location',
        where: 'uid = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {
        return false;
      }

      Location newLocation = Location(
        uid: uid,
        name: name,
        defaultLocation: defaultLocation,
      );

      bool success = await newLocation.setLocation();
      return success;
    } catch (e) {
      print('Error adding location: $e');
      return false;
    }
  }

  // Remove location method
  Future<bool> removeLocation(int uid) async {
    try {
      int rowsDeleted = await database.delete('Location', where: 'UID = ?', whereArgs: [uid]);
      return rowsDeleted > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Edit location method
  Future<Location?> editLocation({
    required int uid,
    String? name,
    int? defaultLocation,
  }) async {
    Location existingLocation = await Location.getLocation(uid);

    if (existingLocation.uid == uid) {
      if (name != null) existingLocation.name = name;
      if (defaultLocation != null) existingLocation.defaultLocation = defaultLocation;

      try {
        await existingLocation.setLocation();
        return existingLocation;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return null;
    }
  }

  // Query locations method
  Future<List<Location>> queryLocations(String query) async {
    try {
      List<Map> results = await database.query('Location',
          where: 'name LIKE ? OR UID LIKE ?',
          whereArgs: List.filled(2, '%$query%'));
      return results.map((location) {
        return Location(
          uid: location['uid'],
          name: location['name'],
          defaultLocation: location['defaultLocation'],
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
