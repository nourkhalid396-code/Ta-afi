import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/PhysicalRehabExercises.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/ExerciseReminder.dart';

class ProgressAchievements extends StatefulWidget {
  const ProgressAchievements({super.key});

  @override
  State<ProgressAchievements> createState() => _ProgressAchievementsState();
}

class _ProgressAchievementsState extends State<ProgressAchievements> {
  String _userName = 'مستخدمة';
  int _totalMinutes = 0;
  int _streak = 0;
  int _totalSessions = 0;
  List<int> _weeklyData = [0, 0, 0, 0, 0, 0, 0];

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
          _streak = userDoc['streak'] ?? 0;
        });
      }

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      QuerySnapshot sessions = await FirebaseFirestore.instance
          .collection('sessions')
          .where('userId', isEqualTo: uid)
          .where('status', isEqualTo: 'completed') // ← الجديد
          .get();
      int totalSeconds = 0;
      for (var doc in sessions.docs) {
        totalSeconds += (doc['durationSeconds'] as int? ?? 0);
      }

      // نحسب بيانات الأسبوع
      List<int> weeklyData = [0, 0, 0, 0, 0, 0, 0];
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      for (var doc in sessions.docs) {
        Timestamp? completedAt = doc['completedAt'] as Timestamp?;
        if (completedAt != null) {
          DateTime sessionDate = completedAt.toDate();
          if (sessionDate
              .isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
            int dayIndex = sessionDate.weekday - 1;
            if (dayIndex >= 0 && dayIndex < 7) {
              weeklyData[dayIndex]++;
            }
          }
        }
      }

      setState(() {
        _totalSessions = sessions.docs.length;
        _totalMinutes = (totalSeconds / 60).round();
        _weeklyData = weeklyData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  double get _recoveryRate {
    if (_totalSessions == 0) return 0;
    return ((_totalSessions * 10).clamp(0, 100)).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xffFFEDD5), width: 2),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileScreen())),
                            child: ClipOval(
                              child: Image.asset('assets/images/Avatar1 .png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text("تعافي",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff934800),
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ExerciseReminder())),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Color(0xff934800),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text("مرحباً، $_userName",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A1C1C),
                        )),
                    const SizedBox(height: 8),
                    const Text(
                      "تقدّم تعافيك يبدو رائعاً!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff414752),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFEDD5),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("التقدم الأسبوعي",
                              style: const TextStyle(
                                color: Color(0xff934800),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                fontSize: 12,
                              )),
                          const SizedBox(height: 18),
                          const Text("هذا الأسبوع",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1A1C1C),
                              )),
                          const SizedBox(height: 14),
                          Text(
                            "أكملتِ $_totalSessions جلسة هذا الأسبوع. واصلي!",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff414752),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // ✅ لفيناها بـ Directionality LTR عشان الرسمة
                          // والأيام تحتها يتطابقوا صح دايماً
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                  3,
                                                  (index) => Container(
                                                      height: 1,
                                                      color: Colors
                                                          .grey.shade300)),
                                            ),
                                            Center(
                                              child: CustomPaint(
                                                size: const Size(
                                                    double.infinity, 100),
                                                painter: GraphPainter(
                                                    weeklyData: _weeklyData),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("إثنين"),
                                    Text("ثلاثاء"),
                                    Text("أربعاء"),
                                    Text("خميس"),
                                    Text("جمعة"),
                                    Text("سبت"),
                                    Text("أحد"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xffF4D6C3),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.timer_outlined,
                                    color: Color(0xffB55A13)),
                                const SizedBox(height: 16),
                                Text("$_totalMinutes",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1A1C1C),
                                    )),
                                const Text("إجمالي الدقائق",
                                    style: TextStyle(
                                      color: Color(0xff414752),
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xffD6E8D3),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.local_fire_department_outlined,
                                    color: Color(0xff0D6C1E)),
                                const SizedBox(height: 16),
                                Text("$_streak",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1A1C1C),
                                    )),
                                const Text("أيام متتالية",
                                    style: TextStyle(
                                      color: Color(0xff414752),
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("معدل التعافي",
                              style: const TextStyle(
                                color: Color(0xff934800),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                fontSize: 12,
                              )),
                          const SizedBox(height: 18),
                          const Text("التقدم الإجمالي",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1A1C1C),
                              )),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: _recoveryRate / 100,
                              minHeight: 8,
                              backgroundColor: const Color(0xffE5E7EB),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xff934800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "معدل التعافي ${_recoveryRate.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff414752),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HomeDashboard())),
              child: navItem(icon: Icons.home, label: "الرئيسية"),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PhysicalRehabExercises())),
              child: navItem(icon: Icons.back_hand_outlined, label: "التمارين"),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CognitiveGame())),
              child: navItem(icon: Icons.psychology_outlined, label: "الألعاب"),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: navItem(
                  icon: Icons.auto_graph, label: "التقدم", active: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(
      {required IconData icon, required String label, bool active = false}) {
    return Container(
      width: 82,
      height: 58,
      decoration: BoxDecoration(
        color: active ? const Color(0xffFFEDD5) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color:
                  active ? const Color(0xff9A3412) : const Color(0xffA1A1AA)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    active ? const Color(0xff9A3412) : const Color(0xffA1A1AA),
              )),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<int> weeklyData;

  GraphPainter({required this.weeklyData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffD6C1B0)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // نرسم خط حسب البيانات الحقيقية
    if (weeklyData.isNotEmpty && weeklyData.any((d) => d > 0)) {
      double maxData = weeklyData.reduce((a, b) => a > b ? a : b).toDouble();
      if (maxData == 0) maxData = 1;

      double stepX = size.width / (weeklyData.length - 1);

      for (int i = 0; i < weeklyData.length; i++) {
        double x = i * stepX;
        double y = size.height -
            (weeklyData[i] / maxData * size.height * 0.8) -
            (size.height * 0.1);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    } else {
      // خط افتراضي لو ما فيه بيانات
      path.moveTo(0, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.4,
          size.width * 0.4, size.height * 0.55);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.75,
          size.width * 0.8, size.height * 0.2);
      path.quadraticBezierTo(
          size.width * 0.9, 0, size.width, size.height * 0.15);
    }

    canvas.drawPath(path, paint);

    // نرسم النقاط
    final dotPaint = Paint()..color = const Color(0xffB55A13);
    if (weeklyData.isNotEmpty) {
      double maxData = weeklyData.reduce((a, b) => a > b ? a : b).toDouble();
      if (maxData == 0) maxData = 1;
      double stepX = size.width / (weeklyData.length - 1);

      for (int i = 0; i < weeklyData.length; i++) {
        double x = i * stepX;
        double y = size.height -
            (weeklyData[i] / maxData * size.height * 0.8) -
            (size.height * 0.1);
        canvas.drawCircle(Offset(x, y), 6, dotPaint);
      }
    } else {
      canvas.drawCircle(Offset(size.width, size.height * 0.15), 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
