import '../entity/cart_item.dart';

abstract class CartRepository {
  Future<void> saveCartItems(List<CartItem> items);
  Future<List<CartItem>> loadCartItems();
  Future<void> clearCart();
}
