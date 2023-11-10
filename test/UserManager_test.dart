import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/database/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:matcher/src/equals_matcher.dart' as matcher;



Future<void> main() async {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late UserManager userManager;

  setUp(() async {
    userManager = UserManager();

    await userManager.initializeDatabase();
  });

  test('Add user test', () async {

    int uid = 1;
    String name = "John Doe";
    Map<int, int> checkedOutItems = {101: 1, 102: 2};

    bool userAdded = await userManager.addUser(uid, name, checkedOutItems);

    expect(userAdded, true);

    // Verify the user was added
    List<User> users = await userManager.queryUsers('');

    expect(users.length, 1);
    expect(users[0].uid, uid);
    expect(users[0].name, name);
    //expect(users[0].checkedOutItems, checkedOutItems);
  });


  test('Edit user test', () async {
    await userManager.initializeDatabase();
    int uid = 1;
    String newName = "Jane Doe";
    Map<int, int> newCheckedOutItems = {103: 1, 104: 2};

    User? editedUser = await userManager.editUser(uid: uid, name: newName, checkedOutItems: newCheckedOutItems);

    expect(editedUser, isNotNull);

    // Verify the user was edited
    List<User> users = await userManager.queryUsers();
    expect(users.length, 1);
    expect(users[0].uid, uid);
    expect(users[0].name, newName);
    //expect(users[0].checkedOutItems, newCheckedOutItems);
  });

  test('Remove user test', () async {
    await userManager.initializeDatabase();
    int uid = 1;
    bool userRemoved = await userManager.removeUser(uid);

    expect(userRemoved, true);

    // Verify the user was removed
    List<User> users = await userManager.queryUsers();
    expect(users.length, 0);
  });

  test('Export and import users test', () async {
    await userManager.initializeDatabase();
    // Export users
    String exportPath = 'exported_users.json';
    bool exportSuccess = await userManager.exportUsers(exportPath);
    expect(exportSuccess, true);

    // Clear existing users
    List<User> usersBeforeImport = await userManager.queryUsers();
    for (User user in usersBeforeImport) {
      await userManager.removeUser(user.uid);
    }

    // Import users
    bool importSuccess = await userManager.importUsers(exportPath);
    expect(importSuccess, true);

    // Verify imported users
    List<User> importedUsers = await userManager.queryUsers();
    expect(importedUsers.length, usersBeforeImport.length);
  });


}

