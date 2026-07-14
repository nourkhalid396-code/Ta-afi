import 'package:flutter/material.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/theme/app_theme.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/progress.png',
                      width: 290,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "شارك تقدمك",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: const Color(0xff1A1C1C),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "عزّز رحلة تعافيك من خلال تتبع\n"
                  "التحسّن اليومي ومشاركة النتائج\n"
                  "بأمان مع مقدّم الرعاية الصحية\n"
                  "للحصول على رؤى أفضل.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    height: 1.9,
                    color: const Color(0xff414752),
                  ),
                ),
                const SizedBox(height: 34),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    indicator(false),
                    const SizedBox(width: 8),
                    indicator(false),
                    const SizedBox(width: 8),
                    indicator(true),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Login(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xffB85C00),
                          Color(0xff934800),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ابدأ الآن",
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "الخطوة 3 من 3",
                  style: AppTextStyles.bodyMedium.copyWith(
                    letterSpacing: 3,
                    color: const Color(0xff7A808A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator(bool active) {
    return Container(
      width: active ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xffB85C00) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
