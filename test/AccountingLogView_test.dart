import 'AccountingLogView.dart';

void testGetTransactions() {
  // Create an AccountingLogView object.
  AccountingLogView accountingLogView = AccountingLogView(accountingLog);

  // Add a few transactions to the accounting log.
  Transaction transaction1 = Transaction(amount: 100, date: DateTime.now());
  Transaction transaction2 = Transaction(amount: 200, date: DateTime.now());
  accountingLogView.addTransaction(transaction1);
  accountingLogView.addTransaction(transaction2);

  // Get a list of all transactions.
  List<TransactionView> transactions = accountingLogView.getTransactions();

  // Assert that the list contains the two transactions that we added.
  expect(transactions.length, equals(2));
  
