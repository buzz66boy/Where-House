class TransactionView {
  Transaction transaction;

  TransactionView(this.transaction);

  int getUniqueId() => transaction.uid;

  double getAmount() => transaction.amount;

  DateTime getDate() => transaction.date;

  String getDescription() => transaction.description;

  Transaction toTransaction() {
    return Transaction(
      uid: getUniqueId(),
      amount: getAmount(),
      date: getDate(),
      description: getDescription(),
    );
  }
}