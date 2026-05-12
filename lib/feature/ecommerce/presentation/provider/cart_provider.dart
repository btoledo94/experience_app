import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/cart_item.dart';
import '../provider/cart_state.dart';

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(CartItem item) {
    final existingItemIndex = state.items.indexWhere(
      (i) =>
          i.name == item.name &&
          i.size == item.size &&
          i.colorName == item.colorName,
    );

    if (existingItemIndex >= 0) {
      // Si el producto ya existe, aumentar cantidad
      final updatedItems = [...state.items];
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(
            quantity: updatedItems[existingItemIndex].quantity + item.quantity,
          );
      state = state.copyWith(items: updatedItems);
    } else {
      // Si es nuevo, agregarlo
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }

    final updatedItems = state.items.map((item) {
      return item.id == id ? item.copyWith(quantity: quantity) : item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
