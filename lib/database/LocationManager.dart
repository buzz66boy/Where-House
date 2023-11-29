import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'Location.dart';
//import 'pathtoAccountingLog.dart'


class LocationManager {
  late Database database;

  LocationManager() {
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
              'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT, '
              'defaultLocation INTEGER'
              ')',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS User('
              'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT, '
              'checkedOutItems TEXT'
              ')',
        );
        /*await db.execute(
          'CREATE TABLE IF NOT EXISTS Transaction('
              'transactionUid INTEGER PRIMARY KEY AUTOINCREMENT, '
              'userUid INTEGER, '
              'itemUid INTEGER, '
              'locationUid INTEGER, '
              'FOREIGN KEY (userUid) REFERENCES User(uid), '
              'FOREIGN KEY (itemUid) REFERENCES Item(uid), '
              'FOREIGN KEY (locationUid) REFERENCES Location(uid)'
              ')',
        );*/
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

  // Add location method
  Future<bool> addLocation(

      String name,
      int defaultLocation,
      ) async {
    try {
      database = await openDatabase('WhereHouse.db');

      Location newLocation = Location(
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
      database = await openDatabase('WhereHouse.db');
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
    database = await openDatabase('WhereHouse.db');

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
  Future<List<Location>> queryLocations([String query = '']) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Map> results;

      if (query.isNotEmpty) {
        results = await database.query('Location',
            where: 'name LIKE ? OR UID LIKE ?',
            whereArgs: List.filled(2, '%$query%'));
      } else {
        results = await database.query('Location');
      }

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


  // Export locations to a file
  Future<bool> exportLocations(String outfileLocation) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Location> locations = await queryLocations('');

      String locationsJson = jsonEncode(locations.map((location) => location.toMap()).toList());

      await File(outfileLocation).writeAsString(locationsJson);
      return true;
    } catch (e) {
      print('Error exporting locations: $e');
      return false;
    }
  }

  // Import locations from a file
  Future<bool> importLocations(String infileLocation) async {
    try {
      String fileContent = await File(infileLocation).readAsString();

      List<Map<String, dynamic>> locationMaps = List<Map<String, dynamic>>.from(jsonDecode(fileContent));
      List<Location> locations = locationMaps.map((locationMap) => Location.fromMap(locationMap)).toList();

      for (Location location in locations) {
        await addLocation(location.name, location.defaultLocation);
      }

      return true;
    } catch (e) {
      print('Error importing locations: $e');
      return false;
    }
  }
}

