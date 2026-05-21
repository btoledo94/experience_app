import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  static const String _productsKey = 'xpiria_products';
  final SharedPreferences _prefs;

  ProductRepositoryImpl(this._prefs);

  @override
  Future<void> saveProducts(List<Product> products) async {
    final jsonList = products
        .map((p) => ProductModel.fromEntity(p).toJson())
        .toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_productsKey, jsonString);
  }

  @override
  Future<List<Product>> loadProducts() async {
    final jsonString = _prefs.getString(_productsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map(
          (item) =>
              ProductModel.fromJson(item as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<void> clearProducts() async {
    await _prefs.remove(_productsKey);
  }

  @override
  Future<void> resetProducts() async {
    await clearProducts();
    await saveProducts(_defaultProducts);
  }

  /// Inicializa productos por defecto si no hay ninguno guardado
  @override
  Future<void> initializeDefaultProducts() async {
    final existing = await loadProducts();
    if (existing.isEmpty) {
      await saveProducts(_defaultProducts);
    }
  }

  List<Product> get _defaultProducts => [
    Product(
      id: '1',
      name: 'Amazing T-Shirt',
      description:
          'The perfect t-shirt for when you want to feel comfortable but still stylish.',
      price: 12.0,
      imageUrl: '',
      colors: ['Black', 'Grey', 'Light Grey', 'White'],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
    ),
    Product(
      id: '2',
      name: 'Fabulous Pants',
      description: 'Stylish pants for every occasion.',
      price: 15.0,
      imageUrl: '',
      colors: ['Blue', 'Black'],
      sizes: ['42', '44', '46'],
    ),
    Product(
      id: '3',
      name: 'Jeans Pants',
      description: 'Stylish Jeans for every occasion.',
      price: 75.0,
      imageUrl: '',
      colors: ['Blue', 'White', 'Grey'],
      sizes: ['36', '42', '44', '46'],
    ),
    Product(
      id: '4',
      name: 'T-Shirt',
      description: 'Stylish T-Shirt for every occasion.',
      price: 75.0,
      imageUrl: '',
      colors: ['Blue', 'White', 'Grey'],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: '5',
      name: 'T-Shirt V',
      description: 'Stylish T-Shirt for every occasion.',
      price: 75.0,
      imageUrl: '',
      colors: ['Blue', 'White', 'Grey'],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: '6',
      name: 'T-Shirt VI',
      description: 'Stylish T-Shirt for every occasion.',
      price: 75.0,
      imageUrl: '',
      colors: ['Blue', 'White', 'Grey'],
      sizes: ['S', 'M', 'L', 'XL'],
    ),
  ];
}
