import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'User.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class UserManager {
  late Database database;

  UserManager() {
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
        await db.execute(
          'CREATE TABLE IF NOT EXISTS Transaction('
              'transactionUid INTEGER PRIMARY KEY AUTOINCREMENT, '
              'userUid INTEGER, '
              'itemUid INTEGER, '
              'locationUid INTEGER, '
              'FOREIGN KEY (userUid) REFERENCES User(uid), '
              'FOREIGN KEY (itemUid) REFERENCES Item(uid), '
              'FOREIGN KEY (locationUid) REFERENCES Location(uid)'
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
      },
      version: 1,
    );

  }

  Future<bool> addUser(
      String name,
      List<dynamic> checkedOutItems,
      ) async {
    try {
      database = await openDatabase('WhereHouse.db');

      User newUser = User(
        name: name,
        checkedOutItems: checkedOutItems,
      );

      bool success = await newUser.setUser();

      return success;
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  Future<bool> removeUser(int uid) async {
    try {
      database = await openDatabase('WhereHouse.db');
      int rowsDeleted = await database.delete('User', where: 'uid = ?', whereArgs: [uid]);
      return rowsDeleted > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User?> editUser({
    required int uid,
    String? name,
    List<int>? checkedOutItems,
  }) async {
    User? existingUser;

    try {
      existingUser = await User.getUser(uid);
      database = await openDatabase('WhereHouse.db');

      if (existingUser.uid == uid) {
        if (name != null) existingUser.name = name;
        if (checkedOutItems != null) existingUser.checkedOutItems = checkedOutItems;

        await existingUser.setUser();
        return existingUser;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<User>> queryUsers([String query = '']) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<Map> results;

      if (query.isNotEmpty) {
        results = await database.query(
          'User',
          where: 'name LIKE ? OR UID LIKE ?',
          whereArgs: List.filled(2, '%$query%'),
        );
      } else {
        results = await database.query('User');
      }

      return results.map((user) {
        return User(
          uid: user['uid'],
          name: user['name'],
          checkedOutItems: jsonDecode(user['checkedOutItems']),
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }


  Future<bool> exportUsers(String outfileLocation) async {
    try {
      database = await openDatabase('WhereHouse.db');
      List<User> users = await queryUsers('');

      String usersJson = jsonEncode(users.map((user) => user.toMap()).toList());

      await File(outfileLocation).writeAsString(usersJson);
      return true;
    } catch (e) {
      print('Error exporting users: $e');
      return false;
    }
  }

  // Import users from a file
  Future<bool> importUsers(String infileLocation) async {
    try {
      String fileContent = await File(infileLocation).readAsString();

      List<Map<String, dynamic>> userMaps = List<Map<String, dynamic>>.from(jsonDecode(fileContent));
      List<User> users = userMaps.map((userMap) => User.fromMap(userMap)).toList();

      for (User user in users) {
        await addUser(user.name, user.checkedOutItems);
      }

      return true;
    } catch (e) {
      print('Error importing users: $e');
      return false;
    }
  }


}



