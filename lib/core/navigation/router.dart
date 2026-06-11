import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/ecommerce_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/product_detail_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/cart_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/product_list_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/shipping_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/payment_view.dart';
import 'package:xpiria_app/feature/auth/presentation/view/login_view.dart';
import 'package:xpiria_app/feature/auth/presentation/view/register_view.dart';

final router = GoRouter(
  initialLocation: '/login',
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    if (isLoggedIn && isAuthRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      name: Routes.login,
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      name: Routes.register,
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
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
    GoRoute(
      name: Routes.productList,
      path: '/products',
      builder: (context, state) => const ProductListView(),
    ),
    GoRoute(
      name: Routes.shipping,
      path: '/checkout/shipping',
      builder: (context, state) => const ShippingView(),
    ),
    GoRoute(
      name: Routes.payment,
      path: '/checkout/payment',
      builder: (context, state) => const PaymentView(),
    ),
  ],
);

abstract class Routes {
  static const String login = 'login';
  static const String register = 'register';
  static const String onboarding = 'onboarding';
  static const String ecommerce = 'ecommerce';
  static const String productDetail = 'productDetail';
  static const String cart = 'cart';
  static const String productList = 'productList';
  static const String shipping = 'shipping';
  static const String payment = 'payment';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
