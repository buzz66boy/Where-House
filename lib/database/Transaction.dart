import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Transaction {
  int uid;

  Transaction({
    required this.uid,
  });

  static Future<Transaction> getTransaction(int uniqueId) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results =
        await db.query('Transaction', where: 'UID = ?', whereArgs: [uniqueId]);
    await db.close();

    if (results.isNotEmpty) {
      return Transaction(
        uid: results[0]['uid'],
      );
    } else {
      throw Exception("Transaction not found in the database");
    }
  }

  Future<bool> setTransaction() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.update('Item', toMap(), where: 'uid = ?', whereArgs: [uid]);
      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid};
  }

  bool overwrite(Transaction newTransaction, Transaction oldTransaction) {
    if (newTransaction != null &&
        oldTransaction != null &&
        doesTransactionExist(oldTransaction)) {
      replaceTransactionInLog(newTransaction, oldTransaction);
      return true;
    }
    return false;
  }

  // Other transaction methods...

  @override
  String toString() {
    return 'Transaction{id: $uid}';
  }
}
