import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/navigation/router.dart';
import 'feature/ecommerce/presentation/state/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Crear un container para inicializar el carrito
  final container = ProviderContainer();
  await container.read(cartProvider.notifier).initialize(prefs);

  runApp(ProviderScope(child: MainApp(container: container)));
}

class MainApp extends ConsumerWidget {
  final ProviderContainer container;

  const MainApp({super.key, required this.container});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
