import 'package:flutter/material.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OfflineSaveScreen(),
    );
  }
}

class OfflineSaveScreen extends StatelessWidget {
  const OfflineSaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),

            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu,
                        color: Color(0xffC45A1A),
                        size: 28,
                      ),

                      const SizedBox(width: 14),

                      Text(
                        "Taafi",
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: const Color(0xffC45A1A),
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),

                      const Spacer(),

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
                       radius: 22,
                      backgroundImage: AssetImage(
                        'assets/images/Avatar7.png',
                        ),
                       ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daily Physical Therapy",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff222222),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Continue your progress from yesterday.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff414752),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,

                            decoration: const BoxDecoration(
                              color: Color(0xffF7DED0),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.hub_outlined,
                              color: Color(0xff8B4A22),
                              size: 24,
                            ),
                          ),

                          const Spacer(),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(0xffDDF2DD),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Text(
                              "IN PROGRESS",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0D6C1E),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Finger Flexion Series",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222222),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Focus on slow, controlled movements\n"
                        "to restore nerve connectivity.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xff414752),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: const [
                          Text(
                            "Session Progress",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Spacer(),

                          Text(
                            "80%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB56B1F),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: LinearProgressIndicator(
                          value: 0.8,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xffA65B11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xffE9EDF8),
                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: const [
                            Icon(
                              Icons.timer_outlined,
                              color: Color(0xff2B66B1),
                              size: 28,
                            ),

                            Spacer(),

                            Text(
                              "12m",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Active Time",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff2B66B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xffDDF1DB),
                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: const [
                            Icon(
                              Icons.bolt_outlined,
                              color: Color(0xff0D6C1E),
                              size: 28,
                            ),

                            Spacer(),

                            Text(
                              "4/5",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Goal Sets",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff0D6C1E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),             

                const SizedBox(height: 22),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProgressAchievements(),
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xff2F9133),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,

                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: const [
                            Text(
                              "Saved locally",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "تم الحفظ محلياً",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  height: 82,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      bottomItem(
                        Icons.home_outlined,
                        "Home",
                        false,
                      ),

                      bottomItem(
                        Icons.hub_outlined,
                        "Rehab",
                        true,
                      ),

                      bottomItem(
                        Icons.bar_chart_outlined,
                        "Progress",
                        false,
                      ),

                      bottomItem(
                        Icons.person_outline,
                        "Profile",
                        false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomItem(
    IconData icon,
    String title,
    bool active,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          padding: active
              ? const EdgeInsets.all(12)
              : EdgeInsets.zero,

          decoration: BoxDecoration(
            color: active
                ? const Color(0xffF5E1D3)
                : Colors.transparent,

            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            size: 24,
            color: active
                ? const Color(0xffA95B1A)
                : Colors.grey,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: active
                ? const Color(0xffA95B1A)
                : Colors.grey,

            fontWeight: active
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}