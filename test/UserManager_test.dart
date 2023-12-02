import 'dart:convert';
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/database/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;




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


  test('Add User', () async {
    UserManager userManager = UserManager();
    // Ensure that adding a user returns true
    bool result = await userManager.addUser('Test User', []);
    expect(result, true);

    // Ensure that the user has been added to the database
    List<User> users = await userManager.queryUsers('Test User');
    expect(users.length, matcher.equals(1));
    expect(users[0].name, matcher.equals('Test User'));
  });

  test('Remove User', () async {
    UserManager userManager = UserManager();
    // Add a user to the database for removal
    bool addResult = await userManager.addUser('Test User', []);
    expect(addResult, true);

    // Ensure that removing a user returns true
    List<User> usersBeforeRemoval = await userManager.queryUsers('Test User');
    bool removeResult = await userManager.removeUser(usersBeforeRemoval[0].uid);
    expect(removeResult, true);

    // Ensure that the user has been removed from the database
    List<User> usersAfterRemoval = await userManager.queryUsers('Test User');
    expect(usersAfterRemoval.length, matcher.equals(0));
  });

  test('Edit User', () async {
    UserManager userManager = UserManager();
    // Add a user to the database for editing
    bool addResult = await userManager.addUser('Test User', []);
    expect(addResult, true);

    // Ensure that editing a user returns a non-null User object
    List<User> usersBeforeEdit = await userManager.queryUsers('Test User');
    User? editedUser = await userManager.editUser(
      uid: usersBeforeEdit[0].uid,
      name: 'Edited User',
      checkedOutItems: [1, 2, 3],
    );
    expect(editedUser, isNotNull);

    // Ensure that the user has been edited in the database
    List<User> usersAfterEdit = await userManager.queryUsers('Edited User');
    expect(usersAfterEdit.length, matcher.equals(1));
    expect(usersAfterEdit[0].name, matcher.equals('Edited User'));
    expect(usersAfterEdit[0].checkedOutItems, matcher.equals([1, 2, 3]));
  });

  test('Query Users', () async {
    UserManager userManager = UserManager();
    // Ensure that querying users returns a non-null list
    List<User> users = await userManager.queryUsers();
    expect(users, isNotNull);
  });

  test('Export Users', () async {
    UserManager userManager = UserManager();
    // Add a user to the database for exporting
    bool addResult = await userManager.addUser('Test User', []);
    expect(addResult, true);

    // Ensure that exporting users returns true
    bool exportResult = await userManager.exportUsers('exported_users.json');
    expect(exportResult, true);

    // Ensure that the exported file exists
    File exportedFile = File('exported_users.json');
    expect(exportedFile.existsSync(), true);

  });

  test('Import Users', () async {
    UserManager userManager = UserManager();
    // Create a file with user data for importing
   /* String testData = '[{"uid":1,"name":"Imported User","checkedOutItems":[]}]';
    File importFile = File('test_users_import.json')..writeAsStringSync(testData);*/

    bool importResult = await userManager.importUsers('exported_users.json');
    expect(importResult, true);

  });
}