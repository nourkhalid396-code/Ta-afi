import 'package:flutter/material.dart';
import 'package:my_app/screens/CameraSetup.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/screens/ProfileScreen.dart';

class PhysicalRehabExercises extends StatelessWidget {
  const PhysicalRehabExercises({super.key});

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
                  top: 20,
                  left: 22,
                  right: 22,
                  bottom: 20,
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

                   child: Container(
                   width: 32,
                   height: 32,

                  decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                    image: DecorationImage(
                       image: AssetImage(
                       'assets/images/Avatar2.png',
                       ),
                   fit: BoxFit.cover,
                   ),
                 ),
               ),
             ),

                    const SizedBox(width: 8),

                    Text(
                      "Ta'afi",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.notifications_none,
                      color: AppColors.lightTextColor,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 24),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Daily ",
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff1A1C1C),
                            ),
                          ),
                          TextSpan(
                            text: "Motion",
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff934800),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Focused physical therapy designed\n"
                      "to restore hand dexterity and wrist\n"
                      "mobility through gentle, progressive\n"
                      "movements.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        height: 1.8,
                        fontSize: 14,
                        color: const Color(0xff414752),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          filterButton(
                            title: "All Exercises",
                            active: true,
                          ),

                          const SizedBox(width: 10),

                          filterButton(
                            title: "Mobility",
                            active: false,
                          ),

                          const SizedBox(width: 10),

                          filterButton(
                            title: "Strength",
                            active: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    exerciseCard(
                      context: context,
                      image: 'assets/images/hand2.png',
                      duration: '5 mins',
                      title: 'Finger\nExtensions',
                      subtitle:
                          'Releasing tension and\nimproving span.',
                    ),

                    const SizedBox(height: 20),

                    exerciseCard(
                      context: context,
                      image: 'assets/images/hand3.png',
                      duration: '8 mins',
                      title: 'Wrist Rotations',
                      subtitle:
                          'Enhancing circular range of\nmotion.',
                    ),

                    const SizedBox(height: 20),

                    exerciseCard(
                      context: context,
                      image: 'assets/images/hand4.png',
                      duration: '12 mins',
                      title: 'Grip\nStrengthening',
                      subtitle:
                          'Building foundational muscle\npower.',
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
  height: 82,
  padding: const EdgeInsets.symmetric(horizontal: 12),

  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
      ),
    ],
  ),

  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [

      GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const HomeDashboard(),
  ),
  (route) => false,
);
        },
        child: navItem(
          icon: Icons.home_outlined,
          title: "Home",
          active: false,
        ),
      ),

      GestureDetector(
        onTap: () {},
        child: navItem(
          icon: Icons.back_hand,
          title: "Exercises",
          active: true,
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
          title: "Games",
          active: false,
        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProgressAchievements(),
            ),
          );
        },
        child: navItem(
          icon: Icons.auto_graph,
          title: "Progress",
          active: false,
        ),
      ),
    ],
  ),
),
);
  }


  Widget filterButton({
    required String title,
    required bool active,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: active
            ? const Color(0xff54A0FE)
            : Colors.grey.shade100,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,

          color: active
              ? const Color(0xff003567)
              : AppColors.textColor,
        ),
      ),
    );
  }

  Widget exerciseCard({
    required BuildContext context,
    required String image,
    required String duration,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Stack(
          children: [

            Container(
              width: double.infinity,
              height: 185,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),

                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 12,
              left: 12,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: Color(0xff934800),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      duration,
                      style: const TextStyle(
                        color: Color(0xff1A1C1C),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff1A1C1C),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.6,
                      color: const Color(0xff414752),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraSetup(),
                  ),
                );
              },

              child: Container(
                width: 42,
                height: 42,

                decoration: const BoxDecoration(
                  color: Color(0xff934800),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
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

        Icon(
          icon,
          size: 22,
          color: active
              ? const Color(0xff9A3412)
              : AppColors.lightTextColor,
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,

            color: active
                ? const Color(0xff9A3412)
                : AppColors.lightTextColor,
          ),
        ),
      ],
    );
  }
}