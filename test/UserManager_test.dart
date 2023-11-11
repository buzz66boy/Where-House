import 'dart:convert';
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/database/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:matcher/src/equals_matcher.dart' as matcher;




void main() {
  // Set up sqflite_common_ffi before running tests
  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    final databasePath = await getDatabasesPath();
    await openDatabase(join(databasePath, 'WhereHouse.db'), onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS User('
            'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'checkedOutItems TEXT'
            ')',
      );
    }, version: 1);
  });

  // Tear down and close the database after tests
  tearDown(() async {
    final databasePath = await getDatabasesPath();
    await deleteDatabase(join(databasePath, 'WhereHouse.db'));
  });

  test('Add and retrieve user', () async {
    UserManager userManager = UserManager();

    bool addeduser =  await userManager.addUser('John Doe', []);

    final retrievedUser = await User.getUser(1);
    expect(addeduser, true);
    expect(retrievedUser, isNotNull);
    expect(retrievedUser.name, 'John Doe');
  });



}
