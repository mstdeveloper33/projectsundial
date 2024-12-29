import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sundialproject/core/dependencies/locator.dart';

import 'core/router/app_router.dart';
import 'presentation/screens/onboarding/viewmodel/onboarding_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  setupLocator();
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
