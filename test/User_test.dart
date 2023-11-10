import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/User.dart';
import 'package:sqflite/sqflite.dart';



void main() {

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Set User Test', () async {
    // Create a test user
    User testUser = User(
      uid: 1,
      name: 'Test User',
      checkedOutItemsJson: '{}', // Adjust based on your test data
    );

    // Save the user to the database
    final bool isUserSet = await testUser.setUser();

    // Fetch the user from the database
    //final User? retrievedUser = await User.getUser(1);

    // Verify if the user was set and retrieved successfully
    expect(isUserSet, true); // Check if the user was successfully set
    //expect(retrievedUser, isNotNull); // Check if the retrieved user is not null


  });
}