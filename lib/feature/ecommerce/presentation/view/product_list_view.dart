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
          IconButton(
            onPressed: () async {
              await context.push('/products/create');
              if (context.mounted) {
                await ref.read(productsProvider.notifier).refresh();
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Crear producto',
          ),
          TextButton(
            onPressed: () async {
              await ref.read(productsProvider.notifier).refresh();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Productos sincronizados')),
                );
              }
            },
            child: const Text('Sync'),
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
                      'description': product.description,
                      'imageUrl': product.imageUrl,
                      'colors': product.colors,
                      'sizes': product.sizes,
                    },
                  );
                  await ref.read(productsProvider.notifier).refresh();
                },
                leading: _ProductListImage(imageUrl: product.imageUrl),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('€ ${product.price.toStringAsFixed(2)}'),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await context.push('/products/edit', extra: product);
                          if (context.mounted) {
                            await ref.read(productsProvider.notifier).refresh();
                          }
                        }

                        if (value == 'delete') {
                          await ref
                              .read(productsProvider.notifier)
                              .deleteProduct(product.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Producto eliminado.'),
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                  ],
                ),
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

class _ProductListImage extends StatelessWidget {
  final String imageUrl;
  static const _imageRequestHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Mobile Safari/537.36',
    'Referer': 'https://www.somosmamas.com.ar/',
  };

  const _ProductListImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (!_isValidNetworkImageUrl(imageUrl)) {
      return const Icon(Icons.image_outlined, size: 40);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        imageUrl,
        headers: _imageRequestHeaders,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined),
      ),
    );
  }
}

bool _isValidNetworkImageUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      uri.isAbsolute &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}
