import 'package:go_router/go_router.dart';

import '../../presentation/screens/onboarding/view/onboarding_view.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
     
    ],
  );
}