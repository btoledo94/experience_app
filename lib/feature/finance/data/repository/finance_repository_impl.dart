import 'package:xpiria_app/feature/finance/data/data_sources/finance_report_data_source.dart';
import 'package:xpiria_app/feature/finance/domain/entity/finance_summary.dart';
import 'package:xpiria_app/feature/finance/domain/repository/finance_repository.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceReportDataSource dataSource;

  const FinanceRepositoryImpl(this.dataSource);

  @override
  FinanceSummary buildSummary(List<OrderTransaction> transactions) {
    return dataSource.buildSummary(transactions);
  }
}
