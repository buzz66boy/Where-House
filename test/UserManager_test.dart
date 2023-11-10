import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:matcher/src/equals_matcher.dart' as matcher;

void main() {
  late UserManager userManager;
  late Database database;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'db_test.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS User('
              'uid INTEGER PRIMARY KEY, '
              'name TEXT, '
              'checkedOutItems TEXT'
              ')',
        );
      },
    );

    userManager = UserManager();
    userManager.database = database;
  });


  test('Add and Remove User Test', () async {
    // Test adding a user
    final int uid = 1;
    final String name = 'John Doe';
    final Map<int, int> checkedOutItems = {1: 2, 2: 3};

    final added = await userManager.addUser(uid, name, checkedOutItems);
    expect(added, isTrue);

    // Test removing the added user
    //final removed = await userManager.removeUser(uid);
    //expect(removed, isTrue);
  });
}