import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/database/User.dart';
import 'package:matcher/src/equals_matcher.dart' as matcher;

void main() {
  // Set up sqflite_common_ffi before running tests
  setUp(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    final databasePath = await getDatabasesPath();
    await openDatabase(
        join(databasePath, 'WhereHouse.db'), onCreate: (db, version) async {
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

  test('Set User', () async {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    bool result = await testUser.setUser();
    expect(result, true);

    // Ensure that the user has a valid UID after setting
    expect(testUser.uid, isNot(matcher.equals(-1)));
  });

  test('Get User', () async {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    await testUser.setUser();

    // Retrieve the user by UID
    User retrievedUser = await User.getUser(testUser.uid);

    // Ensure the retrieved user matches the original
    expect(retrievedUser.name, matcher.equals(testUser.name));
    expect(retrievedUser.checkedOutItems, matcher.equals(testUser.checkedOutItems));
  });

  test('Get Nonexistent User', () {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    expect(() async {
      await User.getUser(-1);
    }, throwsA(isA<Exception>()));
  });

  test('To Map', () {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    Map<String, dynamic> userMap = testUser.toMap();

    // Ensure the map has the expected properties
    expect(userMap['name'], matcher.equals(testUser.name));
    expect(userMap['checkedOutItems'], matcher.equals(jsonEncode(testUser.checkedOutItems)));

    // UID should not be in the map for a new user
    expect(userMap.containsKey('uid'), isFalse);
  });

  test('From Map', () {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    Map<String, dynamic> userMap = testUser.toMap();

    // Create a new user from the map
    User fromMapUser = User.fromMap(userMap);

    // Ensure the created user matches the original
    expect(fromMapUser.name, matcher.equals(testUser.name));
    expect(fromMapUser.checkedOutItems, matcher.equals(testUser.checkedOutItems));
  });

  test('Update User', () async {
    User testUser = User(name:'Chloe', checkedOutItems:[]);
    await testUser.setUser();

    // Update the user's name and checkedOutItems
    String newName = 'Updated Name';
    List<dynamic> newCheckedOutItems = [4, 5, 6];
    testUser.name = newName;
    testUser.checkedOutItems = newCheckedOutItems;

    // Update the user in the database
    bool updateResult = await testUser.setUser();
    expect(updateResult, true);

    // Retrieve the updated user
    User updatedUser = await User.getUser(testUser.uid);

    // Ensure the retrieved user matches the updated values
    expect(updatedUser.name, matcher.equals(newName));
    expect(updatedUser.checkedOutItems, matcher.equals(newCheckedOutItems));
  });

}

