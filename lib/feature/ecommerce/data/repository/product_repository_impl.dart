import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  static const String _productsKey = 'xpiria_products';
  final SharedPreferences _prefs;
  final ProductLocalDataSource _localDataSource;
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(
    this._prefs,
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  Future<void> saveProducts(List<Product> products) async {
    final jsonList = products
        .map((p) => ProductModel.fromEntity(p).toJson())
        .toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_productsKey, jsonString);
  }

  @override
  Future<List<Product>> fetchRemoteProducts() async {
    final models = await _remoteDataSource.fetchProducts();
    return models.map((m) => m.toEntity()).toList();
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
    ..._localDataSource.getDefaultProducts().map((model) => model.toEntity()),
  ];
}
