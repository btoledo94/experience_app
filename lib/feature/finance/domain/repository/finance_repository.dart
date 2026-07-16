import 'package:xpiria_app/feature/finance/domain/entity/finance_summary.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

abstract class FinanceRepository {
  FinanceSummary buildSummary(List<OrderTransaction> transactions);
}
