import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ItemManager.dart';
import 'UserManager.dart';
import 'Item.dart';
import 'User.dart';
import 'package:test/test.dart';


void main() {
  late UserManager usermanager;

  setUp(() async {

    usermanager = UserManager();
  });


  test('Item Manager Test', () async {
    ItemManager itemManager = ItemManager();

    // Test adding an item
    int newItemUid = 1;
    Map<int, int> locationQuantities = {1: 5, 2: 10};
    bool addItemResult = await itemManager.addItem(
      newItemUid,
      'Test Item',
      'Test Description',
      ['barcode1', 'barcode2'],
      locationQuantities,
      1,
    );
    expect(addItemResult, isTrue);

    // Test getting the added item
    Item retrievedItem = await Item.getItem(newItemUid);

    // Add more expect statements to validate other attributes of the retrieved item
  });

  test('User Manager Test', () async {
    UserManager userManager = UserManager();

    // Test adding a user
    int newUserUid = 1;
    Map<int, int> checkedOutItems = {1: 2, 3: 1};
    bool addUserResult = await userManager.addUser(newUserUid, 'Test User', checkedOutItems);
    expect(addUserResult, isTrue);

    // Test getting the added user
    User retrievedUser = await User.getUser(newUserUid);


  });

}
