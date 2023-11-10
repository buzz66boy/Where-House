import '../lib/database/Transaction.dart'; // Corrected path

Future<void> testGetTransaction(int uid) async {
  Transaction transaction = await Transaction.getTransaction(uid);
  if (transaction.transactionUid != uid) {
    throw Exception('Test failed: Expected UID $uid, got ${transaction.transactionUid}');
  }
  // Additional checks can be added here
}

Future<void> testUpdateTransaction(Map<String, int> data) async {
  Transaction transaction = await Transaction.getTransaction(data['transactionUid']!);

  // Modify the transaction
  transaction.userUid = data['userUid']!;
  transaction.itemUid = data['itemUid']!;
  transaction.locationUid = data['locationUid']!;

  bool updateResult = await transaction.updateTransaction();
  if (!updateResult) {
    throw Exception('Test failed: Update returned false');
  }

  // Fetch again to verify update
  Transaction updatedTransaction = await Transaction.getTransaction(data['transactionUid']!);
  if (updatedTransaction.userUid != data['userUid'] ||
      updatedTransaction.itemUid != data['itemUid'] ||
      updatedTransaction.locationUid != data['locationUid']) {
    throw Exception('Test failed: Update verification failed');
  }
}

void main() async {
  try {
    await testGetTransaction(1); // Replace with valid transaction UID
    // Call other test functions as needed
    print('All tests passed!');
  } catch (e) {
    print('Test failed: $e');
  }
}
