// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'payment_result_model.dart';

mixin _$PaymentResultModel {
  bool get success;
  String get status;
  String get message;
  String? get transactionId;
}

class _PaymentResultModel extends PaymentResultModel {
  const _PaymentResultModel({
    required this.success,
    required this.status,
    required this.message,
    this.transactionId,
  }) : super._();

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
    return 'PaymentResultModel(success: $success, status: $status, message: $message, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _PaymentResultModel &&
            other.success == success &&
            other.status == status &&
            other.message == message &&
            other.transactionId == transactionId);
  }

  @override
  int get hashCode => Object.hash(success, status, message, transactionId);
}
