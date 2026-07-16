import 'package:xpiria_app/feature/checkout/data/data_sources/payment_cards_local_data_source.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_card.dart';
import 'package:xpiria_app/feature/checkout/domain/repository/payment_card_repository.dart';

class PaymentCardRepositoryImpl implements PaymentCardRepository {
  final PaymentCardsLocalDataSource _localDataSource;

  PaymentCardRepositoryImpl(this._localDataSource);

  @override
  Future<List<PaymentCard>> loadSavedCards() async {
    final models = await _localDataSource.loadSavedCards();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<PaymentCard>> loadAvailableCardsToAdd() async {
    final models = await _localDataSource.loadAvailableCardsToAdd();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addCard(String cardNumber) {
    return _localDataSource.addCard(cardNumber);
  }

  @override
  Future<void> removeCard(String cardNumber) {
    return _localDataSource.removeCard(cardNumber);
  }
}
