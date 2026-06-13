import 'package:flutter/material.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/HomeDashboard.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 22,
                  left: 24,
                  right: 24,
                  bottom: 18,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Ta'afi",
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: const Color(0xffEA580C),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),

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
                     radius: 18,
                      backgroundImage: AssetImage(
                       'assets/images/Avatar4 .png',
                      ),
                     ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    const SizedBox(height: 24),

                    Stack(
                      alignment: Alignment.center,
                      children: [

                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xff4C4356),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        Container(
                          width: 165,
                          height: 165,
                          decoration: BoxDecoration(
                            color: const Color(0xff934800),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xffF4D7C3),
                              width: 6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "95%",
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 54,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "ACCURACY",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 34),

                    Text(
                      "AMAZING JOB,\nAMIRA!",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: const Color(0xff1A1C1C),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "You finished your session with\nexcellence.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xff414752),
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 34),

                    /// SESSION CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
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
                      child: Row(
                        children: [

                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xffD4E3FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.timer_outlined,
                              color: Color(0xff005FAF),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Session Time",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: const Color(0xff414752),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "5 mins",
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff1A1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffD6FFD6), 
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "↗ Optimal",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xff0D6C1E),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: infoCard(
                            icon: Icons.check_circle_outline,
                            iconBg: const Color(0xff9DF898),
                            iconColor: const Color(0xff0D6C1E),
                            title: "Accuracy",
                            value: "Excellent",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: infoCard(
                            icon: Icons.emoji_events_outlined,
                            iconBg: const Color(0xffFFDCC6),
                            iconColor: const Color(0xff934800),
                            title: "Points Earned",
                            value: "+20 pts",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CognitiveGame(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xff934800),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "SEE MY PROGRESS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    GestureDetector(
                     onTap: () {
                    Navigator.pushReplacement(
                      context,
                    MaterialPageRoute(
                       builder: (_) => const HomeDashboard(),
                      ),
                    );
                  },
                    child:Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xffC1C6D4),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "BACK TO HOME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff414752),
                          ),
                        ),
                      ),
                    ),
                   ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "DAILY GOAL: 85%\nCOMPLETED",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 11,
                          color: const Color(0xff1A1C1C),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 18),
          Text(title),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}