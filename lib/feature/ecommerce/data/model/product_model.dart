import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/product.dart';

part 'product_model.freezed.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    @Default([]) List<String> colors,
    @Default([]) List<String> sizes,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'colors': colors,
      'sizes': sizes,
    };
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      colors: entity.colors,
      sizes: entity.sizes,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      colors: colors,
      sizes: sizes,
    );
  }
}
