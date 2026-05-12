import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/ecommerce_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/product_detail_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/cart_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.onboarding,
      path: '/onboarding',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      name: Routes.ecommerce,
      path: '/',
      builder: (context, state) => const EcommerceView(),
    ),
    GoRoute(
      name: Routes.productDetail,
      path: '/product-detail',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return ProductDetailView(
          productName: extra?['name'] ?? 'Product',
          productPrice: extra?['price'] ?? '€ 0.00',
        );
      },
    ),
    GoRoute(
      name: Routes.cart,
      path: '/cart',
      builder: (context, state) => const CartView(),
    ),
  ],
);

abstract class Routes {
  static const String onboarding = 'onboarding';
  static const String ecommerce = 'ecommerce';
  static const String productDetail = 'productDetail';
  static const String cart = 'cart';
}
