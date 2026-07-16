import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const CartState._();

  const factory CartState({@Default([]) List<CartItem> items}) = _CartState;

  double get total =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
