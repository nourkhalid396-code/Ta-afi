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
  String _userName = 'User';
  int _totalMinutes = 0;
  int _streak = 0;
  int _totalSessions = 0;

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
          _userName = userDoc['fullName'] ?? 'User';
          _streak = userDoc['streak'] ?? 0;
        });
      }

      QuerySnapshot sessions = await FirebaseFirestore.instance
          .collection('sessions')
          .where('userId', isEqualTo: uid)
          .get();

      int totalSeconds = 0;
      for (var doc in sessions.docs) {
        totalSeconds += (doc['durationSeconds'] as int? ?? 0);
      }

      setState(() {
        _totalSessions = sessions.docs.length;
        _totalMinutes = (totalSeconds / 60).round();
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen())),
                        child: const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/Avatar8.png')),
                      ),
                      const Spacer(),
                      const Text("Ta'afi",
                          style: TextStyle(
                              color: Color(0xffF26A21),
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ExerciseReminder())),
                        child: const Icon(Icons.notifications_none,
                            color: Color(0xff4A4A4A), size: 28),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Your Weekly\n",
                              style: TextStyle(
                                  color: Color(0xff1E1E1E),
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2)),
                          TextSpan(
                              text: "Achievement",
                              style: TextStyle(
                                  color: const Color(0xff934800),
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        "You improved by ${_recoveryRate.toInt()}% this week! Your\nconsistency is paving the way for a full\nrecovery.",
                        style: const TextStyle(
                            color: Color(0xff414752),
                            fontSize: 16,
                            height: 1.6)),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      height: 250,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color(0xffF3F1EF),
                          borderRadius: BorderRadius.circular(26)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("ACTIVITY LEVEL",
                                        style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: 1.2,
                                            color: Color(0xff717783),
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(height: 6),
                                    Text("Last 7 Days",
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222))),
                                  ]),
                              const Spacer(),
                              Row(children: [
                                Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffB55A13),
                                        shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffE6CBB6),
                                        shape: BoxShape.circle)),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        3,
                                        (index) => Container(
                                            height: 1,
                                            color: Colors.grey.shade300))),
                                Center(
                                    child: CustomPaint(
                                        size: const Size(double.infinity, 100),
                                        painter: GraphPainter())),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("MON"),
                                Text("TUE"),
                                Text("WED"),
                                Text("THU"),
                                Text("FRI"),
                                Text("SAT"),
                                Text("SUN")
                              ]),
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
                                borderRadius: BorderRadius.circular(24)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.timer_outlined,
                                      color: Color(0xffB55A13)),
                                  const SizedBox(height: 16),
                                  Text("$_totalMinutes",
                                      style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text("Minutes Active",
                                      style: TextStyle(
                                          color: Color(0xff723600),
                                          fontSize: 14)),
                                ]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                                color: const Color(0xffD9E4FF),
                                borderRadius: BorderRadius.circular(24)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      color: Color(0xff3366CC)),
                                  const SizedBox(height: 16),
                                  Text("${_recoveryRate.toInt()}%",
                                      style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text("Recovery Rate",
                                      style: TextStyle(
                                          color: Color(0xff004786),
                                          fontSize: 14)),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(children: const [
                      Text("Badges",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("View All",
                          style: TextStyle(
                              color: Color(0xffB55A13),
                              fontWeight: FontWeight.w600))
                    ]),
                    const SizedBox(height: 18),
                    badgeCard(
                        color: const Color(0xffFFE2D2),
                        icon: Icons.local_fire_department,
                        iconColor: const Color(0xffF08B52),
                        title: "$_streak Day Streak",
                        subtitle:
                            "Consistent movement for ${_streak > 0 ? _streak : 'three'} consecutive days."),
                    const SizedBox(height: 16),
                    badgeCard(
                        color: const Color(0xff0066C9),
                        icon: Icons.workspace_premium,
                        iconColor: Colors.white,
                        title: "Consistency King",
                        subtitle:
                            "Completed every scheduled\nmorning exercise this week."),
                    const SizedBox(height: 16),
                    Opacity(
                        opacity: 0.45,
                        child: badgeCard(
                            color: const Color(0xffD9DCE5),
                            icon: Icons.lock_outline,
                            iconColor: Colors.white,
                            title: "Marathoner",
                            subtitle:
                                "${5 - _totalSessions > 0 ? 5 - _totalSessions : 0} sessions to go to unlock this\nachievement.")),
                    const SizedBox(height: 30),
                    Container(
                      height: 82,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeDashboard()),
                                    (route) => false),
                                child: bottomItem(Icons.home, "Home", false)),
                            GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const PhysicalRehabExercises())),
                                child: bottomItem(Icons.back_hand_outlined,
                                    "Exercises", false)),
                            GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CognitiveGame())),
                                child: bottomItem(
                                    Icons.psychology_outlined, "Games", false)),
                            GestureDetector(
                                onTap: () {},
                                child: bottomItem(
                                    Icons.auto_graph, "Progress", true)),
                          ]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget badgeCard(
      {required Color color,
      required IconData icon,
      required Color iconColor,
      required String title,
      required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Row(children: [
        Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor)),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                  color: Color(0xff777777), fontSize: 13, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget bottomItem(IconData icon, String title, bool active) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: active ? const EdgeInsets.all(12) : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: active ? const Color(0xffF7E2D3) : Colors.transparent,
              borderRadius: BorderRadius.circular(18)),
          child: Icon(icon,
              color:
                  active ? const Color(0xffC16A28) : const Color(0xff8A8A8A))),
      const SizedBox(height: 6),
      Text(title,
          style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xffC16A28) : const Color(0xff8A8A8A),
              fontWeight: active ? FontWeight.bold : FontWeight.w500)),
    ]);
  }
}

class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffD6C1B0)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4,
        size.width * 0.4, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.75,
        size.width * 0.8, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.9, 0, size.width, size.height * 0.15);
    canvas.drawPath(path, paint);
    final dotPaint = Paint()..color = const Color(0xffB55A13);
    canvas.drawCircle(Offset(size.width, size.height * 0.15), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
