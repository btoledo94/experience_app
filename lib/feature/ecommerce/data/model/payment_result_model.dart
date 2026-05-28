import '../../domain/entity/payment_result.dart';

class PaymentResultModel {
  final bool success;
  final String status;
  final String message;
  final String? transactionId;

  const PaymentResultModel({
    required this.success,
    required this.status,
    required this.message,
    this.transactionId,
  });

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
