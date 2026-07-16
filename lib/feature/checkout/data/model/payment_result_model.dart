import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_result.dart';

part 'payment_result_model.freezed.dart';

@freezed
abstract class PaymentResultModel with _$PaymentResultModel {
  const PaymentResultModel._();

  const factory PaymentResultModel({
    required bool success,
    required String status,
    required String message,
    String? transactionId,
  }) = _PaymentResultModel;

  factory PaymentResultModel.fromJson(Map<String, dynamic> json) {
    return PaymentResultModel(
      success: (json['success'] as bool?) ?? false,
      status: (json['status'] as String?) ?? 'error',
      message: (json['message'] as String?) ?? 'Unexpected payment response.',
      transactionId: json['transactionId'] as String?,
    );
  }

  PaymentResult toEntity() {
    return PaymentResult(
      success: success,
      status: status,
      message: message,
      transactionId: transactionId,
    );
  }
}
