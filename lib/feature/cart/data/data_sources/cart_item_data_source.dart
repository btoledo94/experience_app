import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/cart_repository_impl.dart';
import 'package:xpiria_app/feature/cart/domain/repository/cart_repository.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final cartRepositoryProvider = FutureProvider<CartRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return CartRepositoryImpl(prefs);
});
