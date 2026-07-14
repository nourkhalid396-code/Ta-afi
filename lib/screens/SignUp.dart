import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'كلمتا المرور غير متطابقتين');
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'الرجاء إدخال اسمك');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': '',
        'streak': 0,
        'lastActive': FieldValue.serverTimestamp(),
        'settings': {
          'language': 'ar',
          'notifications': true,
          'theme': 'light',
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = 'البريد الإلكتروني مستخدم من قبل';
            break;
          case 'invalid-email':
            _errorMessage = 'البريد الإلكتروني غير صالح';
            break;
          case 'weak-password':
            _errorMessage = 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
            break;
          default:
            _errorMessage = 'فشل إنشاء الحساب، حاول مرة أخرى';
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
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
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.accessibility_new,
                        color: Color(0xff005FAF),
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "تعافي",
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "أنشئ حسابك",
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1A1C1C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "ابدأ رحلة تعافيك اليوم.",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff6B7280),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 38),
                        buildTextField(
                          controller: _nameController,
                          icon: Icons.person_outline,
                          hint: "الاسم الكامل",
                        ),
                        const SizedBox(height: 24),
                        buildTextField(
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          hint: "البريد الإلكتروني",
                          isLtr: true,
                        ),
                        const SizedBox(height: 24),
                        buildTextField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hint: "أنشئ كلمة مرور",
                          obscure: true,
                          isLtr: true,
                        ),
                        const SizedBox(height: 24),
                        buildTextField(
                          controller: _confirmPasswordController,
                          icon: Icons.lock_outline,
                          hint: "تأكيد كلمة المرور",
                          obscure: true,
                          isLtr: true,
                        ),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14)),
                        ],
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: _isLoading ? null : _signUp,
                          child: Container(
                            width: double.infinity,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Color(0xFF934800),
                                  Color(0xFFB85C00),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      "إنشاء حساب",
                                      style: AppTextStyles.buttonText.copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 46),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xff6B7280),
                                height: 1.7,
                              ),
                              children: const [
                                TextSpan(
                                    text: "بإنشائك للحساب، فأنت توافق على "),
                                TextSpan(
                                  text: "الشروط",
                                  style: TextStyle(color: Color(0xff005FAF)),
                                ),
                                TextSpan(text: " و\n"),
                                TextSpan(
                                  text: "سياسة الخصوصية.",
                                  style: TextStyle(color: Color(0xff005FAF)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Login()),
                              );
                            },
                            child: Text(
                              "لديك حساب بالفعل؟ سجّل الدخول.",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: const Color(0xff005FAF),
                                fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    bool isLtr = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xff7C8393)),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xff7C8393),
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
