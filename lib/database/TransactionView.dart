import 'package:wherehouse/database/AccountingController.dart'; //added accounting controllerclass
import 'package:wherehouse/database/Location.dart';
import 'package:wherehouse/database/Transaction.dart';
import 'package:flutter/material.dart';

class TransactionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the content of your transaction history page
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Center(
        child: Text('Your transaction history content goes here.'),
      ),
    );
  }
}
