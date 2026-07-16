import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xpiria_app/feature/checkout/data/data_sources/payment_remote_data_source.dart';
import 'package:xpiria_app/feature/checkout/data/repository/payment_repository_impl.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_result.dart';
import 'package:xpiria_app/feature/checkout/domain/repository/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(PaymentRemoteDataSource());
});

final paymentNotifierProvider = Provider<PaymentNotifier>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository);
});

class PaymentNotifier {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository);

  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) {
    return _repository.processPayment(
      amount: amount,
      cardNumber: cardNumber,
      currency: currency,
    );
  }
}
