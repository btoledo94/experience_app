import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

abstract class TransactionsRepository {
  Stream<List<OrderTransaction>> watchTransactions();
  Stream<List<OrderTransaction>> watchTransactionsByUser(String userId);
  Future<OrderTransaction?> getTransactionById(String transactionId);

  Future<OrderTransaction> recordApprovedTransaction({
    required String userId,
    required double amount,
    required String currency,
    required String status,
    required String message,
    required List<CartItem> items,
  });
}
