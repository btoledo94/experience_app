import 'package:go_router/go_router.dart';
import 'package:xpiria_app/feature/onboarding/presentation/view/onboarding_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.onboarding,
      path: '/',
      builder: (context, state) => const OnboardingView(),
    ),
  ],
);

abstract class Routes {
  static const String onboarding = 'onboarding';
}
