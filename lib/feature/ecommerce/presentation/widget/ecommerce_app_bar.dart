import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/auth/domain/entity/app_role.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import '../state/cart_provider.dart';

class EcommerceAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const EcommerceAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final itemCount = cartState.itemCount;
    final authState = ref.watch(authStateProvider);
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;
    final role = profile?.role;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: () {},
      ),
      title: authState.when(
        data: (user) => user != null
            ? Text(
                user.email ?? 'Usuario',
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_outline, color: Colors.black),
          onPressed: () {},
        ),
        if (role?.canManageProducts ?? false)
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Colors.black),
            tooltip: 'Productos',
            onPressed: () => context.go('/products'),
          ),
        if (role?.canViewFinance ?? false)
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.black),
            tooltip: 'Finanzas',
            onPressed: () => context.go('/finance'),
          ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).signOut();
          },
        ),
        if (role?.canBuy ?? false)
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                onPressed: () => context.go('/cart'),
              ),
              if (itemCount > 0)
                Positioned(
                  right: 12,
                  top: 25,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2962FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
