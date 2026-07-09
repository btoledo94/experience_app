import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/cart_item.dart';
import '../../domain/entity/order_transaction.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository(FirebaseFirestore.instance);
});

final transactionsProvider = StreamProvider<List<OrderTransaction>>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.watchTransactions();
});

class FinanceRepository {
  final FirebaseFirestore _firestore;

  FinanceRepository(this._firestore);

  Stream<List<OrderTransaction>> watchTransactions() {
    return _firestore
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderTransaction.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> recordApprovedTransaction({
    required String userId,
    required double amount,
    required String currency,
    required String status,
    required String message,
    required List<CartItem> items,
  }) {
    return _firestore.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
      'items': items
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'colorName': item.colorName,
              'size': item.size,
              'price': item.price,
              'quantity': item.quantity,
            },
          )
          .toList(),
    });
  }
}
