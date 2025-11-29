import 'dart:async';
import 'package:attendance/core/theme/app_color.dart';
import 'package:attendance/presentation/screens/home_screen/screen_home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreenHome(),
      ),
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zWhite,
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2),
          child: Image.asset(
            'assets/fingerprint_5818822.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
