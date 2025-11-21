import 'package:easyqist/pages/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/newlogo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // TEXT
            const Text(
              'Your Trust,\nOur Commitment\nwith easy Qist',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0C3C78), // match app_theme_color
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
