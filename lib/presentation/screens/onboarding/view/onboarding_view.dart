import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'onboarding_buttons_widget.dart';
import 'onboarding_page.dart';


class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<OnboardingViewModel>(context, listen: false);
    viewModel.loadMotivationalMessage();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        final motivationalMessage = viewModel.motivationalMessages?.isNotEmpty == true
            ? viewModel.motivationalMessages!.first.message
            : "Loading...";

        final pages = [
          const OnboardingPage(
            title: "Welcome",
            content: "Track your health and mental well-being effortlessly!",
            color: Color(0xFFA0D4CF),
            imagePath: 'lib/assets/onboardingimages/health.png',
          ),
          const OnboardingPage(
            title: "",
            content: "Ready to journal? Let's get started!",
            color: const Color(0xFFD0C7BA),
            imagePath: 'lib/assets/onboardingimages/diary.png',
          ),
           OnboardingPage(
            title: "",
            content: motivationalMessage,
            color: Color(0xFFE1DDCC),
            imagePath: 'lib/assets/onboardingimages/motivation.png',
          ),
        ];

        return Scaffold(
          body: Stack(
            children: [
              // PageView'e physics parametresi ekleyerek kaydırma engellendi
              PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return pages[index];
                },
                physics: NeverScrollableScrollPhysics(), // Kaydırmayı engelledik
              ),
              OnboardingButtons(
                currentPage: _currentPage,
                totalPages: pages.length,
                pageController: _pageController,
              ),
            ],
          ),
        );
      },
    );
  }
}
