import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_sources/product_local_data_source.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';

final productRepositoryProvider = FutureProvider<ProductRepository>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  final localDataSource = ProductLocalDataSource();
  final repo = ProductRepositoryImpl(prefs, localDataSource);
  await repo.initializeDefaultProducts();
  return repo;
});

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repo = await ref.watch(productRepositoryProvider.future);
    return repo.loadProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(productRepositoryProvider.future);
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
}

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);
