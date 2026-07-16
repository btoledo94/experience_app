import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xpiria_app/feature/finance/data/data_sources/finance_report_data_source.dart';
import 'package:xpiria_app/feature/finance/data/repository/finance_repository_impl.dart';
import 'package:xpiria_app/feature/finance/domain/entity/finance_summary.dart';
import 'package:xpiria_app/feature/finance/domain/repository/finance_repository.dart';
import 'package:xpiria_app/feature/transactions/presentation/state/transactions_provider.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryImpl(FinanceReportDataSource());
});

final financeSummaryProvider = StreamProvider<FinanceSummary>((ref) {
  final financeRepository = ref.watch(financeRepositoryProvider);
  final transactionsStream = ref.watch(transactionsRepositoryProvider);

  return transactionsStream.watchTransactions().map(
    financeRepository.buildSummary,
  );
});
