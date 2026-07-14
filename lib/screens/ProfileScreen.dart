import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'مستخدمة';
  String _email = '';
  int _streak = 0;
  int _totalSessions = 0;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['fullName'] ?? 'مستخدمة';
          _email = userDoc['email'] ?? '';
          _streak = userDoc['streak'] ?? 0;
        });
      }

      QuerySnapshot sessions = await FirebaseFirestore.instance
          .collection('sessions')
          .where('userId', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      setState(() {
        _totalSessions = sessions.docs.length;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
  }

  // ✅ ربط بمشرف
  Future<void> _linkToAdmin(
      String code, Function(String) onError, VoidCallback onSuccess) async {
    if (code.trim().isEmpty) {
      onError('الرجاء إدخال الكود');
      return;
    }

    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      QuerySnapshot adminQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .where('adminCode', isEqualTo: code.trim().toUpperCase())
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        onError('❌ الكود غير صحيح، تأكدي منه وحاولي مرة أخرى');
        return;
      }

      String adminId = adminQuery.docs.first.id;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'linkedAdminId': adminId,
      });

      onSuccess();
    } catch (e) {
      print('Error linking to admin: $e');
      onError('حدث خطأ: $e');
    }
  }

  void _showLinkAdminSheet() {
    final TextEditingController codeController = TextEditingController();
    String? errorText;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ربط بمشرف',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أدخلي الكود اللي أعطاكِ إياه المشرف/الدكتور.',
                    style: TextStyle(color: Color(0xff6B7280), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xffECECEC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: codeController,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'مثال: 0UJIP1',
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            setSheetState(() {
                              isLoading = true;
                              errorText = null;
                            });
                            await _linkToAdmin(
                              codeController.text,
                              (msg) {
                                setSheetState(() {
                                  errorText = msg;
                                  isLoading = false;
                                });
                              },
                              () {
                                Navigator.pop(context);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            '✅ تم ربط حسابك بالمشرف بنجاح!'),
                                        backgroundColor: Color(0xff934800),
                                      ),
                                    );
                                  }
                                });
                              },
                            );
                          },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF934800),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'ربط الحساب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🎨 الهيدر البرتقالي
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF934800), Color(0xFFB45309)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Row(
                              children: [
                                Icon(
                                  Icons.back_hand_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "تعافي",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF934800),
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildStatRow(
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          title: 'التتابع',
                          value: '$_streak يوم',
                        ),
                        const Divider(height: 32),
                        _buildStatRow(
                          icon: Icons.emoji_events,
                          iconColor: const Color(0xFF934800),
                          title: 'إجمالي الجلسات',
                          value: '$_totalSessions',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4, bottom: 12),
                      child: Text(
                        'الإعدادات',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingTile(
                            icon: Icons.notifications_outlined,
                            title: 'الإشعارات',
                            trailing: Switch(
                              value: _notifications,
                              onChanged: (v) =>
                                  setState(() => _notifications = v),
                              activeTrackColor: const Color(0xFF934800),
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'اختر اللغة',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF934800),
                                        ),
                                        title: const Text('العربية'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.circle_outlined,
                                          color: Colors.grey,
                                        ),
                                        title: const Text('English'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: _buildSettingTile(
                              icon: Icons.language,
                              title: 'اللغة',
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'العربية',
                                    style: TextStyle(
                                      color: const Color(0xFF934800),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_left,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          GestureDetector(
                            onTap: _showLinkAdminSheet,
                            child: _buildSettingTile(
                              icon: Icons.link,
                              title: 'ربط بمشرف',
                              trailing: const Icon(
                                Icons.chevron_left,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تعديل الملف الشخصي - قريباً!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: _buildSettingTile(
                              icon: Icons.edit,
                              title: 'تعديل الملف الشخصي',
                              trailing: const Icon(
                                Icons.chevron_left,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: _logout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1C1C),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF934800),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 22),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1C1C),
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}
