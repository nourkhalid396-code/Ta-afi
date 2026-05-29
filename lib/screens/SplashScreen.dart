import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/screens/onboarding1.dart';

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
          builder: (context) => const Onboarding1(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4E3FF),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/images/shield.png',
                fit: BoxFit.cover,
                height: 170,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// صورة الكف (logo)
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                ),

                const SizedBox(height: 28),

                const Text(
                  "Ta'afi",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF934800),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "YOUR PATH TO RECOVERY",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF005FAF),
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 45),

                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 5,
                      color: Color(0xFF934800),
                      backgroundColor:
                          const Color(0xFF934800).withOpacity(0.15),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Preparing your personalized\nsanctuary for rehabilitation.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: Color(0xFF414752),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "SAFE & SECURE ENVIRONMENT",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF717783),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.circle, size: 10, color: Color(0x80005FAF)), 
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 10, color: Color(0x80934800)), 
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 10, color: Color(0x800D6C1E)), 
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
