import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageController pageController;

  const OnboardingButtons({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Previous Button (İlk sayfada gizli, 2. ve 3. sayfada olacak)
        if (currentPage != 0 && currentPage != 2)
          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.1,
            child: ElevatedButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 180, 175, 157),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: size.height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Previous",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Next Button (Sadece ilk iki sayfada olacak)
        if (currentPage != 2)
          Positioned(
            right: size.width * 0.04,
            bottom: size.height * 0.05,
            child: ElevatedButton(
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color.fromARGB(255, 100, 96, 85),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: size.height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        // Start Journaling Button (Son sayfada olacak)
        if (currentPage == 2)
          Positioned(
            right: size.width * 0.05,
            bottom: size.height * 0.05,
            child: ElevatedButton(
              onPressed: () => context.go('/journal'),
              child: Text(
                "Start Journaling",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color.fromARGB(255, 100, 96, 85),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: size.height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
