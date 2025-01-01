import 'package:go_router/go_router.dart';


import '../../presentation/screens/dashboard/view/dashboard_view.dart';
import '../../presentation/screens/journaling/view/journal_view.dart';
import '../../presentation/screens/onboarding/view/onboarding_view.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
      GoRoute(path: '/journal', builder: (context, state) => const JournalingView()),
      GoRoute(path: '/dashboard', builder: (context, state) => const DashboardView()),
     
      
     
    ],
  );
}