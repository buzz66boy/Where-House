// Imports Code
import 'Transaction.dart';
import 'AccountLog.dart';

// Imports Package
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class AccountingLogView {
  AccountingLog accountingLog;

  AccountingLogView(this.accountingLog);

  List<TransactionView> getTransactions() {
    return accountingLog.getTransactions().map(TransactionView.new).toList();
  }

  TransactionView? getTransactionById(int uniqueId) {
    Transaction transaction = accountingLog.getTransaction(uniqueId);
    return transaction != null ? TransactionView(transaction) : null;
  }

  void addTransaction(TransactionView transactionView) {
    accountingLog.log(transactionView.toTransaction());
  }

  void updateTransaction(TransactionView transactionView) {
    Transaction newTransaction = transactionView.toTransaction();
    Transaction oldTransaction = accountingLog.getTransaction(newTransaction.uid);
    if (oldTransaction != null) {
      accountingLog.overwriteTransaction(newTransaction, oldTransaction);
    }
  }

  void deleteTransaction(int uniqueId) {
    accountingLog.deleteTransaction(uniqueId);
  }
}