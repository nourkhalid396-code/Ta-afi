import 'package:flutter/material.dart';
import 'package:my_app/screens/onboarding3.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/login.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
            stops: [0.0, 0.30, 1.0],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const SizedBox(height: 30),

                  Center(
                    child: Container(
                      width: 300,
                      height: 300,

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),

                      child: Image.asset(
                        'assets/images/brain.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  RichText(
                    text: TextSpan(
                      children: [

                        TextSpan(
                          text: "Cognitive\n",
                          style: AppTextStyles
                              .headlineLarge
                              .copyWith(
                            color:
                                const Color(0xff1A1C1C),
                            fontSize: 40,
                            fontWeight:
                                FontWeight.bold,
                            height: 1.2,
                          ),
                        ),

                        TextSpan(
                          text: "Strength",
                          style: AppTextStyles
                              .headlineLarge
                              .copyWith(
                            color:
                                const Color(0xffB85C00),
                            fontSize: 40,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Sharpen your mind with\n"
                    "interactive games specifically\n"
                    "designed to improve memory,\n"
                    "focus, and executive function\n"
                    "during your recovery.",

                    style:
                        AppTextStyles.bodyLarge.copyWith(
                      height: 1.8,
                      color:
                          const Color(0xff414752),
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [

                      indicator(false),

                      const SizedBox(width: 8),

                      indicator(true),

                      const SizedBox(width: 8),

                      indicator(false),
                    ],
                  ),

                  const SizedBox(height: 50),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const Onboarding3(),
                        ),
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      height: 64,

                      decoration: BoxDecoration(
                        color:
                            const Color(0xffB85C00),

                        borderRadius:
                            BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.08),
                            blurRadius: 12,
                            offset:
                                const Offset(0, 6),
                          ),
                        ],
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
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  GestureDetector(
                   onTap: () {
                    Navigator.pushReplacement(
                      context,
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                     ),
                    );
                   },
                  child: Center(
                    child: Text(
                      "Skip for now",

                      style:
                          AppTextStyles.bodyMedium
                              .copyWith(
                        fontWeight:
                            FontWeight.w600,
                        color:
                            const Color(0xff414752),
                      ),
                    ),
                  ),
                ),
                  const SizedBox(height: 34),
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
      width: active ? 26 : 8,
      height: 6,

      decoration: BoxDecoration(
        color: active
            ? const Color(0xffB85C00)
            : Colors.grey.shade300,

        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}