import 'package:flutter/material.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/NewPassword.dart';

class OTP extends StatelessWidget {
  const OTP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F5F4),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            children: [

              const SizedBox(height: 12),

              // BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xff934800),
                    size: 28,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ICON
              Container(
                width: 96,
                height: 96,

              decoration: BoxDecoration(
                color: Colors.white,
               borderRadius: BorderRadius.circular(16),
                boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                   blurRadius: 12,
                    offset: const Offset(0, 5),
                    ),
                   ],
                  ),

                child: const Icon(
                  Icons.lock_person,
                    color: Color(0xff934800),
                  size: 46,
                ),
              ),

              const SizedBox(height: 34),

              // TITLE
              Text(
                "Verify Your Email",
                textAlign: TextAlign.center,

                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1C1C),
                ),
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              Text(
                "Enter the 4-digit code sent to your email\naddress.",
                textAlign: TextAlign.center,

                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xff5A5F6A),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              // OTP BOXES
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  otpBox(active: true),

                  otpBox(),

                  otpBox(),

                  otpBox(),
                ],
              ),

              const SizedBox(height: 40),

              // TIMER
              RichText(
                text: TextSpan(
                  children: [

                    TextSpan(
                      text: "Code expires in ",
                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        color:
                            const Color(0xff4B5563),
                      ),
                    ),

                    TextSpan(
                      text: "00:54",
                      style:
                          AppTextStyles.bodyLarge.copyWith(
                        color:
                            const Color(0xff934800),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Resend Code",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xffD1D5DB),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              // VERIFY BUTTON
              GestureDetector(
               onTap: () {
                Navigator.push(
                 context,
                MaterialPageRoute(
                 builder: (context) => const NewPassword(),
                ),
               );
              },
               child: Container(
                width: double.infinity,
                height: 64,

                decoration: BoxDecoration(             
                 gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                   end: Alignment.centerRight,
                   colors: [
                   Color(0xff934800),
                   Color(0xffB85C00),
                  ],
                 ),

                  borderRadius:
                      BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Center(
                  child: Text(
                    "VERIFY",

                    style:
                        AppTextStyles.buttonText.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
             ),

              const SizedBox(height: 60),
           ],
          ),
        ),
      ),
    );
  }
   

  Widget otpBox({bool active = false}) {
    return Container(
      width: 68,
      height: 82,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: active
              ? const Color(0xff934800)
              : Colors.transparent,
          width: 1.5,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}