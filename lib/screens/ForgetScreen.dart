import 'package:flutter/material.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/OTP.dart';
import 'package:my_app/screens/login.dart'; 

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                    onTap: () {
                     Navigator.pushReplacement(
                      context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                     ),
                   );
                 },
                 child: Container(
                 width: 48,
                 height: 48,
                 decoration: BoxDecoration(
                  color: Colors.white,
                   shape: BoxShape.circle,
                    border: Border.all(
                     color: const Color(0xffE5E7EB),
                     ),
                   ),
                  child: const Icon(
                   Icons.arrow_back,
                   color: Color(0xff4B5563),
                  ),
                 ),
                ),
                    const Spacer(),
                    Text(
                      "Ta'afi",
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: const Color(0xff934800),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 50),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 34,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ICON
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xffFAF5F0),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xffEAD7C2),
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          color: Color(0xff934800),
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 36),

                      Text(
                        "Forgot Password?",
                        style: AppTextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: const Color(0xff1F2328),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Don't worry, it happens. Enter your\nemail and we'll send you a secure\nlink to reset your access.",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xff5B6472),
                          height: 1.8,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 36),

                      Text(
                        "Email Address",
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff414752),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xffD8DCE2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mail_outline,
                              color: Color(0xff6B7280),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "name@example.com",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      //Send Reset Link
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OTP(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xffA85B06),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Send Reset Link",
                                style: AppTextStyles.buttonText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      //Return to Login
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xff6B7280),
                          ),
                          label: Text(
                            "Return to Login",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xff4B5563),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                Text(
                  "DIGITAL SANCTUARY © 2024",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xffA1A1AA),
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
