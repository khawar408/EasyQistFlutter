import 'package:easyqist/pages/auth/screens/login_screen.dart';
import 'package:easyqist/pages/auth/screens/otp_verification_screen.dart';
import 'package:easyqist/pages/auth/screens/signup_screen.dart';
import 'package:easyqist/pages/mainscreen/main_screen.dart';
import 'package:easyqist/pages/splash/SplashScreen.dart';
import 'package:easyqist/util/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'util/colors.dart'; // Import your color file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Qist',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          background: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AppRoutes.mainScreen, page: () =>  MainScreen()),
        GetPage(name: AppRoutes.login, page: () =>  LoginScreen()),
        GetPage(name: AppRoutes.signup, page: () =>  SignupScreen()),
        GetPage(name: AppRoutes.otp, page: () =>  OtpVerificationScreen()),
        // GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
      ],
    );
  }
}
