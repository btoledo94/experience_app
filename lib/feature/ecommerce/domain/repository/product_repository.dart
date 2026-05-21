import '../entity/product.dart';

abstract class ProductRepository {
  Future<void> saveProducts(List<Product> products);
  Future<List<Product>> loadProducts();
  Future<void> clearProducts();
  Future<void> resetProducts();
  Future<void> initializeDefaultProducts();
}
