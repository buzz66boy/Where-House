import 'AccountingController.dart';

void testGetTransactions() {
  // Create an AccountingController object.
  AccountingController accountingController = AccountingController(accountingLogView);

  // Add a few transactions to the accounting log.
  Transaction transaction1 = Transaction(amount: 100, date: DateTime.now());
  Transaction transaction2 = Transaction(amount: 200, date: DateTime.now());
  accountingController.addTransaction(transaction1);
  accountingController.addTransaction(transaction2);

  // Get a list of all transactions.
  List<TransactionView> transactions = accountingController.getTransactions();

  // Assert that the list contains the two transactions that we added.
  expect(transactions.length, equals(2));
  expect(transactions[0].getUniqueId(), equals(transaction1.uid));
  expect(transactions[1].getUniqueId(), equals(transaction2.uid));
}

void testGetTransactionById() {
  // Create an AccountingController object.
  AccountingController accountingController = AccountingController(accountingLogView);

  // Add a few transactions to the accounting log.
  Transaction transaction1 = Transaction(amount: 100, date: DateTime.now());
  Transaction transaction2 = Transaction(amount: 200, date: DateTime.now());
  accountingController.addTransaction(transaction1);
  accountingController.addTransaction(transaction2);

  // Get a transaction by its unique ID.
  TransactionView transactionView = accountingController.getTransactionById(transaction1.uid);

  // Assert that the transaction view is not null.
  expect(transactionView, isNotNull);

  // Assert that the transaction view has the same unique ID as the transaction that we added.
  expect(transactionView.getUniqueId(), equals(transaction1.uid));
}

void testAddTransaction() {
  // Create an AccountingController object.
  AccountingController accountingController = AccountingController(accountingLogView);

  // Create a new transaction.
  Transaction transaction = Transaction(amount: 100, date: DateTime.now());

  // Add the transaction to the accounting log.
  accountingController.addTransaction(transaction);

  // Assert that the transaction was added to the accounting log.
  expect(accountingController.getTransactions().length, equals(1));
  expect(accountingController.getTransactions()[0].getUniqueId(), equals(transaction.uid));
}

void testUpdateTransaction() {
  // Create an AccountingController object.
  AccountingController accountingController = AccountingController(accountingLogView);

  // Add a transaction to the accounting log.
  Transaction transaction = Transaction(amount: 100, date: DateTime.now());
  accountingController.addTransaction(transaction);

  // Update the transaction.
  transaction.amount = 200;
  accountingController.updateTransaction(transaction);

  // Assert that the transaction was updated in the accounting log.
  expect(accountingController.getTransactionById(transaction.uid).getAmount(), equals(200));
}

void testDeleteTransaction() {
  // Create an AccountingController object.
  AccountingController accountingController = AccountingController(accountingLogView);

  // Add a transaction to the accounting log.
  Transaction transaction = Transaction(amount: 100, date: DateTime.now());
  accountingController.addTransaction(transaction);

  // Delete the transaction.
  accountingController.deleteTransaction(transaction.uid);

  // Assert that the transaction was deleted from the accounting log.
  expect(accountingController.getTransactions().length, equals(0));
}
