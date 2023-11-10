
import 'package:test/test.dart';
import '../lib/database/Transaction.dart'; // Corrected path

void main() {
  group('Transaction Tests', () {
    // Test cases for getTransaction
    List<int> transactionUidsToGet = [1, 2, 3]; // Replace with valid transaction UIDs
    for (var uid in transactionUidsToGet) {
      test('Get Transaction with UID $uid', () async {
        Transaction transaction = await Transaction.getTransaction(uid);
        expect(transaction.transactionUid, uid);
        // Additional checks can be added here
      });
    }

    // Test cases for updateTransaction
    List<Map<String, int>> updateData = [
      {'transactionUid': 1, 'userUid': 60, 'itemUid': 600, 'locationUid': 6000},
      {'transactionUid': 2, 'userUid': 70, 'itemUid': 700, 'locationUid': 7000},
      {'transactionUid': 3, 'userUid': 80, 'itemUid': 800, 'locationUid': 8000}
    ];

    for (var data in updateData) {
      test('Update Transaction with UID ${data['transactionUid']}', () async {
        Transaction transaction = await Transaction.getTransaction(data['transactionUid']!);

        // Modify the transaction
        transaction.userUid = data['userUid']!;
        transaction.itemUid = data['itemUid']!;
        transaction.locationUid = data['locationUid']!;

        bool updateResult = await transaction.updateTransaction();
        expect(updateResult, true);

        // Fetch again to verify update
        Transaction updatedTransaction = await Transaction.getTransaction(data['transactionUid']!);
        expect(updatedTransaction.userUid, data['userUid']);
        expect(updatedTransaction.itemUid, data['itemUid']);
        expect(updatedTransaction.locationUid, data['locationUid']);
      });
    }

  });
}
