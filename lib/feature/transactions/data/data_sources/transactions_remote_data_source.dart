import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

class TransactionsRemoteDataSource {
  final FirebaseFirestore firestore;

  const TransactionsRemoteDataSource(this.firestore);

  Stream<List<OrderTransaction>> watchTransactions() {
    return firestore
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderTransaction.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<OrderTransaction>> watchTransactionsByUser(String userId) {
    return firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final transactions = snapshot.docs
              .map((doc) => OrderTransaction.fromFirestore(doc.id, doc.data()))
              .toList();

          transactions.sort((a, b) {
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

          return transactions;
        });
  }

  Future<OrderTransaction> recordApprovedTransaction({
    required String userId,
    required double amount,
    required String currency,
    required String status,
    required String message,
    required List<CartItem> items,
  }) async {
    final createdAt = DateTime.now();
    final shipping = await _loadShippingProfile(userId);
    final payloadItems = items
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
        .toList();

    final doc = await firestore.collection('transactions').add({
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'message': message,
      'shippingFullName': shipping['fullName'],
      'shippingAddress': shipping['address'],
      'shippingCity': shipping['city'],
      'shippingZipCode': shipping['zipCode'],
      'createdAt': FieldValue.serverTimestamp(),
      'items': payloadItems,
    });

    return OrderTransaction(
      id: doc.id,
      userId: userId,
      amount: amount,
      currency: currency,
      status: status,
      message: message,
      shippingFullName: shipping['fullName'],
      shippingAddress: shipping['address'],
      shippingCity: shipping['city'],
      shippingZipCode: shipping['zipCode'],
      createdAt: createdAt,
      items: payloadItems
          .map((item) => OrderTransactionItem.fromJson(item))
          .toList(),
    );
  }

  Future<Map<String, String?>> _loadShippingProfile(String userId) async {
    final doc = await firestore.collection('shipping_profiles').doc(userId).get();
    final data = doc.data() ?? {};

    return {
      'fullName': data['fullName'] as String?,
      'address': data['address'] as String?,
      'city': data['city'] as String?,
      'zipCode': data['zipCode'] as String?,
    };
  }
}
