import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:xpiria_app/feature/auth/domain/entity/app_role.dart';
import 'package:xpiria_app/feature/auth/presentation/view/login_view.dart';
import 'package:xpiria_app/feature/auth/presentation/view/register_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/cart_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/ecommerce_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/payment_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/create_product_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/edit_product_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/finance_dashboard_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/product_detail_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/product_list_view.dart';
import 'package:xpiria_app/feature/ecommerce/presentation/view/shipping_view.dart';
import 'package:xpiria_app/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xpiria_app/feature/ecommerce/domain/entity/product.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);
  final getCurrentAuthUser = ref.watch(getCurrentAuthUserUseCaseProvider);
  final profileAsync = ref.watch(currentUserProfileProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(watchAuthState()),
    redirect: (context, state) {
      final isLoggedIn = getCurrentAuthUser() != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      final profile = profileAsync.valueOrNull;
      final location = state.matchedLocation;

      if (isLoggedIn && profile != null) {
        final isProductRoute =
            location == '/products' ||
            location == '/products/create' ||
            location == '/products/edit';
        final isCheckoutRoute =
            location == '/cart' ||
            location == '/checkout/shipping' ||
            location == '/checkout/payment';
        final isFinanceRoute = location == '/finance';

        if (isProductRoute && !profile.role.canManageProducts) return '/';
        if (isCheckoutRoute && !profile.role.canBuy) return '/';
        if (isFinanceRoute && !profile.role.canViewFinance) return '/';
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
          final extra = state.extra as Map<String, dynamic>?;
          return ProductDetailView(
            productName: extra?['name'] as String? ?? 'Product',
            productPrice: extra?['price'] as String? ?? '€ 0.00',
            productDescription: extra?['description'] as String? ?? '',
            productImageUrl: extra?['imageUrl'] as String? ?? '',
            productColors: List<String>.from(extra?['colors'] ?? []),
            productSizes: List<String>.from(extra?['sizes'] ?? []),
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
        name: Routes.createProduct,
        path: '/products/create',
        builder: (context, state) => const CreateProductView(),
      ),
      GoRoute(
        name: Routes.editProduct,
        path: '/products/edit',
        builder: (context, state) {
          final product = state.extra as Product;
          return EditProductView(product: product);
        },
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
      GoRoute(
        name: Routes.finance,
        path: '/finance',
        builder: (context, state) => const FinanceDashboardView(),
      ),
    ],
  );
});

abstract class Routes {
  static const String login = 'login';
  static const String register = 'register';
  static const String onboarding = 'onboarding';
  static const String ecommerce = 'ecommerce';
  static const String productDetail = 'productDetail';
  static const String cart = 'cart';
  static const String productList = 'productList';
  static const String createProduct = 'createProduct';
  static const String editProduct = 'editProduct';
  static const String shipping = 'shipping';
  static const String payment = 'payment';
  static const String finance = 'finance';
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
