import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/auth/domain/entity/app_role.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:xpiria_app/feature/products/domain/entity/product.dart';
import 'package:xpiria_app/feature/products/presentation/state/product_provider.dart';
import 'package:xpiria_app/core/notifications/notification_service.dart';
import '../widget/ecommerce_app_bar.dart';
import '../widget/product_carousel.dart';
import '../widget/product_section.dart';

class EcommerceView extends ConsumerStatefulWidget {
  const EcommerceView({super.key});

  @override
  ConsumerState<EcommerceView> createState() => _EcommerceViewState();
}

class _EcommerceViewState extends ConsumerState<EcommerceView> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final role = ref.watch(currentUserProfileProvider).valueOrNull?.role;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EcommerceAppBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Probar notificacion local',
        onPressed: () async {
          await NotificationService.instance.showLocalNotification(
            title: 'Oferta especial',
            body: 'Tu notificacion local de Xpiria funciona correctamente.',
            payload: '/',
          );
        },
        child: const Icon(Icons.notifications_active_outlined),
      ),
      body: SafeArea(
        child: productsAsync.when(
          data: (products) => SingleChildScrollView(
            child: Column(
              children: [
                // Product Carousel
                const ProductCarousel(),
                const SizedBox(height: 24),

                ..._buildProductSections(products),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading products: $e')),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
          if (index == 1) {
            if (role?.canManageProducts ?? false) {
              context.push('/products');
            } else if (role?.canViewFinance ?? false) {
              context.push('/finance');
            } else if (role?.canBuy ?? false) {
              context.push('/my-purchases');
            }
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Panel',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  List<Widget> _buildProductSections(List<Product> products) {
    if (products.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text('No products available'),
        ),
      ];
    }

    final categories = <String, List<Product>>{
      'Everyday essentials': [],
      'Daily picks': [],
      'Premium favorites': [],
    };

    for (final product in products) {
      if (product.price < 20) {
        categories['Everyday essentials']!.add(product);
      } else if (product.price < 60) {
        categories['Daily picks']!.add(product);
      } else {
        categories['Premium favorites']!.add(product);
      }
    }

    final widgets = <Widget>[];

    categories.forEach((title, sectionProducts) {
      if (sectionProducts.isEmpty) return;

      widgets.add(
        ProductSection(
          title: title,
          products: sectionProducts
              .map(
                (p) => ProductData(
                  name: p.name,
                  price: '€ ${p.price.toStringAsFixed(2)}',
                  description: p.description,
                  imageUrl: p.imageUrl,
                  colors: p.colors,
                  sizes: p.sizes,
                ),
              )
              .toList(),
        ),
      );
      widgets.add(const SizedBox(height: 24));
    });

    return widgets;
  }
}
