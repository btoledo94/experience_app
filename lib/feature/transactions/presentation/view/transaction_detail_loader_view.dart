import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/transactions/presentation/state/transactions_provider.dart';
import 'package:xpiria_app/feature/transactions/presentation/view/transaction_detail_view.dart';

class TransactionDetailLoaderView extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailLoaderView({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(transactionId));

    return transactionAsync.when(
      data: (transaction) => transaction == null
          ? const TransactionDetailView.empty()
          : TransactionDetailView(transaction: transaction, backToHome: true),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de transaccion'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No se pudo cargar la transaccion.'),
          ),
        ),
      ),
    );
  }
}
