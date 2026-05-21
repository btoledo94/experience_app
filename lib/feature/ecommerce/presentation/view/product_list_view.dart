import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/product_provider.dart';

class ProductListView extends ConsumerWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(productsProvider.notifier).resetToDefaults();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Productos actualizados')),
                );
              }
            },
            child: const Text('Fresh'),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                onTap: () async {
                  await context.push(
                    '/product-detail',
                    extra: {
                      'name': product.name,
                      'price': '€ ${product.price.toStringAsFixed(2)}',
                    },
                  );
                  await ref.read(productsProvider.notifier).refresh();
                },
                leading: const Icon(Icons.image_outlined, size: 40),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('€ ${product.price.toStringAsFixed(2)}'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
