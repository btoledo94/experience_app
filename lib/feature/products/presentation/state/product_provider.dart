import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpiria_app/feature/products/data/data_sources/product_local_data_source.dart';
import 'package:xpiria_app/feature/products/data/data_sources/product_remote_data_source.dart';
import 'package:xpiria_app/feature/products/data/repository/product_repository_impl.dart';
import 'package:xpiria_app/feature/products/domain/entity/product.dart';
import 'package:xpiria_app/feature/products/domain/repository/product_repository.dart';

final productRepositoryProvider = FutureProvider<ProductRepository>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  final localDataSource = ProductLocalDataSource();
  final remoteDataSource = ProductRemoteDataSource(FirebaseFirestore.instance);
  final repo = ProductRepositoryImpl(prefs, localDataSource, remoteDataSource);
  await repo.initializeDefaultProducts();
  return repo;
});

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repo = await ref.watch(productRepositoryProvider.future);
    // Intenta Firestore primero; si falla usa los productos locales
    try {
      final remote = await repo.fetchRemoteProducts();
      if (remote.isNotEmpty) {
        await repo.saveProducts(remote);
        return remote;
      }
    } catch (_) {
      // Firestore no disponible: usar caché local
    }
    return repo.loadProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
      try {
        final remote = await repo.fetchRemoteProducts();
        if (remote.isNotEmpty) {
          await repo.saveProducts(remote);
          return remote;
        }
      } catch (_) {}
      return repo.loadProducts();
    });
  }

  Future<void> resetToDefaults() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
      await repo.resetProducts();
      return repo.loadProducts();
    });
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    String imageUrl = '',
    List<String> colors = const [],
    List<String> sizes = const [],
  }) async {
    final previous = state;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
      final created = await repo.createProduct(
        Product(
          id: '',
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          colors: colors,
          sizes: sizes,
        ),
      );

      final current = previous.value ?? await repo.loadProducts();
      return [...current, created];
    });
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    String imageUrl = '',
    List<String> colors = const [],
    List<String> sizes = const [],
  }) async {
    final previous = state;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
      final updated = await repo.updateProduct(
        Product(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          colors: colors,
          sizes: sizes,
        ),
      );

      final current = previous.value ?? await repo.loadProducts();
      return current.map((p) => p.id == id ? updated : p).toList();
    });
  }

  Future<void> deleteProduct(String productId) async {
    final previous = state;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
      await repo.deleteProduct(productId);

      final current = previous.value ?? await repo.loadProducts();
      return current.where((p) => p.id != productId).toList();
    });
  }
}

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);
