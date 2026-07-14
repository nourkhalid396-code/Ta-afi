import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/login.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;

  Future<void> _sendResetLink() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _message = 'الرجاء إدخال بريدك الإلكتروني';
        _isError = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _message = '';
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _message = 'تم إرسال رابط إعادة التعيين! تحقق من بريدك الإلكتروني.';
        _isError = false;
      });
    } on FirebaseAuthException {
      setState(() {
        _message = 'فشل إرسال رابط إعادة التعيين';
        _isError = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Login())),
                    child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffE5E7EB))),
                        child: const Icon(Icons.arrow_forward,
                            color: Color(0xff4B5563))),
                  ),
                  const Spacer(),
                  Text("تعافي",
                      style: AppTextStyles.headlineMedium.copyWith(
                          color: const Color(0xff934800),
                          fontWeight: FontWeight.bold,
                          fontSize: 28)),
                  const Spacer(),
                  const SizedBox(width: 48),
                ]),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 12))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                              color: const Color(0xffFAF5F0),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xffEAD7C2))),
                          child: const Icon(Icons.lock_reset,
                              color: Color(0xff934800), size: 28)),
                      const SizedBox(height: 36),
                      Text("نسيت كلمة المرور؟",
                          style: AppTextStyles.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: const Color(0xff1F2328))),
                      const SizedBox(height: 14),
                      Text(
                          "لا تقلق، هذا يحدث. أدخل بريدك\nالإلكتروني وسنرسل لك رابطاً\nآمناً لإعادة تعيين الوصول.",
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xff5B6472),
                              height: 1.8,
                              fontSize: 16)),
                      const SizedBox(height: 36),
                      Text("البريد الإلكتروني",
                          style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff414752))),
                      const SizedBox(height: 12),
                      Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xffD8DCE2))),
                        child: Row(children: [
                          const Icon(Icons.mail_outline,
                              color: Color(0xff6B7280)),
                          const SizedBox(width: 14),
                          Expanded(
                              child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "name@example.com",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500)))),
                        ]),
                      ),
                      if (_message.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(_message,
                            style: TextStyle(
                                color: _isError
                                    ? Colors.red
                                    : const Color(0xff0D6C1E),
                                fontSize: 14))
                      ],
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _isLoading ? null : _sendResetLink,
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: const Color(0xffA85B06),
                              borderRadius: BorderRadius.circular(22)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2)
                                    : Text("إرسال رابط إعادة التعيين",
                                        style: AppTextStyles.buttonText
                                            .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                if (!_isLoading) ...[
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_back,
                                      color: Colors.white, size: 22)
                                ],
                              ]),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                          child: TextButton.icon(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Login())),
                        icon: const Icon(Icons.arrow_forward,
                            size: 18, color: Color(0xff6B7280)),
                        label: Text("العودة لتسجيل الدخول",
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xff4B5563),
                                fontWeight: FontWeight.w600)),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Text("ملاذ رقمي © 2024",
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xffA1A1AA),
                        letterSpacing: 2,
                        fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
