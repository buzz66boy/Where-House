//import 'package:wherehouse/database/Transaction.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class Transaction {
  var transactionUid;
  var userUid;
  var itemUid;
  var locationUid;

  Transaction({
    this.transactionUid,
    this.userUid,
    this.itemUid,
    this.locationUid,
  });

  static Transaction fromJson(Map<String, dynamic> json) => Transaction(
        transactionUid: json['transactionUid'],
        userUid: json['userUid'],
        itemUid: json['itemUid'],
        locationUid: json['locationUid'],
      );
}

class TransactionView extends StatefulWidget {
  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late Future<List<Transaction>> transactions;

  @override
  void initState() {
    super.initState();
    transactions = getTransactionsFromJson();
  }

  Future<List<Transaction>> getTransactionsFromJson() async {
    String filePath = 'lib/database/WhereHouse.json';

    try {
      // Read the JSON file
      String jsonString = await File(filePath).readAsString();
      if (jsonString.isEmpty) return [];

      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .map<Transaction>((json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      print('Error reading JSON file: $e');
      final transaction = Transaction(
          transactionUid: 1, userUid: 1, itemUid: 1, locationUid: 1);
      return [transaction];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Transaction> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final transaction = data[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${transaction.userUid}'),
                        Text('Transaction ID: ${transaction.transactionUid}'),
                        Text('Item ID: ${transaction.itemUid}'),
                        Text('Location ID: ${transaction.locationUid}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
