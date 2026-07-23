import '../entity/product.dart';
import 'dart:typed_data';

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
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
    required String fileName,
  });
}
