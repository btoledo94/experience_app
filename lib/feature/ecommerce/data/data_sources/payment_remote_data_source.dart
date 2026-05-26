import 'package:dio/dio.dart';

class PaymentResult {
  final bool success;
  final String status;
  final String message;
  final String? transactionId;

  const PaymentResult({
    required this.success,
    required this.status,
    required this.message,
    this.transactionId,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      success: (json['success'] as bool?) ?? false,
      status: (json['status'] as String?) ?? 'error',
      message: (json['message'] as String?) ?? 'Unexpected payment response.',
      transactionId: json['transactionId'] as String?,
    );
  }
}

class PaymentRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://enyoi-51248.web.app',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) async {
    try {
      final response = await _dio.post(
        '/processPayment',
        data: {
          'amount': amount,
          'cardNumber': cardNumber,
          'currency': currency,
        },
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return PaymentResult.fromJson(response.data as Map<String, dynamic>);
      }

      return const PaymentResult(
        success: false,
        status: 'error',
        message: 'Unexpected payment response.',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return const PaymentResult(
          success: false,
          status: 'invalid_request',
          message: 'Invalid payment request.',
        );
      }

      return PaymentResult(
        success: false,
        status: 'error',
        message:
            'Payment service error (${e.response?.statusCode ?? 'network'}).',
      );
    }
  }
}
