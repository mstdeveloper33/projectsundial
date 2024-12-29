import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final String imagePath;

  const OnboardingPage({
    required this.title,
    required this.content,
    required this.color,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını almak için MediaQuery
    final size = MediaQuery.of(context).size;

    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                height: size.height * 0.4, // Resmi ekran boyutuna göre ölçekle
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            title,
            style: TextStyle(
              fontSize: size.width * 0.09, // Dinamik yazı boyutu
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.050, // Dinamik yazı boyutu
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
