import '../entity/product.dart';

abstract class ProductRepository {
  Future<void> saveProducts(List<Product> products);
  Future<List<Product>> loadProducts();
  Future<List<Product>> fetchRemoteProducts();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<void> clearProducts();
  Future<void> resetProducts();
  Future<void> initializeDefaultProducts();
}
