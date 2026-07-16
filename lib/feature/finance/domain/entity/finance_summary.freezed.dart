// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'finance_summary.dart';

mixin _$FinanceSummary {
  double get totalSales;
  int get transactionCount;
  int get soldItemCount;
}

class _FinanceSummary implements FinanceSummary {
  const _FinanceSummary({
    required this.totalSales,
    required this.transactionCount,
    required this.soldItemCount,
  });

  @override
  final double totalSales;
  @override
  final int transactionCount;
  @override
  final int soldItemCount;

  @override
  String toString() {
    return 'FinanceSummary(totalSales: $totalSales, transactionCount: $transactionCount, soldItemCount: $soldItemCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _FinanceSummary &&
            other.totalSales == totalSales &&
            other.transactionCount == transactionCount &&
            other.soldItemCount == soldItemCount);
  }

  @override
  int get hashCode => Object.hash(totalSales, transactionCount, soldItemCount);
}
