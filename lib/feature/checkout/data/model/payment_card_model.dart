import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xpiria_app/feature/checkout/domain/entity/payment_card.dart';

part 'payment_card_model.freezed.dart';

@freezed
abstract class PaymentCardModel with _$PaymentCardModel {
  const PaymentCardModel._();

  const factory PaymentCardModel({
    required String number,
    required String holder,
    required String label,
  }) = _PaymentCardModel;

  factory PaymentCardModel.fromEntity(PaymentCard entity) {
    return PaymentCardModel(
      number: entity.number,
      holder: entity.holder,
      label: entity.label,
    );
  }

  PaymentCard toEntity() {
    return PaymentCard(number: number, holder: holder, label: label);
  }
}
