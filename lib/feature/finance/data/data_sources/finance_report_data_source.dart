import 'package:xpiria_app/feature/finance/domain/entity/finance_summary.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

class FinanceReportDataSource {
  FinanceSummary buildSummary(List<OrderTransaction> transactions) {
    final totalSales = transactions.fold<double>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );

    final soldItemCount = transactions.fold<int>(
      0,
      (sum, transaction) =>
          sum +
          transaction.items.fold<int>(
            0,
            (itemSum, item) => itemSum + item.quantity,
          ),
    );

    return FinanceSummary(
      totalSales: totalSales,
      transactionCount: transactions.length,
      soldItemCount: soldItemCount,
    );
  }
}
