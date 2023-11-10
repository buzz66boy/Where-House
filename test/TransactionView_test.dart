import 'TransactionView.dart';

void testGetUniqueId() {
  // Create a TransactionView object.
  TransactionView transactionView = TransactionView(transaction);

  // Get the unique ID of the transaction.
  int uniqueId = transactionView.getUniqueId();

  // Assert that the unique ID is not null.
  expect(uniqueId, isNotNull);
}

void testGetAmount() {
  // Create a TransactionView object.
  TransactionView transactionView = TransactionView(transaction);

  // Get the amount of the transaction.
  double amount = transactionView.getAmount();

  // Assert that the amount is equal to the amount of the transaction that we created.
  expect(amount, equals(transaction.amount));
}

void testGetDate() {
  // Create a TransactionView object.
  TransactionView transactionView = TransactionView(transaction);

  // Get the date of the transaction.
  DateTime date = transactionView.getDate();

  // Assert that the date is equal to the date of the transaction that we created.
  expect(date, equals(transaction.date));
}

void testGetDescription() {
  // Create a TransactionView object.
  TransactionView transactionView = TransactionView(transaction);

  // Get the description of the transaction.
  String description = transactionView.getDescription();

  // Assert that the description is equal to the description of the transaction that we created.
  expect(description, equals(transaction.description));
}
