import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_card.freezed.dart';

@freezed
class PaymentCard with _$PaymentCard {
  const PaymentCard._();

  const factory PaymentCard({
    required String number,
    required String holder,
    required String label,
  }) = _PaymentCard;

  String get masked {
    final last4 = number.length >= 4
        ? number.substring(number.length - 4)
        : number;
    return 'xxxx xxxx xxxx $last4';
  }
}
