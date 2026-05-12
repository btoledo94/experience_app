import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String name,
    required String colorName,
    required String size,
    required double price,
    @Default(1) int quantity,
  }) = _CartItem;
}
