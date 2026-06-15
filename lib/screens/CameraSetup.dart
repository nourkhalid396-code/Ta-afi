import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/ActiveTrackingSession.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/ExerciseReminder.dart';

class CameraSetup extends StatefulWidget {
  const CameraSetup({super.key});

  @override
  State<CameraSetup> createState() => _CameraSetupState();
}

class _CameraSetupState extends State<CameraSetup> {
  bool _isLoading = false;

  Future<void> _startTracking() async {
    setState(() => _isLoading = true);
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': 'camera_tracking',
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'tracking',
      });
      if (mounted)
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ActiveTrackingSession()));
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: topPadding + 30, left: 20, right: 20, bottom: 18),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen())),
                    child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage('assets/images/Avatar3.png')),
                  ),
                  Text("Ta'afi",
                      style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExerciseReminder())),
                    child: Icon(Icons.notifications_none,
                        color: AppColors.textColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text("Perfecting Your\nView",
                      style: AppTextStyles.headlineLarge.copyWith(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: const Color(0xff1A1C1C))),
                  const SizedBox(height: 10),
                  Text(
                      "Let's ensure the best tracking quality\nfor your session.",
                      style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xff414752), height: 1.6)),
                  const SizedBox(height: 24),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.95,
                      child: Container(
                        height: 320,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: const Color(0xffF3F1F1),
                            borderRadius: BorderRadius.circular(24)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                width: 270,
                                height: 240,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                        'assets/images/Visual Calibration G.png',
                                        fit: BoxFit.cover))),
                            Positioned(
                                child: Container(
                                    width: 270,
                                    height: 1,
                                    color: AppColors.primaryColor
                                        .withOpacity(0.6))),
                            Positioned(
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(children: [
                                  Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                          color: Color(0xff0D6C1E),
                                          shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text("Optimal Detection Range",
                                      style: AppTextStyles.bodyMedium.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff1A1C1C))),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  buildItem(Icons.phone_android, "Stable Surface",
                      "Place your phone on a firm\nstand or prop it up securely."),
                  const SizedBox(height: 20),
                  buildItem(Icons.crop_free, "Sit Within Frame",
                      "Stay about 50cm away. Keep\nyour hand visible in the box."),
                  const SizedBox(height: 20),
                  buildItem(Icons.wb_sunny_outlined, "Even Lighting",
                      "Avoid shadows. Bright, natural\nlight works best for tracking."),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _isLoading ? null : _startTracking,
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Color(0xffB85C00), Color(0xff934800)]),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6))
                          ]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text("I'M READY, START TRACKING",
                                    style: AppTextStyles.buttonText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                            if (!_isLoading) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white)
                            ],
                          ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(IconData icon, String title, String subtitle) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: const Color(0xffD9E8FF),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xff005FAF), size: 22)),
      const SizedBox(width: 14),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xff1A1C1C))),
        const SizedBox(height: 4),
        Text(subtitle,
            style: AppTextStyles.bodyMedium
                .copyWith(color: const Color(0xff414752), height: 1.5)),
      ])),
    ]);
  }
}
