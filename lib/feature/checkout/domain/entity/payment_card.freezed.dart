// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'payment_card.dart';

mixin _$PaymentCard {
  String get number;
  String get holder;
  String get label;
}

class _PaymentCard extends PaymentCard {
  const _PaymentCard({
    required this.number,
    required this.holder,
    required this.label,
  }) : super._();

  @override
  final String number;
  @override
  final String holder;
  @override
  final String label;

  @override
  String toString() {
    return 'PaymentCard(number: $number, holder: $holder, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _PaymentCard &&
            other.number == number &&
            other.holder == holder &&
            other.label == label);
  }

  @override
  int get hashCode => Object.hash(number, holder, label);
}
