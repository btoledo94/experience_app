import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_transaction.freezed.dart';

@freezed
class OrderTransaction with _$OrderTransaction {
  const factory OrderTransaction({
    required String id,
    required String userId,
    required double amount,
    required String currency,
    required String status,
    required String message,
    required List<OrderTransactionItem> items,
    String? shippingFullName,
    String? shippingAddress,
    String? shippingCity,
    String? shippingZipCode,
    DateTime? createdAt,
  }) = _OrderTransaction;

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
      shippingFullName: json['shippingFullName'] as String?,
      shippingAddress: json['shippingAddress'] as String?,
      shippingCity: json['shippingCity'] as String?,
      shippingZipCode: json['shippingZipCode'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      items: (json['items'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => OrderTransactionItem.fromJson(Map.from(item)))
          .toList(),
    );
  }
}

@freezed
class OrderTransactionItem with _$OrderTransactionItem {
  const factory OrderTransactionItem({
    required String id,
    required String name,
    required String colorName,
    required String size,
    required double price,
    required int quantity,
  }) = _OrderTransactionItem;

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
