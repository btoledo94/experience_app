import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpiria_app/feature/products/data/data_sources/product_local_data_source.dart';
import 'package:xpiria_app/feature/products/data/data_sources/product_remote_data_source.dart';
import 'package:xpiria_app/feature/products/data/data_sources/product_storage_data_source.dart';
import 'package:xpiria_app/feature/products/domain/entity/product.dart';
import 'package:xpiria_app/feature/products/domain/repository/product_repository.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  static const String _productsKey = 'xpiria_products';
  final SharedPreferences _prefs;
  final ProductLocalDataSource _localDataSource;
  final ProductRemoteDataSource _remoteDataSource;
  final ProductStorageDataSource _storageDataSource;

  ProductRepositoryImpl(
    this._prefs,
    this._localDataSource,
    this._remoteDataSource,
    this._storageDataSource,
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
  Future<Product> createProduct(Product product) async {
    final createdModel = await _remoteDataSource.createProduct(
      ProductModel.fromEntity(product),
    );
    final created = createdModel.toEntity();

    final local = await loadProducts();
    await saveProducts([...local, created]);
    return created;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final updatedModel = await _remoteDataSource.updateProduct(
      ProductModel.fromEntity(product),
    );
    final updated = updatedModel.toEntity();

    final local = await loadProducts();
    final merged = local.map((p) => p.id == updated.id ? updated : p).toList();
    await saveProducts(merged);
    return updated;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _remoteDataSource.deleteProduct(productId);
    final local = await loadProducts();
    final filtered = local.where((p) => p.id != productId).toList();
    await saveProducts(filtered);
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

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
    required String fileName,
  }) {
    return _storageDataSource.uploadProductImage(
      productId: productId,
      bytes: bytes,
      fileName: fileName,
    );
  }

  List<Product> get _defaultProducts => [
    ..._localDataSource.getDefaultProducts().map((model) => model.toEntity()),
  ];
}
