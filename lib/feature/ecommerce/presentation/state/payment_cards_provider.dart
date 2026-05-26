import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/payment_cards_local_data_source.dart';
import '../../data/repository/payment_card_repository_impl.dart';
import '../../domain/entity/payment_card.dart';
import '../../domain/repository/payment_card_repository.dart';

final paymentCardRepositoryProvider = FutureProvider<PaymentCardRepository>((
  ref,
) async {
  return PaymentCardRepositoryImpl(PaymentCardsLocalDataSource());
});

class PaymentCardsNotifier extends AsyncNotifier<List<PaymentCard>> {
  @override
  Future<List<PaymentCard>> build() async {
    final repo = await ref.watch(paymentCardRepositoryProvider.future);
    return repo.loadSavedCards();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(paymentCardRepositoryProvider.future);
      return repo.loadSavedCards();
    });
  }

  Future<List<PaymentCard>> availableCardsToAdd() async {
    final repo = await ref.read(paymentCardRepositoryProvider.future);
    return repo.loadAvailableCardsToAdd();
  }

  Future<void> addCard(String cardNumber) async {
    final repo = await ref.read(paymentCardRepositoryProvider.future);
    await repo.addCard(cardNumber);
    await refresh();
  }

  Future<void> removeCard(String cardNumber) async {
    final repo = await ref.read(paymentCardRepositoryProvider.future);
    await repo.removeCard(cardNumber);
    await refresh();
  }
}

final paymentCardsProvider =
    AsyncNotifierProvider<PaymentCardsNotifier, List<PaymentCard>>(
      PaymentCardsNotifier.new,
    );
