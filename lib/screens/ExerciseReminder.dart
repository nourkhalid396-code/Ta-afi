import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/PhysicalRehabExercises.dart';
import 'package:my_app/screens/ProfileScreen.dart';

class ExerciseReminder extends StatefulWidget {
  const ExerciseReminder({super.key});
  @override
  State<ExerciseReminder> createState() => _ExerciseReminderState();
}

class _ExerciseReminderState extends State<ExerciseReminder> {
  bool notificationsEnabled = true;
  bool _isLoading = false;

  // أيام الأسبوع
  List<bool> selectedDays = [true, false, true, false, true, false, false];
  final List<String> dayLabels = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];

  // ✅ الجلسة الصباحية
  int morningHour = 9;
  int morningMinute = 0;
  bool morningEnabled = true;

  // ✅ الجلسة المسائية
  int eveningHour = 6;
  int eveningMinute = 0;
  bool eveningEnabled = true;

  Future<void> _saveSchedule() async {
    setState(() => _isLoading = true);
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'settings.notifications': notificationsEnabled,
      });

      List<int> activeDays = [];
      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) activeDays.add(i);
      }

      // ✅ حفظ الجلسة الصباحية
      if (morningEnabled) {
        await FirebaseFirestore.instance.collection('schedules').add({
          'userId': uid,
          'days': activeDays,
          'hour': morningHour,
          'minute': morningMinute,
          'period': 'AM',
          'sessionType': 'morning',
          'time':
              '${morningHour.toString().padLeft(2, '0')}:${morningMinute.toString().padLeft(2, '0')} AM',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // ✅ حفظ الجلسة المسائية
      if (eveningEnabled) {
        await FirebaseFirestore.instance.collection('schedules').add({
          'userId': uid,
          'days': activeDays,
          'hour': eveningHour,
          'minute': eveningMinute,
          'period': 'PM',
          'sessionType': 'evening',
          'time':
              '${eveningHour.toString().padLeft(2, '0')}:${eveningMinute.toString().padLeft(2, '0')} PM',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم حفظ الجدول بنجاح!'),
            backgroundColor: Color(0xff934800),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      bottomNavigationBar: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeDashboard()),
                (route) => false,
              ),
              child: navItem(
                  icon: Icons.home_outlined, title: "الرئيسية", active: false),
            ),
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const PhysicalRehabExercises()),
                (route) => false,
              ),
              child: navItem(
                  icon: Icons.favorite_border, title: "التأهيل", active: false),
            ),
            navItem(
                icon: Icons.notifications_outlined,
                title: "التنبيهات",
                active: true),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              child: navItem(
                  icon: Icons.person_outline,
                  title: "الملف الشخصي",
                  active: false),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          size: 16, color: Color(0xffC2410C)),
                      const SizedBox(width: 8),
                      Text("تذكيرات التمارين",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xffC2410C),
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 34),
                Text("حدّدي جدولك",
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: const Color(0xff1A1C1C),
                    )),
                const SizedBox(height: 8),
                Text("اختاري أوقات التعافي الصباحية والمسائية.",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: const Color(0xff414752))),

                const SizedBox(height: 28),

                // 📅 أيام الأسبوع
                Text("الأيام المختارة",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xff414752),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      fontSize: 11,
                    )),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  children: List.generate(7, (i) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedDays[i] = !selectedDays[i]),
                      child: dayCircle(dayLabels[i], selectedDays[i]),
                    );
                  }),
                ),

                const SizedBox(height: 28),

                // 🌅 الجلسة الصباحية
                _buildSessionCard(
                  title: "🌅 الجلسة الصباحية",
                  subtitle: "ص",
                  hour: morningHour,
                  minute: morningMinute,
                  enabled: morningEnabled,
                  color: const Color(0xffFFF8F0),
                  borderColor: const Color(0xffF59E0B),
                  onToggle: (v) => setState(() => morningEnabled = v),
                  onHourUp: () =>
                      setState(() => morningHour = (morningHour % 12) + 1),
                  onHourDown: () => setState(() =>
                      morningHour = morningHour > 1 ? morningHour - 1 : 12),
                  onMinuteUp: () =>
                      setState(() => morningMinute = (morningMinute + 5) % 60),
                  onMinuteDown: () => setState(() => morningMinute =
                      morningMinute >= 5 ? morningMinute - 5 : 55),
                ),

                const SizedBox(height: 16),

                // 🌙 الجلسة المسائية
                _buildSessionCard(
                  title: "🌙 الجلسة المسائية",
                  subtitle: "م",
                  hour: eveningHour,
                  minute: eveningMinute,
                  enabled: eveningEnabled,
                  color: const Color(0xffF0F4FF),
                  borderColor: const Color(0xff6366F1),
                  onToggle: (v) => setState(() => eveningEnabled = v),
                  onHourUp: () =>
                      setState(() => eveningHour = (eveningHour % 12) + 1),
                  onHourDown: () => setState(() =>
                      eveningHour = eveningHour > 1 ? eveningHour - 1 : 12),
                  onMinuteUp: () =>
                      setState(() => eveningMinute = (eveningMinute + 5) % 60),
                  onMinuteDown: () => setState(() => eveningMinute =
                      eveningMinute >= 5 ? eveningMinute - 5 : 55),
                ),

                const SizedBox(height: 28),

                // 🔔 Notifications Toggle
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xffDCEBFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: AppColors.primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text("السماح\nبالإشعارات",
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              color: const Color(0xff1A1C1C),
                            )),
                      ),
                      Switch(
                        value: notificationsEnabled,
                        onChanged: (value) =>
                            setState(() => notificationsEnabled = value),
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xff934800),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ Consistency Card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xffDFF5D7),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            color: Color(0xff005312), size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            "الجلسات الصباحية والمسائية معاً\nتسرّع التعافي بنسبة 60%!",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xff005312),
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                // 💾 Save Button
                GestureDetector(
                  onTap: _isLoading ? null : _saveSchedule,
                  child: Container(
                    width: double.infinity,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xff934800),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text("احفظي جدولي",
                                style: AppTextStyles.buttonText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                        if (!_isLoading) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Session Card Widget
  Widget _buildSessionCard({
    required String title,
    required String subtitle,
    required int hour,
    required int minute,
    required bool enabled,
    required Color color,
    required Color borderColor,
    required Function(bool) onToggle,
    required VoidCallback onHourUp,
    required VoidCallback onHourDown,
    required VoidCallback onMinuteUp,
    required VoidCallback onMinuteDown,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text(title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1A1C1C),
                    fontSize: 16,
                  )),
              const Spacer(),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeThumbColor: Colors.white,
                activeTrackColor: borderColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ],
          ),

          if (enabled) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timePickerWidget(
                  value: hour.toString().padLeft(2, '0'),
                  onUp: onHourUp,
                  onDown: onHourDown,
                ),
                const SizedBox(width: 10),
                Text(":",
                    style: AppTextStyles.headlineLarge.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1C1C),
                    )),
                const SizedBox(width: 10),
                timePickerWidget(
                  value: minute.toString().padLeft(2, '0'),
                  onUp: onMinuteUp,
                  onDown: onMinuteDown,
                ),
                const SizedBox(width: 14),
                // AM/PM Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: borderColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget dayCircle(String day, bool active) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: active ? const Color(0xffB85C00) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(day,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xff1A1C1C),
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget timePickerWidget({
    required String value,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onUp,
          child: const Icon(Icons.keyboard_arrow_up, color: Color(0xff934800)),
        ),
        Container(
          width: 72,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(value,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1A1C1C),
                )),
          ),
        ),
        GestureDetector(
          onTap: onDown,
          child:
              const Icon(Icons.keyboard_arrow_down, color: Color(0xff934800)),
        ),
      ],
    );
  }

  Widget navItem({
    required IconData icon,
    required String title,
    required bool active,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xffF8E3CC) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon,
              size: 22,
              color:
                  active ? AppColors.primaryColor : AppColors.lightTextColor),
        ),
        const SizedBox(height: 5),
        Text(title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: active ? AppColors.primaryColor : AppColors.lightTextColor,
            )),
      ],
    );
  }
}
