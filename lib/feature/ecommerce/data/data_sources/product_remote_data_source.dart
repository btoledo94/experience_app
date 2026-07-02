import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource(this._firestore);

  Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson({'id': doc.id, ...data});
    }).toList();
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final payload = product.toJson()..remove('id');
    final doc = await _firestore.collection('products').add(payload);
    return product.copyWith(id: doc.id);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final payload = product.toJson()..remove('id');
    // Use set+merge so it works for both existing and missing documents.
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(payload, SetOptions(merge: true));
    return product;
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      // Ignore "not-found" so local-only products can still be removed.
      if (e.code != 'not-found') rethrow;
    }
  }
}
