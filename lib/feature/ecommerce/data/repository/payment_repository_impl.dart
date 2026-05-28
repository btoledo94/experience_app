import '../../domain/entity/payment_result.dart';
import '../../domain/repository/payment_repository.dart';
import '../data_sources/payment_remote_data_source.dart';

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
