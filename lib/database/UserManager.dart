import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'User.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'pathtoAccountingLog.dart'

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
          'CREATE TABLE IF NOT EXISTS User('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'checkedOutItems TEXT'
              ')',
        );
      },
      version: 1,
    );
  }

  Future<bool> addUser(
      int uid,
      String name,
      Map<int, int> checkedOutItems,
      ) async {
    try {
      final result = await database.query(
        'User',
        where: 'uid = ?',
        whereArgs: [uid],
      );

      if (result.isNotEmpty) {
        return false;
      }
      String checkedOutItemsJson = User.encodeCheckedOutItems(checkedOutItems);
      User newUser = User(
        uid: uid,
        name: name,
        checkedOutItems: checkedOutItemsJson,
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
    Map<int, int>? checkedOutItems,
  }) async {
    User? existingUser;

    try {
      existingUser = await User.getUser(uid);

      if (existingUser.uid == uid) {
        if (name != null) existingUser.name = name;
        if (checkedOutItems != null) existingUser.checkedOutItems = User.encodeCheckedOutItems(checkedOutItems);

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
        await addUser(user.uid, user.name, user.checkedOutItems as Map<int, int>);
      }

      return true;
    } catch (e) {
        print('Error importing users: $e');
        return false;
    }
  }
}

