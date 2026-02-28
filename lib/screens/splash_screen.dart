import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivityAndNavigate();
  }

  Future<void> _checkConnectivityAndNavigate() async {
    final result = await Connectivity().checkConnectivity();

    await Future.delayed(const Duration(seconds: 2)); // Optional: splash delay

    if (!mounted) return;

    if (result == ConnectivityResult.none) {
      Get.offAllNamed('/no-internet');
    } else {
      Navigator.pushReplacementNamed(context, '/home'); // or '/login'
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E1E2C),
      body: Center(
        child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
      ),
    );
  }
}
