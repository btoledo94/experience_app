import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity/cart_item.dart';
import '../../domain/repository/cart_repository.dart';
import 'cart_state.dart';
import '../../data/repository/cart_repository_impl.dart';

class CartNotifier extends StateNotifier<CartState> {
  late CartRepository _repository;

  CartNotifier() : super(const CartState());

  /// Inicializar el repositorio con SharedPreferences
  Future<void> initialize(SharedPreferences prefs) async {
    _repository = CartRepositoryImpl(prefs);
    await loadCart();
  }

  /// Cargar items guardados del almacenamiento
  Future<void> loadCart() async {
    try {
      final items = await _repository.loadCartItems();
      state = CartState(items: items);
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  /// Guardar el estado actual en almacenamiento
  Future<void> _saveCart() async {
    try {
      await _repository.saveCartItems(state.items);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

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

    // Guardar en almacenamiento
    _saveCart();
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );

    // Guardar en almacenamiento
    _saveCart();
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

    // Guardar en almacenamiento
    _saveCart();
  }

  void clearCart() {
    state = const CartState();

    // Limpiar almacenamiento
    _repository.clearCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
