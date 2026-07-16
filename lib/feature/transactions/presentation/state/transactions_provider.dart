import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:xpiria_app/feature/transactions/data/data_sources/transactions_remote_data_source.dart';
import 'package:xpiria_app/feature/transactions/data/repository/transactions_repository_impl.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';
import 'package:xpiria_app/feature/transactions/domain/repository/transactions_repository.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(
    TransactionsRemoteDataSource(FirebaseFirestore.instance),
  );
});

final transactionsProvider = StreamProvider<List<OrderTransaction>>((ref) {
  final repository = ref.watch(transactionsRepositoryProvider);
  return repository.watchTransactions();
});

final myTransactionsProvider = StreamProvider<List<OrderTransaction>>((ref) {
  final repository = ref.watch(transactionsRepositoryProvider);
  final user = ref.watch(authStateProvider).valueOrNull;

  if (user == null) return Stream.value(const []);

  return repository.watchTransactionsByUser(user.uid);
});
