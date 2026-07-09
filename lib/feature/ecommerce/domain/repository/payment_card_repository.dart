import '../entity/payment_card.dart';

abstract class PaymentCardRepository {
  Future<List<PaymentCard>> loadSavedCards();
  Future<List<PaymentCard>> loadAvailableCardsToAdd();
  Future<void> addCard(String cardNumber);
  Future<void> removeCard(String cardNumber);
}
