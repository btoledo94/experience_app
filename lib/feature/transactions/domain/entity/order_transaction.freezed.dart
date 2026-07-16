// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'order_transaction.dart';

mixin _$OrderTransaction {
  String get id;
  String get userId;
  double get amount;
  String get currency;
  String get status;
  String get message;
  List<OrderTransactionItem> get items;
  String? get shippingFullName;
  String? get shippingAddress;
  String? get shippingCity;
  String? get shippingZipCode;
  DateTime? get createdAt;
}

class _OrderTransaction implements OrderTransaction {
  const _OrderTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.message,
    required this.items,
    this.shippingFullName,
    this.shippingAddress,
    this.shippingCity,
    this.shippingZipCode,
    this.createdAt,
  });

  @override
  final String id;
  @override
  final String userId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String status;
  @override
  final String message;
  @override
  final List<OrderTransactionItem> items;
  @override
  final String? shippingFullName;
  @override
  final String? shippingAddress;
  @override
  final String? shippingCity;
  @override
  final String? shippingZipCode;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OrderTransaction(id: $id, userId: $userId, amount: $amount, currency: $currency, status: $status, message: $message, items: $items, shippingFullName: $shippingFullName, shippingAddress: $shippingAddress, shippingCity: $shippingCity, shippingZipCode: $shippingZipCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _OrderTransaction &&
            other.id == id &&
            other.userId == userId &&
            other.amount == amount &&
            other.currency == currency &&
            other.status == status &&
            other.message == message &&
            other.items == items &&
            other.shippingFullName == shippingFullName &&
            other.shippingAddress == shippingAddress &&
            other.shippingCity == shippingCity &&
            other.shippingZipCode == shippingZipCode &&
            other.createdAt == createdAt);
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        amount,
        currency,
        status,
        message,
        items,
        shippingFullName,
        shippingAddress,
        shippingCity,
        shippingZipCode,
        createdAt,
      );
}

mixin _$OrderTransactionItem {
  String get id;
  String get name;
  String get colorName;
  String get size;
  double get price;
  int get quantity;
}

class _OrderTransactionItem implements OrderTransactionItem {
  const _OrderTransactionItem({
    required this.id,
    required this.name,
    required this.colorName,
    required this.size,
    required this.price,
    required this.quantity,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String colorName;
  @override
  final String size;
  @override
  final double price;
  @override
  final int quantity;

  @override
  String toString() {
    return 'OrderTransactionItem(id: $id, name: $name, colorName: $colorName, size: $size, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _OrderTransactionItem &&
            other.id == id &&
            other.name == name &&
            other.colorName == colorName &&
            other.size == size &&
            other.price == price &&
            other.quantity == quantity);
  }

  @override
  int get hashCode => Object.hash(id, name, colorName, size, price, quantity);
}
