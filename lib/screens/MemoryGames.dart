import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/OfflineSaveScreen.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/ExerciseReminder.dart';

class MemoryGames extends StatefulWidget {
  const MemoryGames({super.key});

  @override
  State<MemoryGames> createState() => _MemoryGamesState();
}

class _MemoryGamesState extends State<MemoryGames> {
  int _score = 240;
  int _timerSeconds = 105;
  int _completedSessions = 3;
  int _totalGoal = 5;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      QuerySnapshot sessions = await FirebaseFirestore.instance
          .collection('sessions')
          .where('userId', isEqualTo: uid)
          .get();
      setState(() => _completedSessions = sessions.docs.length);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveSession() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': 'memory_match',
        'completedAt': FieldValue.serverTimestamp(),
        'durationSeconds': 105 - _timerSeconds,
        'repsCompleted': 6,
        'accuracyScore': 85,
        'type': 'memory',
      });
      if (mounted)
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const OfflineSaveScreen()));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Row(children: [
                      const Icon(Icons.timer_outlined,
                          color: Color(0xffC2410C), size: 22),
                      const SizedBox(width: 8),
                      Text(
                          "${_timerSeconds ~/ 60}:${(_timerSeconds % 60).toString().padLeft(2, '0')}",
                          style: AppTextStyles.bodyLarge.copyWith(
                              color: const Color(0xff64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ]),
                    const Spacer(),
                    Text("Taafi",
                        style: AppTextStyles.headlineMedium.copyWith(
                            color: const Color(0xffC2410C),
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xffF7EFE8),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("Score: $_score",
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xffC2410C),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    Text("Memory Match",
                        style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1A1C1C),
                            fontSize: 24)),
                    const SizedBox(height: 10),
                    Text(
                        "Find the matching pairs to sharpen your\nfocus. Move gently and take your time.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff6B7280),
                            height: 1.7,
                            fontSize: 15)),
                    const SizedBox(height: 28),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      children: [
                        GestureDetector(
                            onTap: _saveSession,
                            child: gameCard(
                                borderColor: const Color(0xff934800),
                                icon: Icons.psychology_alt_outlined,
                                iconColor: const Color(0xff934800),
                                whiteCard: true)),
                        gameCard(),
                        gameCard(),
                        gameCard(
                            borderColor: const Color(0xff2F8635),
                            icon: Icons.healing_outlined,
                            iconColor: const Color(0xff2F8635),
                            whiteCard: true),
                        gameCard(),
                        gameCard(),
                        gameCard(),
                        gameCard(),
                        gameCard(
                            borderColor: const Color(0xff4D8DFF),
                            icon: Icons.favorite,
                            iconColor: const Color(0xff4D8DFF),
                            whiteCard: true),
                        gameCard(),
                        gameCard(
                            borderColor: const Color(0xffFF9D3D),
                            icon: Icons.star,
                            iconColor: const Color(0xffFF9D3D),
                            whiteCard: true),
                        gameCard(),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 24),
                      decoration: BoxDecoration(
                          color: const Color(0xffF1EEEE),
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(
                        children: [
                          Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                  color: Color(0xff9CF28E),
                                  shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(Icons.verified,
                                      color: Color(0xff0D6C1E), size: 30))),
                          const SizedBox(height: 24),
                          Text(
                              "Daily Goal: $_completedSessions/$_totalGoal Sessions",
                              style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1A1C1C),
                                  fontSize: 18)),
                          const SizedBox(height: 22),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                  value: _totalGoal > 0
                                      ? (_completedSessions / _totalGoal)
                                          .clamp(0.0, 1.0)
                                      : 0.0,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xffDDDDDD),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xff0D6C1E)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                    Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                          'assets/images/AB6AXuAu9MOIboX7znQw8D5Fxv6X7vzbmiKxCtQjFhtn91RaTQQ9ZmLhV9uVPfHeG7mtLYxFmJmUgGTbfV-sACUZoo3bDUNj9-syARtnDNA_i5ZEWyVsber5bVYVNXWMIm4N6eG-hz8vFbTY6P5-0-qxvDxP3wPMOG06ngNZchafqap-FVRqplJCcUTALSagf-Iq4j-R6AE2raQkz5FtVq.png',
                          height: 170,
                          fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            navItem(
                                icon: Icons.fitness_center,
                                title: "Exercise",
                                active: true),
                            navItem(
                                icon: Icons.show_chart,
                                title: "Progress",
                                active: false),
                            navItem(
                                icon: Icons.people_outline,
                                title: "Community",
                                active: false),
                            navItem(
                                icon: Icons.person_outline,
                                title: "Profile",
                                active: false),
                          ]),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gameCard(
      {bool whiteCard = false,
      Color? borderColor,
      IconData? icon,
      Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        color: whiteCard ? Colors.white : const Color(0xffD9E6FF),
        borderRadius: BorderRadius.circular(22),
        border: whiteCard ? Border.all(color: borderColor!, width: 1.6) : null,
      ),
      child: Center(
        child: whiteCard
            ? Icon(icon, color: iconColor, size: 34)
            : Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                    color: Color(0xffC7D7F7), shape: BoxShape.circle),
                child: const Icon(Icons.hexagon_outlined,
                    size: 22, color: Color(0xff8EA2CC))),
      ),
    );
  }

  Widget navItem(
      {required IconData icon, required String title, required bool active}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: active ? const EdgeInsets.all(14) : EdgeInsets.zero,
        decoration: BoxDecoration(
            color: active ? const Color(0xffF5E3CF) : Colors.transparent,
            borderRadius: BorderRadius.circular(18)),
        child: Icon(icon,
            size: 22,
            color: active ? const Color(0xff9A3412) : const Color(0xffA7AEC1)),
      ),
      const SizedBox(height: 6),
      Text(title,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  active ? const Color(0xff9A3412) : const Color(0xffA7AEC1))),
    ]);
  }
}
