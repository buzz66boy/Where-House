import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/User.dart';
import 'package:sqflite/sqflite.dart';


void main() {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('User Set and Get Test', () async {
    User newUser = User(
      uid: 1,
      name: 'John Doe',
      checkedOutItems: '{"101": 2, "102": 3}',
    );

    // Save the user to the database
    bool isUserSet = await newUser.setUser();
    expect(isUserSet, true);

    // Retrieve the user from the database
    User retrievedUser = await User.getUser(1);

    // Check if the retrieved user matches the original user
    expect(retrievedUser.uid, newUser.uid);
    expect(retrievedUser.name, newUser.name);
    expect(retrievedUser.checkedOutItems, newUser.checkedOutItems);
  });

  test('User FromMap Test', () {
    Map<String, dynamic> userMap = {
      'uid': 1,
      'name': 'John Doe',
      'checkedOutItems': '{"101": 2, "102": 3}',
    };

    User user = User.fromMap(userMap);

    // Check if the User instance is created correctly from the map
    expect(user.uid, userMap['uid']);
    expect(user.name, userMap['name']);
    expect(user.checkedOutItems, userMap['checkedOutItems']);
  });

  test('User ToMap Test', () {
    User user = User(
      uid: 1,
      name: 'John Doe',
      checkedOutItems: '{"101": 2, "102": 3}',
    );

    Map<String, dynamic> userMap = user.toMap();

    // Check if the map representation of the user matches the original user
    expect(userMap['uid'], user.uid);
    expect(userMap['name'], user.name);
    expect(userMap['checkedOutItems'], jsonEncode(user.checkedOutItems));
  });
}
