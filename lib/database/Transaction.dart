import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Transaction {
  int transactionUid;
  int userUid;
  int itemUid;
  int locationUid;

  Transaction({
    required this.transactionUid,
    required this.userUid,
    required this.itemUid,
    required this.locationUid,
  });

  static Future<Transaction> getTransaction(int transactionId) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query('Transaction', where: 'transactionUid = ?', whereArgs: [transactionId]);
    await db.close();

    if (results.isNotEmpty) {
      return Transaction(
        transactionUid: results[0]['transactionUid'],
        userUid: results[0]['userUid'],
        itemUid: results[0]['itemUid'],
        locationUid: results[0]['locationUid'],
      );
    } else {
      throw Exception("Transaction not found in the database");
    }
  }

  Future<bool> updateTransaction() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.update('Transaction', toMap(), where: 'transactionUid = ?', whereArgs: [transactionUid]);
      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionUid': transactionUid,
      'userUid': userUid,
      'itemUid': itemUid,
      'locationUid': locationUid
    };
  }

  @override
  String toString() {
    return 'Transaction{transactionUid: $transactionUid, userUid: $userUid, itemUid: $itemUid, locationUid: $locationUid}';
  }
}
