// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'payment_card_model.dart';

mixin _$PaymentCardModel {
  String get number;
  String get holder;
  String get label;
}

class _PaymentCardModel extends PaymentCardModel {
  const _PaymentCardModel({
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
    return 'PaymentCardModel(number: $number, holder: $holder, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _PaymentCardModel &&
            other.number == number &&
            other.holder == holder &&
            other.label == label);
  }

  @override
  int get hashCode => Object.hash(number, holder, label);
}
