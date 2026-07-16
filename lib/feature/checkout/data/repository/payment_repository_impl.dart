import 'package:xpiria_app/feature/checkout/data/data_sources/payment_remote_data_source.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_result.dart';
import 'package:xpiria_app/feature/checkout/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String cardNumber,
    String currency = 'USD',
  }) {
    return _remoteDataSource.processPayment(
      amount: amount,
      cardNumber: cardNumber,
      currency: currency,
    );
  }
}
