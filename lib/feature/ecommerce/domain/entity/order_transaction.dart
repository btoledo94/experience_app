import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTransaction {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String status;
  final String message;
  final DateTime? createdAt;
  final List<OrderTransactionItem> items;

  const OrderTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.message,
    required this.items,
    this.createdAt,
  });

  factory OrderTransaction.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return OrderTransaction(
      id: id,
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num? ?? 0).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      status: json['status'] as String? ?? 'unknown',
      message: json['message'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      items: (json['items'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => OrderTransactionItem.fromJson(Map.from(item)))
          .toList(),
    );
  }
}

class OrderTransactionItem {
  final String id;
  final String name;
  final String colorName;
  final String size;
  final double price;
  final int quantity;

  const OrderTransactionItem({
    required this.id,
    required this.name,
    required this.colorName,
    required this.size,
    required this.price,
    required this.quantity,
  });

  factory OrderTransactionItem.fromJson(Map<String, dynamic> json) {
    return OrderTransactionItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      colorName: json['colorName'] as String? ?? '',
      size: json['size'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      quantity: (json['quantity'] as num? ?? 0).toInt(),
    );
  }
}
