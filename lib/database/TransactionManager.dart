import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'pathtoAccountingLog.dart'


class Transaction {
  late int transactionUid;
  late int userUid;
  late int itemUid;
  late int locationUid;

  Transaction({
    required this.transactionUid,
    required this.userUid,
    required this.itemUid,
    required this.locationUid,
  });

  static Future<Transaction?> getTransaction(int transactionUid) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results = await db.query('Transaction',
        where: 'transactionUid = ?', whereArgs: [transactionUid]);
    await db.close();

    if (results.isNotEmpty) {
      return Transaction(
        transactionUid: results[0]['transactionUid'],
        userUid: results[0]['userUid'],
        itemUid: results[0]['itemUid'],
        locationUid: results[0]['locationUid'],
      );
    } else {
      return null;
    }
  }

  Future<bool> setTransaction() async {
    Database db = await openDatabase('WhereHouse.db');
    try {
      await db.insert(
        'Transaction',
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await db.close();
      return true;
    } catch (e) {
      print(e);
      await db.close();
      return false;
    }
  }

  static Future<List<Transaction>> queryTransactions([String query = '']) async {
    Database db = await openDatabase('WhereHouse.db');
    List<Map> results;

    if (query.isNotEmpty) {
      results = await db.query('Transaction',
          where: 'userUid LIKE ? OR itemUid LIKE ? OR locationUid LIKE ?',
          whereArgs: List.filled(3, '%$query%'));
    } else {
      results = await db.query('Transaction');
    }

    return results.map((transaction) {
      return Transaction(
        transactionUid: transaction['transactionUid'],
        userUid: transaction['userUid'],
        itemUid: transaction['itemUid'],
        locationUid: transaction['locationUid'],
      );
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionUid': transactionUid,
      'userUid': userUid,
      'itemUid': itemUid,
      'locationUid': locationUid,
    };
  }
}