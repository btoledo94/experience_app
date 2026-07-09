import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/finance_provider.dart';
import '../state/product_provider.dart';

class FinanceDashboardView extends ConsumerWidget {
  const FinanceDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Finanzas'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(productsProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              transactionsAsync.when(
                loading: () => const _Panel(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => _Panel(child: Text('Error: $e')),
                data: (transactions) {
                  final total = transactions.fold<double>(
                    0,
                    (sum, item) => sum + item.amount,
                  );
                  final itemCount = transactions.fold<int>(
                    0,
                    (sum, tx) =>
                        sum +
                        tx.items.fold<int>(
                          0,
                          (itemSum, item) => itemSum + item.quantity,
                        ),
                  );

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Ventas',
                              value: '\$${total.toStringAsFixed(2)}',
                              icon: Icons.payments_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              title: 'Transacciones',
                              value: transactions.length.toString(),
                              icon: Icons.receipt_long_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _MetricCard(
                        title: 'Unidades vendidas',
                        value: itemCount.toString(),
                        icon: Icons.inventory_2_outlined,
                      ),
                      const SizedBox(height: 16),
                      _Panel(
                        title: 'Transacciones recientes',
                        child: transactions.isEmpty
                            ? const Text('Aun no hay transacciones.')
                            : Column(
                                children: transactions
                                    .map(
                                      (tx) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.check_circle_outline,
                                          color: Color(0xFF1A73E8),
                                        ),
                                        title: Text(
                                          '\$${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                                        ),
                                        subtitle: Text(
                                          '${tx.status} - ${tx.items.length} productos',
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              productsAsync.when(
                loading: () => const _Panel(
                  title: 'Inventario',
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => _Panel(
                  title: 'Inventario',
                  child: Text('Error: $e'),
                ),
                data: (products) => _Panel(
                  title: 'Inventario',
                  child: products.isEmpty
                      ? const Text('No hay productos registrados.')
                      : Column(
                          children: products
                              .map(
                                (product) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(product.name),
                                  subtitle: Text(product.description),
                                  trailing: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Panel({required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E6EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A73E8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
