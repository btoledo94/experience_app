import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/cart_item.dart';

part 'cart_item_model.freezed.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required String id,
    required String name,
    required String colorName,
    required String size,
    required double price,
    @Default(1) int quantity,
  }) = _CartItemModel;

  /// Crear modelo desde JSON (almacenamiento local / API)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      colorName: json['colorName'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  /// Convertir modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorName': colorName,
      'size': size,
      'price': price,
      'quantity': quantity,
    };
  }

  /// Crear modelo desde la entidad de dominio
  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      name: entity.name,
      colorName: entity.colorName,
      size: entity.size,
      price: entity.price,
      quantity: entity.quantity,
    );
  }

  /// Convertir modelo a entidad de dominio
  CartItem toEntity() {
    return CartItem(
      id: id,
      name: name,
      colorName: colorName,
      size: size,
      price: price,
      quantity: quantity,
    );
  }
}
