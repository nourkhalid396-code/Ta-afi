import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_app/theme/app_theme.dart';

class AdminInviteCode extends StatefulWidget {
  const AdminInviteCode({super.key});

  @override
  State<AdminInviteCode> createState() => _AdminInviteCodeState();
}

class _AdminInviteCodeState extends State<AdminInviteCode> {
  String _code = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrGenerateCode();
  }

  Future<void> _loadOrGenerateCode() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      String? existingCode = doc.data() != null
          ? (doc.data() as Map<String, dynamic>)['adminCode']
          : null;

      if (existingCode != null && existingCode.isNotEmpty) {
        setState(() {
          _code = existingCode;
          _isLoading = false;
        });
      } else {
        // ✅ نولّد كود جديد من أول 6 أحرف من الـ UID (بأحرف كبيرة)
        String newCode = uid.substring(0, 6).toUpperCase();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'adminCode': newCode});

        setState(() {
          _code = newCode;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error generating code: $e');
      setState(() => _isLoading = false);
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الكود ✅'),
        backgroundColor: Color(0xff934800),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ⬅️ زر الرجوع
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Color(0xff934800)),
                    const SizedBox(width: 8),
                    Text("كود الربط",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xff934800),
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFEDD5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.link,
                        color: Color(0xff934800),
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "كود الربط الخاص بك",
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: const Color(0xff1A1C1C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "شاركي هاد الكود مع مرضاك ليتمكنوا\nمن ربط حساباتهم بحسابك ومتابعة\nتقدمهم.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xff414752),
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 📦 صندوق الكود
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: Color(0xff934800),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _copyCode,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xff934800).withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ✅ الكود يضل LTR (أرقام/أحرف لاتينية)
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                _code,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xff934800),
                                  letterSpacing: 6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "اضغطي للنسخ",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffDFF5D7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xff005312), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "المريض بيدخل هاد الكود من شاشة \"ربط بمشرف\" بحسابه.",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xff005312),
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
