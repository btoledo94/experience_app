import 'package:xpiria_app/feature/cart/domain/entity/cart_item.dart';
import 'package:xpiria_app/feature/transactions/data/data_sources/transactions_remote_data_source.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';
import 'package:xpiria_app/feature/transactions/domain/repository/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;

  const TransactionsRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<OrderTransaction>> watchTransactions() {
    return remoteDataSource.watchTransactions();
  }

  @override
  Stream<List<OrderTransaction>> watchTransactionsByUser(String userId) {
    return remoteDataSource.watchTransactionsByUser(userId);
  }

  @override
  Future<OrderTransaction> recordApprovedTransaction({
    required String userId,
    required double amount,
    required String currency,
    required String status,
    required String message,
    required List<CartItem> items,
  }) {
    return remoteDataSource.recordApprovedTransaction(
      userId: userId,
      amount: amount,
      currency: currency,
      status: status,
      message: message,
      items: items,
    );
  }
}
