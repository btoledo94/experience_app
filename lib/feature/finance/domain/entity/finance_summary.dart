import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_summary.freezed.dart';

@freezed
class FinanceSummary with _$FinanceSummary {
  const factory FinanceSummary({
    required double totalSales,
    required int transactionCount,
    required int soldItemCount,
  }) = _FinanceSummary;
}
