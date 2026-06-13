import 'package:flutter/material.dart';
import 'package:my_app/screens/PhysicalRehabExercises.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/screens/ProfileScreen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

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
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [

                        Container(
                          width: 46,
                          height: 46,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  AppColors.secondaryColor,
                              width: 2,
                            ),
                          ),

                          child: GestureDetector(
                          onTap: () {
                           Navigator.push(
                            context,
                           MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                         );
                        },
                          child: ClipOval(
                          child: Image.asset(
                           'assets/images/Avatar1 .png',
                          fit: BoxFit.cover,
                         ),
                        ),
                       ),
                      ),

                        const SizedBox(width: 12),

                        Text(
                          "Taafi",
                          style:
                              AppTextStyles
                                  .headlineMedium
                                  .copyWith(
                            color:
                                AppColors.primaryColor,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Icon(
                      Icons.notifications_none,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 22,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 24),

                    const Text(
                      "Hello, Ahmed",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A1C1C),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Your recovery sanctuary is ready. Take\nit one step at a time today.",

                      style: AppTextStyles.bodyLarge,
                    ),

                    const SizedBox(height: 28),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),

                      decoration: BoxDecoration(
                        color:
                            AppColors.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(28),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            "DAILY STATUS",

                            style: AppTextStyles
                                .bodyMedium
                                .copyWith(
                              color:
                                  const Color(0xff934800),
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Today’s Goal",

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  Color(0xff1A1C1C),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            "You've completed 3 of 5 recovery\nsessions. Keep the momentum\ngoing!",

                            style:
                                AppTextStyles.bodyLarge,
                          ),

                          const SizedBox(height: 28),

                          Container(
                            height: 58,
                            width: 220,

                            decoration: BoxDecoration(
                              color: const Color(
                                  0xff934800),

                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(
                                          0.12),
                                  blurRadius: 10,
                                  offset:
                                      const Offset(
                                          0, 5),
                                ),
                              ],
                            ),

                            alignment: Alignment.center,

                            child: const Text(
                              "Resume Exercises",
                              style:
                                  AppTextStyles.buttonText,
                            ),
                          ),

                          const SizedBox(height: 35),

                          Center(
                            child: Stack(
                              alignment:
                                  Alignment.center,

                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,

                                  child:
                                      const CircularProgressIndicator(
                                    value: 1,
                                    strokeWidth: 10,
                                    backgroundColor:
                                        Color(
                                            0xff0D6C1E),

                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      Color(
                                          0xff0D6C1E),
                                    ),
                                  ),
                                ),

                                Column(
                                  children: [
                                    const Text(
                                      "60%",

                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color: Color(
                                            0xff1A1C1C),
                                      ),
                                    ),

                                    Text(
                                      "DONE",
                                      style: AppTextStyles
                                          .bodyMedium
                                          .copyWith(
                                        color:
                                            const Color(
                                                0xff1A1C1C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                const PhysicalRehabExercises(),
                          ),
                        );
                      },

                      child: buildFeatureCard(
                      context,
                      onTap: () {
                       Navigator.push(
                        context,
                       MaterialPageRoute(
                        builder: (_) =>
                        const PhysicalRehabExercises(),
                        ),
                       );
                      },
                      iconBg: AppColors.accentColor.withOpacity(0.15),
                      iconColor: const Color(0xff0D6C1E),
                      icon: Icons.back_hand,
                      title: "Physical Rehab",
                      titleColor: const Color(0xff1A1C1C),
                      description:
                       "Gentle motor skill recovery focused\non hand and wrist flexibility.",
                       footer: "12 Exercises",
                       footerColor: const Color(0xff0D6C1E),
                      ),
                    ),

                    const SizedBox(height: 24),

                    buildFeatureCard(
                       context,
                        onTap: () {
                         Navigator.push(
                          context,
                         MaterialPageRoute(
                          builder: (_) => const CognitiveGame(),
                         ),
                        );
                       },
                      iconBg:
                          Colors.blue.withOpacity(0.12),

                      iconColor:
                          const Color(0xff005FAF),

                      icon: Icons.psychology,

                      title: "Brain Games",

                      titleColor:
                          const Color(0xff1A1C1C),

                      description:
                          "Cognitive challenges designed to\nimprove focus and memory recall.",

                      footer: "8 Games",

                      footerColor:
                          const Color(0xff005FAF),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          "Weekly Outlook",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Color(0xff1A1C1C),
                          ),
                        ),

                        Text(
                          "View Report",

                          style: AppTextStyles
                              .bodyLarge
                              .copyWith(
                            color:
                                const Color(0xff934800),
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Image.asset(
                      'assets/images/Background.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
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
  decoration: const BoxDecoration(
    color: Colors.white,
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: navItem(
          icon: Icons.home,
          label: "Home",
          active: true,
        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhysicalRehabExercises(),
            ),
          );
        },
        child: navItem(
          icon: Icons.back_hand_outlined,
          label: "Exercises",
        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CognitiveGame(),
            ),
          );
        },
        child: navItem(
          icon: Icons.psychology_outlined,
          label: "Games",
        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ProgressAchievements(),
            ),
          );
        },
        child: navItem(
          icon: Icons.auto_graph,
          label: "Progress",
        ),
      ),
    ],
  ),
),
    );
  }

  Widget buildFeatureCard(
  BuildContext context, {
    required VoidCallback onTap,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required Color titleColor,
    required String description,
    required String footer,
    required Color footerColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(28),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 64,
            height: 64,

            decoration: BoxDecoration(
              color: iconBg,
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 34,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            title,

            style: AppTextStyles
                .headlineMedium
                .copyWith(
              color: titleColor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            description,

            style: AppTextStyles.bodyLarge
                .copyWith(height: 1.7),
          ),

          const SizedBox(height: 22),

          GestureDetector(
           onTap: onTap,
           child: Row(
            mainAxisSize: MainAxisSize.min,
             children: [
              Text(
               footer,
              style: AppTextStyles.bodyLarge.copyWith(
                color: footerColor,
                 fontWeight: FontWeight.bold,
                 ),
               ),

      const SizedBox(width: 6),

      Icon(
        Icons.arrow_forward,
        color: footerColor,
      ),
    ],
  ),
),
        ],
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Container(
      width: 82,
      height: 58,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xffFFEDD5)
            : Colors.transparent,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            icon,

            color: active
                ? const Color(0xff9A3412)
                : AppColors.lightTextColor,
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: AppTextStyles.bodyMedium
                .copyWith(
              fontWeight: FontWeight.w600,

              color: active
                  ? const Color(0xff9A3412)
                  : AppColors.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}