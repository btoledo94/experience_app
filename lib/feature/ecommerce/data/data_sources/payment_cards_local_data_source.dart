import 'package:shared_preferences/shared_preferences.dart';
import '../model/payment_card_model.dart';

class PaymentCardsLocalDataSource {
  static const String _savedCardsKey = 'xpiria_checkout_saved_test_cards';

  static const List<String> _defaultSavedCards = [
    '5555555555554444', // HIGH FUNDS CARD
    '4242424242424242', // MID FUNDS CARD
    '4000000000000002', // DECLINED CARD
    '4000000000000069', // EXPIRED CARD
  ];

  static const List<PaymentCardModel> _catalog = [
    PaymentCardModel(
      number: '5555555555554444',
      holder: 'HIGH FUNDS CARD',
      label: 'Mastercard',
    ),
    PaymentCardModel(
      number: '4242424242424242',
      holder: 'MID FUNDS CARD',
      label: 'Visa',
    ),
    PaymentCardModel(
      number: '4111111111111111',
      holder: 'LOW FUNDS CARD',
      label: 'Visa',
    ),
    PaymentCardModel(
      number: '4000000000000002',
      holder: 'DECLINED CARD',
      label: 'Visa',
    ),
    PaymentCardModel(
      number: '4000000000000069',
      holder: 'EXPIRED CARD',
      label: 'Visa',
    ),
  ];

  Future<List<PaymentCardModel>> loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    var numbers = prefs.getStringList(_savedCardsKey);

    if (numbers == null || numbers.isEmpty) {
      numbers = List<String>.from(_defaultSavedCards);
      await prefs.setStringList(_savedCardsKey, numbers);
    }

    return numbers
        .map(
          (number) => _catalog.firstWhere(
            (card) => card.number == number,
            orElse: () => PaymentCardModel(
              number: number,
              holder: 'SAVED TEST CARD',
              label: 'Card',
            ),
          ),
        )
        .toList();
  }

  Future<List<PaymentCardModel>> loadAvailableCardsToAdd() async {
    final saved = await loadSavedCards();
    final savedNumbers = saved.map((e) => e.number).toSet();
    return _catalog
        .where((card) => !savedNumbers.contains(card.number))
        .toList();
  }

  Future<void> addCard(String cardNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final saved =
        prefs.getStringList(_savedCardsKey) ??
        List<String>.from(_defaultSavedCards);

    if (!saved.contains(cardNumber)) {
      saved.add(cardNumber);
      await prefs.setStringList(_savedCardsKey, saved);
    }
  }

  Future<void> removeCard(String cardNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final saved =
        prefs.getStringList(_savedCardsKey) ??
        List<String>.from(_defaultSavedCards);

    saved.remove(cardNumber);
    await prefs.setStringList(_savedCardsKey, saved);
  }
}
