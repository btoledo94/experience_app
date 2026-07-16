import 'package:dio/dio.dart';
import '../model/payment_result_model.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_result.dart';

class PaymentRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://processpayment-sfdkfoab2q-uc.a.run.app',
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
        return PaymentResultModel.fromJson(
          response.data as Map<String, dynamic>,
        ).toEntity();
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
