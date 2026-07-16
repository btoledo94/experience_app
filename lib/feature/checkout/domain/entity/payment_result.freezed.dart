// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'payment_result.dart';

mixin _$PaymentResult {
  bool get success;
  String get status;
  String get message;
  String? get transactionId;
}

class _PaymentResult implements PaymentResult {
  const _PaymentResult({
    required this.success,
    required this.status,
    required this.message,
    this.transactionId,
  });

  @override
  final bool success;
  @override
  final String status;
  @override
  final String message;
  @override
  final String? transactionId;

  @override
  String toString() {
    return 'PaymentResult(success: $success, status: $status, message: $message, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _PaymentResult &&
            other.success == success &&
            other.status == status &&
            other.message == message &&
            other.transactionId == transactionId);
  }

  @override
  int get hashCode => Object.hash(success, status, message, transactionId);
}
