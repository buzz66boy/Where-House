import 'dart:convert';
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:wherehouse/database/TransactionManager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
        'CREATE TABLE IF NOT EXISTS Transaction('
            'transactionUid INTEGER PRIMARY KEY, '
            'userUid INTEGER, '
            'itemUid INTEGER, '
            'locationUid INTEGER, '
            'FOREIGN KEY (userUid) REFERENCES User(uid), '
            'FOREIGN KEY (itemUid) REFERENCES Item(uid), '
            'FOREIGN KEY (locationUid) REFERENCES Location(uid)'
            ')',
      );
    }, version: 1);
  });

  // Tear down and close the database after tests
  tearDown(() async {
    final databasePath = await getDatabasesPath();
    await deleteDatabase(join(databasePath, 'WhereHouse.db'));
  });

  test('Get Transaction', () async {
    TransactionManager transactionManager = TransactionManager();
    // Add a transaction to the database for retrieval
    bool addResult = await transactionManager.setTransaction(1, 2, 3);
    expect(addResult, true);

    // Ensure that getting a transaction returns a non-null Transaction object
    Transaction? retrievedTransaction = await transactionManager.getTransaction(1);
    expect(retrievedTransaction, isNotNull);

    // Ensure that the retrieved transaction has the correct values
    expect(retrievedTransaction!.userUid, equals(1));
    expect(retrievedTransaction.itemUid, equals(2));
    expect(retrievedTransaction.locationUid, equals(3));
  });

  test('Query Transactions', () async {
    // Ensure that querying transactions returns a non-null list
    List<Transaction> transactions = await transactionManager
        .queryTransactions();
    expect(transactions, isNotNull);
  });
}