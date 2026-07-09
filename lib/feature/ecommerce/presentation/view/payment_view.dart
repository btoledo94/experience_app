import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entity/payment_card.dart';
import '../state/cart_provider.dart';
import '../state/payment_cards_provider.dart';
import '../state/payment_provider.dart';
import '../widget/checkout_stepper.dart';

class PaymentView extends ConsumerStatefulWidget {
  const PaymentView({super.key});

  @override
  ConsumerState<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView> {
  int _selectedCard = 0;
  bool _useSameBilling = true;
  bool _isProcessing = false;

  Future<void> _onAddNewCard() async {
    final availableCards = await ref
        .read(paymentCardsProvider.notifier)
        .availableCardsToAdd();

    if (!mounted) {
      return;
    }

    if (availableCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All test cards are already added.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add test card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 12),
                ...availableCards.map((card) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(card.holder),
                    subtitle: Text('${card.label} • ${card.masked}'),
                    trailing: const Icon(Icons.add_circle_outline),
                    onTap: () async {
                      await ref
                          .read(paymentCardsProvider.notifier)
                          .addCard(card.number);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeCard(PaymentCard card, int index) async {
    await ref.read(paymentCardsProvider.notifier).removeCard(card.number);

    if (!mounted) {
      return;
    }

    setState(() {
      if (_selectedCard > index) {
        _selectedCard -= 1;
      } else if (_selectedCard == index) {
        _selectedCard = 0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${card.label} removed from checkout cards.')),
    );
  }

  Future<void> _processPayment(List<PaymentCard> savedCards) async {
    final cartState = ref.read(cartProvider);
    final amount = cartState.total;

    if (savedCards.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please add a test card.')));
      return;
    }

    if (_selectedCard >= savedCards.length) {
      if (!mounted) {
        return;
      }
      setState(() => _selectedCard = 0);
    }

    if (amount <= 0) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final result = await ref
          .read(paymentNotifierProvider)
          .processPayment(
            amount: amount,
            cardNumber: savedCards[_selectedCard].number,
          );

      if (!mounted) {
        return;
      }

      if (result.success && result.status == 'approved') {
        ref.read(cartProvider.notifier).clearCart();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
        context.go('/');
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not connect to payment service.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(paymentCardsProvider);
    final savedCards = cardsAsync.valueOrNull ?? const <PaymentCard>[];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 90,
        leading: TextButton(
          onPressed: () => context.go('/cart'),
          child: const Text('Cancel'),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const CheckoutStepper(currentStep: 2),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose a payment method',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You won\'t be charged until you review the order on the next page',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF7E8795),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: cardsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (cards) {
                    if (_selectedCard >= cards.length && cards.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _selectedCard = 0);
                        }
                      });
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFD8DEE8),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: Color(0xFF1A73E8),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Credit Card',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4D5562),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...cards.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final card = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: idx == cards.length - 1 ? 0 : 10,
                                    ),
                                    child: _cardTile(
                                      index: idx,
                                      name: card.label,
                                      number: card.masked,
                                      holder: card.holder,
                                      onRemove: () => _removeCard(card, idx),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: _onAddNewCard,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    'Add new card',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _useSameBilling,
                                      onChanged: (value) {
                                        setState(
                                          () => _useSameBilling = value ?? true,
                                        );
                                      },
                                      activeColor: const Color(0xFF1A73E8),
                                    ),
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: Text(
                                          'My billing address is the same as my shipping address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF727C8A),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFD8DEE8),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.radio_button_off,
                                  color: Color(0xFF9AA3B0),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Apple Pay',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4D5562),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          _processPayment(savedCards);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Process Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTile({
    required int index,
    required String name,
    required String number,
    required String holder,
    required VoidCallback onRemove,
  }) {
    final isSelected = _selectedCard == index;

    return InkWell(
      onTap: () => setState(() => _selectedCard = index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD8DEE8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    holder,
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                if (isSelected)
                  const Icon(Icons.check, color: Color(0xFF1A73E8), size: 20),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Color(0xFF9AA3B0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
