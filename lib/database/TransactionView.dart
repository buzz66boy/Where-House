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

// Transaction is also a class in sqflite_api.dart so I am adding it here to remove errors
// class Transaction {
//   late int transactionUid;
//   late int userUid;
//   late int itemUid;
//   late int locationUid;

//   Transaction(
//       {required transactionUid,
//       required userUid,
//       required itemUid,
//       required locationUid});
// }

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
    // Specify the path to your JSON file
    String filePath = 'lib/database/WhereHouse.json';

    try {
      // Read the JSON file
      String jsonString = await File(filePath).readAsString();
      if (jsonString.isEmpty) return [];

      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .map<Transaction>((json) => Transaction.fromJson(json))
          .toList();

      // // Parse JSON string into a List of Map<String, dynamic>
      // Map<String, dynamic> jsonData = jsonDecode(jsonString);
      // var transactionList = <Transaction>[];
      // // Loop through each map entry in jsonData
      // jsonData.forEach((key, value) {
      //   // Access map key and value
      //   final transactionUid = value['transactionUid'];
      //   final userUid = value['userUid'];
      //   final itemUid = value['itemUid'];
      //   final locationUid = value['locationUid'];
      //   // ... access other key-value pairs

      //   // Create a new Transaction object
      //   final transaction = Transaction(
      //       transactionUid: transactionUid,
      //       userUid: userUid,
      //       itemUid: itemUid,
      //       locationUid: locationUid);

      //   // Add the transaction object to the list
      //   transactionList.add(transaction);
      // });

      //return transactionList;
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
