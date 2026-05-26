class PaymentCard {
  final String number;
  final String holder;
  final String label;

  const PaymentCard({
    required this.number,
    required this.holder,
    required this.label,
  });

  String get masked {
    final last4 = number.length >= 4
        ? number.substring(number.length - 4)
        : number;
    return 'xxxx xxxx xxxx $last4';
  }
}
