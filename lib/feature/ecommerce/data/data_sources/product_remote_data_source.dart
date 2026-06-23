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
}
