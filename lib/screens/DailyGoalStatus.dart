import 'package:flutter/material.dart';
import 'package:my_app/screens/ExerciseReminder.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';

class DailyGoalStatus extends StatelessWidget {
  const DailyGoalStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                    onTap: () {
                    Navigator.push(
                     context,
                    MaterialPageRoute(
                     builder: (context) => const ProfileScreen(),
                    ),
                   );
                 },
                  child: const CircleAvatar(
                   radius: 20,
                  backgroundImage: AssetImage(
                   'assets/images/Avatar6.png',
                   ),
                  ),
                 ),
                    const Spacer(),
                    Text(
                      "Daily Progress",
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: const Color(0xffEA580C),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.notifications_none,
                      color: Color(0xff64748B),
                      size: 28,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    const SizedBox(height: 22),

                    Center(
                      child: Image.asset(
                        'assets/images/Simplified Illustration Area.png',
                        width: 280,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Ready for your first step\ntowards recovery?",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: const Color(0xff1A1C1C),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "Your journey begins here. Every\nsmall movement counts toward\nyour strength.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xff414752),
                        height: 1.7,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 34),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExerciseReminder(),
                          ),
                        );
                      },

                      child: Container(
                        width: double.infinity,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xff934800),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "START TODAY'S SESSION",
                            style: AppTextStyles.buttonText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Color(0xff7B8190),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "It takes only 10 minutes to begin",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff7B8190),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(
              icon: Icons.home_outlined,
              title: "Home",
              active: false,
            ),

            navItem(
              icon: Icons.back_hand_outlined,
              title: "Exercises",
              active: false,
            ),

            navItem(
              icon: Icons.extension_outlined,
              title: "Games",
              active: false,
            ),

            navItem(
              icon: Icons.auto_graph,
              title: "Progress",
              active: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xffFCE7CC)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(18),
          ),

          child: Icon(
            icon,
            size: 24,
            color: active
                ? const Color(0xff9A3412)
                : const Color(0xff64748B),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active
                ? const Color(0xff9A3412)
                : const Color(0xff64748B),
          ),
        ),
      ],
    );
  }
}