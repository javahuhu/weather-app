import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

   
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/getstarted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/splashscreen/splashscreen.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 500,
              child: Lottie.asset(
                'assets/splashscreen/loading_dot.json',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
