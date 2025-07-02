import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:habithero/widgets/connection_checker.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_challenge.dart';
import 'screens/profile_screen.dart';
import 'screens/no_internet_screen.dart';
import 'screens/forgot_password_screen.dart';

import 'auth_pages/login_page.dart';
import 'auth_pages/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HabitHeroApp());
}

class HabitHeroApp extends StatelessWidget {
  const HabitHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HabitHero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),

          // Auth
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/register', page: () => RegistrationScreen()),
          GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),

          // Main Screens wrapped with ConnectionChecker
          GetPage(name: '/home', page: () => const ConnectionChecker(child: HomeScreen())),
          GetPage(name: '/create', page: () => ConnectionChecker(child: CreateChallengeScreen())),
          GetPage(name: '/profile', page: () => ConnectionChecker(child: ProfileScreen())),

          // No Internet fallback
          GetPage(name: '/no-internet', page: () => const NoInternetScreen()),
        ]

    );
  }
}
