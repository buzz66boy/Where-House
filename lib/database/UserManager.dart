import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'User.dart';
//import 'pathtoAccountingLog.dart'

class UserManager {
  late Database database;

  UserManager() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
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

      User newUser = User(
        uid: uid,
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

  Future<List<User>> queryUsers(String query) async {
    try {
      List<Map> results = await database.query(
        'User',
        where: 'name LIKE ? OR UID LIKE ?',
        whereArgs: List.filled(2, '%$query%'),
      );

      return results.map((user) {
        return User(
          uid: user['uid'],
          name: user['name'],
          checkedOutItems: _decodeCheckedOutItems(user['checkedOutItems']),
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Map<int, int> _decodeCheckedOutItems(String json) {
    return Map<int, int>.from(jsonDecode(json));
  }
}