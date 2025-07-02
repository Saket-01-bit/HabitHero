import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/create_challenge.dart';
import 'screens/profile_screen.dart';
import 'screens/rewards_screen.dart'; // ✅ NEW
import 'auth_pages/login_page.dart';
import 'auth_pages/registration_page.dart';
import 'screens/forgot_password_screen.dart';

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
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => RegistrationScreen()),
        GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/create', page: () => CreateChallengeScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage( // ✅ NEW: Rewards Page
          name: '/rewards',
          page: () => RewardsScreen(totalDaysCompleted: 0), // Replace 0 with dynamic value
        ),
      ],
    );
  }
}
