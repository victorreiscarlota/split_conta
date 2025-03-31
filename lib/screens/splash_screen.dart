import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'started_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

void _navigateToHome() async {
  await Future.delayed(const Duration(seconds: 3));
  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (_, __, ___) => const StartedScreen(),
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Lottie.asset(
          'assets/animations/preloader.json',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}