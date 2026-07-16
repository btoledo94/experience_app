import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_result.freezed.dart';

@freezed
class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    required bool success,
    required String status,
    required String message,
    String? transactionId,
  }) = _PaymentResult;
}
