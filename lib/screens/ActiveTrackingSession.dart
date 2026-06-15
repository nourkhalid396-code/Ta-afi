import 'package:flutter/material.dart';
import 'package:my_app/screens/OfflineSaveScreen.dart';
import 'package:my_app/screens/SuccessScreen.dart';
import 'package:my_app/theme/app_theme.dart';

class ActiveTrackingSession extends StatelessWidget {
  const ActiveTrackingSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hand5.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.12),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.back_hand_outlined,
                              color: Color(0xff934800),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Ta'afi",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: const Color(0xff934800),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 158,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ACCURACY SCORE",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xff414752),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "85%",
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: const Color(0xff934800),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Extend your fingers\nfully",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: const Color(0xff1A1C1C),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const LinearProgressIndicator(
                            value: 0.68,
                            minHeight: 8,
                            backgroundColor: Color(0xffE5E7EB),
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xff934800),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Hold for 3 seconds",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff414752),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controlButton(
                        icon: Icons.pause_outlined,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OfflineSaveScreen(), // ← تغيير هنا
                            ),
                          );
                        },
                        child: Container(
                          width: 180,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xff934800),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "End\nsession",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      controlButton(
                        icon: Icons.volume_up_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget controlButton({
    required IconData icon,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.textColor,
        size: 30,
      ),
    );
  }
}
