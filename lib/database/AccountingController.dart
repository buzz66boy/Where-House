class AccountingController {
  AccountingLogView accountingLogView;

  AccountingController(this.accountingLogView);

  List<TransactionView> getTransactions() => accountingLogView.getTransactions();

  TransactionView? getTransactionById(int uniqueId) =>
      accountingLogView.getTransactionById(uniqueId);

  void addTransaction(TransactionView transactionView) =>
      accountingLogView.addTransaction(transactionView);

  void updateTransaction(TransactionView transactionView) =>
      accountingLogView.updateTransaction(transactionView);

  void deleteTransaction(int uniqueId) =>
      accountingLogView.deleteTransaction(uniqueId);
}