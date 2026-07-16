import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';
import 'package:xpiria_app/feature/cart/domain/repository/cart_repository.dart';
import '../model/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  static const String _cartKey = 'xpiria_cart_items';

  final SharedPreferences _prefs;

  CartRepositoryImpl(this._prefs);

  /// Guardar lista de items en almacenamiento local
  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    try {
      final jsonList = items
          .map((item) => CartItemModel.fromEntity(item).toJson())
          .toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_cartKey, jsonString);
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

  /// Cargar lista de items del almacenamiento local
  @override
  Future<List<CartItem>> loadCartItems() async {
    try {
      final jsonString = _prefs.getString(_cartKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (item) =>
                CartItemModel.fromJson(item as Map<String, dynamic>).toEntity(),
          )
          .toList();
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  /// Limpiar el carrito del almacenamiento
  @override
  Future<void> clearCart() async {
    try {
      await _prefs.remove(_cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
