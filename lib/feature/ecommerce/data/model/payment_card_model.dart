import '../../domain/entity/payment_card.dart';

class PaymentCardModel {
  final String number;
  final String holder;
  final String label;

  const PaymentCardModel({
    required this.number,
    required this.holder,
    required this.label,
  });

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
