import 'package:flutter/material.dart';
import 'package:my_app/screens/onboarding2.dart';
import 'package:my_app/theme/app_theme.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xffFFE9DB),
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26),

              child: Column(
                children: [

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "Ta'afi",
                        style:
                            AppTextStyles.headlineMedium
                                .copyWith(
                          color: const Color(0xff934800),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Skip",
                        style:
                            AppTextStyles.bodyMedium
                                .copyWith(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Stack(
                    alignment: Alignment.center,

                    children: [

                      Container(
                        width: 330,
                        height: 330,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffF2F2F2),
                        ),
                      ),

                      Positioned(
                        right: -5,
                        top: 70,

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12),

                          child: Image.asset(
                            'assets/images/AB6AXuB8uQsExbpNn8GmR9tL3guxtwyshOcKINzFbmaP2294miT4yAN12n0ym47X0DXlhMzMXltoW6MFX0ZunKrSnl41xYsKcmtFbppG1i3aCZ_DJngPeShH5OWuFRMP5YpNoK7BvkNKrZl7cxNHW3zGy3l_1JThP3t_uv3wcOchVQhLCFVU7eYx9IXDv0G7yyFPVc3tb302mnZJQaw30O.png',

                            width: 120,
                            height: 190,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/The Phone Frame.png',
                        width: 260,
                        height: 360,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  const SizedBox(height: 45),

                  Text(
                    "Hand Recovery",

                    style: AppTextStyles.headlineLarge
                        .copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1C1C),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Ta'afi uses advanced camera\ntracking to guide your physical\nexercises with real-time precision.",

                    textAlign: TextAlign.center,

                    style:
                        AppTextStyles.bodyLarge.copyWith(
                      height: 1.8,
                      color: const Color(0xff414752),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      indicator(true),

                      const SizedBox(width: 8),

                      indicator(false),

                      const SizedBox(width: 8),

                      indicator(false),
                    ],
                  ),

                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              const Onboarding2(),
                        ),
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      height: 68,

                      decoration: BoxDecoration(
                        color: const Color(0xffB85C00),

                        borderRadius:
                            BorderRadius.circular(22),
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Text(
                            "Next",

                            style: AppTextStyles
                                .buttonText
                                .copyWith(
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Step 1 of 3: Technical Foundation",

                    style:
                        AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xff7A808A),
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator(bool active) {
    return Container(
      width: active ? 24 : 8,
      height: 8,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xffB85C00)
            : Colors.grey.shade300,

        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}