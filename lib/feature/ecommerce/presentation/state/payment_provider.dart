import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/payment_remote_data_source.dart';
import '../../data/repository/payment_repository_impl.dart';
import '../../domain/entity/payment_result.dart';
import '../../domain/repository/payment_repository.dart';

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
