import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/auth/domain/entity/app_role.dart';
import 'package:xpiria_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:xpiria_app/feature/auth/presentation/view/login_view.dart';
import 'package:xpiria_app/feature/auth/presentation/view/register_view.dart';
import 'package:xpiria_app/feature/cart/presentation/view/cart_view.dart';
import 'package:xpiria_app/feature/checkout/presentation/view/payment_success_view.dart';
import 'package:xpiria_app/feature/checkout/presentation/view/payment_view.dart';
import 'package:xpiria_app/feature/checkout/presentation/view/shipping_view.dart';
import 'package:xpiria_app/feature/finance/presentation/view/finance_dashboard_view.dart';
import 'package:xpiria_app/feature/home/presentation/view/ecommerce_view.dart';
import 'package:xpiria_app/feature/onboarding/presentation/view/onboarding_view.dart';
import 'package:xpiria_app/feature/products/domain/entity/product.dart';
import 'package:xpiria_app/feature/products/presentation/view/create_product_view.dart';
import 'package:xpiria_app/feature/products/presentation/view/edit_product_view.dart';
import 'package:xpiria_app/feature/products/presentation/view/product_detail_view.dart';
import 'package:xpiria_app/feature/products/presentation/view/product_list_view.dart';
import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';
import 'package:xpiria_app/feature/transactions/presentation/view/my_purchases_view.dart';
import 'package:xpiria_app/feature/transactions/presentation/view/transaction_detail_loader_view.dart';
import 'package:xpiria_app/feature/transactions/presentation/view/transaction_detail_view.dart';

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
            location == '/checkout/payment' ||
            location == '/checkout/success';
        final isFinanceRoute = location == '/finance';
        final isMyPurchasesRoute = location == '/my-purchases';
        final isTransactionDetailRoute =
            location == '/transaction-detail' ||
            location.startsWith('/transaction-detail/');

        if (isProductRoute && !profile.role.canManageProducts) return '/';
        if (isCheckoutRoute && !profile.role.canBuy) return '/';
        if (isFinanceRoute && !profile.role.canViewFinance) return '/';
        if (isMyPurchasesRoute && !profile.role.canBuy) return '/';
        if (isTransactionDetailRoute &&
            !(profile.role.canBuy || profile.role.canViewFinance)) {
          return '/';
        }
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
            productPrice: extra?['price'] as String? ?? '\$0.00',
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
        name: Routes.paymentSuccess,
        path: '/checkout/success',
        builder: (context, state) {
          return PaymentSuccessView(
            transaction: state.extra as OrderTransaction?,
          );
        },
      ),
      GoRoute(
        name: Routes.finance,
        path: '/finance',
        builder: (context, state) => const FinanceDashboardView(),
      ),
      GoRoute(
        name: Routes.myPurchases,
        path: '/my-purchases',
        builder: (context, state) => const MyPurchasesView(),
      ),
      GoRoute(
        name: Routes.transactionDetail,
        path: '/transaction-detail',
        builder: (context, state) {
          final extra = state.extra;
          final transaction = extra is Map
              ? extra['transaction'] as OrderTransaction?
              : extra as OrderTransaction?;
          final backToHome = extra is Map
              ? extra['backToHome'] as bool? ?? false
              : false;

          if (transaction == null) {
            return const TransactionDetailView.empty();
          }

          return TransactionDetailView(
            transaction: transaction,
            backToHome: backToHome,
          );
        },
      ),
      GoRoute(
        name: Routes.transactionDetailById,
        path: '/transaction-detail/:transactionId',
        builder: (context, state) => TransactionDetailLoaderView(
          transactionId: state.pathParameters['transactionId']!,
        ),
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
  static const String paymentSuccess = 'paymentSuccess';
  static const String finance = 'finance';
  static const String myPurchases = 'myPurchases';
  static const String transactionDetail = 'transactionDetail';
  static const String transactionDetailById = 'transactionDetailById';
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
