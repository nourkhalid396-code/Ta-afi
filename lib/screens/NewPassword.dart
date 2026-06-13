import 'package:flutter/material.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/login.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Column(
        children: [
          // Top Brown Section
          Container(
            width: double.infinity,
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFF934800),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.accessibility_new,
                    color: Color(0xFF005FAF),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ta’afi',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -18),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      const Text(
                        'Create New Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Password Field
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E9E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF7A7F8A),
                            ),
                            hintText: 'Create Password',
                            hintStyle: TextStyle(
                              color: Color(0xFF7A7F8A),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Confirm Password Field
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9E9E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Color(0xFF7A7F8A),
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                              color: Color(0xFF7A7F8A),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Create Button
                     SizedBox(
                      width: double.infinity,
                       height: 64,
                       child: DecoratedBox(
                        decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                           begin: Alignment.centerLeft,
                           end: Alignment.centerRight,
                           colors: [
                            Color(0xFF934800), 
                             Color(0xFFB85C00), 
                             ],
                            ),
                            boxShadow: const [
                             BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                             ),
                            ],
                           ),
                          child: ElevatedButton(
                           onPressed: () {
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                             builder: (context) => const Login(),
                           ),
                          );
                         },
                         style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         shadowColor: Colors.transparent,
                         shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                        ),
                       ),
                       child: const Text(
                         'Create',
                       style: TextStyle(
                        fontSize: 28,
                         fontWeight: FontWeight.w700,
                          color: Colors.white,
                         ),
                        ),
                       ),
                      ),
                     ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}