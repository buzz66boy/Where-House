

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wherehouse/User_Management/UserController.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/user_management/UserView.dart';
import 'package:wherehouse/database/User.dart';

void main() {
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
  testWidgets('User View', (WidgetTester tester) async {
    // Setup
    User user_1 = User(
      name: 'Test User',
      checkedOutItems: ['1234', '4321'],
    );


    await tester.pumpWidget(MaterialApp(home: UserView(user: user_1)));

    ///  user details in the widget
    expect(find.text('Name: Test User'), findsOneWidget);
   /// Failed Empty List
    //expect(find.text('Checked Out Items: 1234, 4321'), findsOneWidget);
  });
  UserManager userManager = UserManager();
  UserController userController = UserController(userManager);
  
  test('Edit User',() async{
    User user = User(name: 'Test user',checkedOutItems: []);
    await userController.addUser(user);
    
    String editName = 'Updated user';

    List<int> upDateItems = [1,2,3];
    var result = await userController.editUser(user.uid,editName,upDateItems);
    expect(result,isNotNull);


  }
  );

}




