import 'package:flutter/material.dart';
import 'package:my_app/screens/Homedashboard.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ForgetScreen.dart';
import 'package:my_app/screens/SignUp.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 18,
                ),

                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffE5E5E5),
                      width: 1.5,
                    ),
                  ),
                ),

                child: Center(
                  child: Text(
                    "Ta'afi",
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: const Color(0xffEA580C),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 38),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),

                child: Column(
                  children: [

                    RichText(
                      textAlign: TextAlign.center,

                      text: TextSpan(
                        children: [

                          TextSpan(
                            text: "Welcome to your\n",

                            style:
                                AppTextStyles.headlineLarge.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff1A1C1C),
                              height: 1.2,
                            ),
                          ),

                          TextSpan(
                            text: "Sanctuary",

                            style:
                                AppTextStyles.headlineLarge.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff934800),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "A restorative space for your\nrehabilitation journey. Let’s continue\nwhere you left off.",

                      textAlign: TextAlign.center,

                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xff5A5F6A),
                        height: 1.8,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 22,
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xffF5F4F4),

                  borderRadius: BorderRadius.circular(34),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Email Address",

                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 58,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "name@example.com",

                          hintStyle:
                              AppTextStyles.bodyLarge
                                  .copyWith(
                            color:
                                const Color(0xffC7C9D9),
                          ),

                          border: InputBorder.none,

                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),

                          suffixIcon: const Icon(
                            Icons.mail_outline,
                            color: Color(0xffC7C9D9),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      "Password",

                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 58,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          hintText: "••••••••",

                          hintStyle:
                              AppTextStyles.bodyLarge
                                  .copyWith(
                            color:
                                const Color(0xffC7C9D9),
                            letterSpacing: 2,
                          ),

                          border: InputBorder.none,

                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),

                          suffixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xffC7C9D9),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Align(
                     alignment: Alignment.centerRight,
                       child: GestureDetector(
                       onTap: () {
                        Navigator.push(
                        context,
                         MaterialPageRoute(
                          builder: (_) => const ForgetScreen(),
                          ),
                         );
                        },
                          child: Text(
                           "Forgot Password?",
                            style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff005FAF),
                            fontWeight: FontWeight.w600,
                            ),
                           ),
                          ),
                         ),

                    const SizedBox(height: 34),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const HomeDashboard(),
                          ),
                        );
                      },

                      child: Container(
                        width: double.infinity,
                        height: 66,

                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,

                            colors: [
                              Color(0xffB85C00),
                              Color(0xff934800),
                            ],
                          ),

                          borderRadius:
                              BorderRadius.circular(22),

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

                        child: Center(
                          child: Text(
                            "LOG IN",

                            style:
                                AppTextStyles.buttonText
                                    .copyWith(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 42),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Text(
                   "New to Ta'afi? ",
                 style: AppTextStyles.bodyLarge.copyWith(
                   color: AppColors.textColor,
                  ),
                 ),

                GestureDetector(
                 onTap: () {
                 Navigator.push(
                 context,
                MaterialPageRoute(
                 builder: (_) => const SignUp(),
               ),
              );
            },
               child: Text(
                "Create an Account",
               style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xff934800),
                 fontWeight: FontWeight.bold,
                ),
               ),
              ),
             ],
            ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}