import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/OfflineSaveScreen.dart';
import 'package:my_app/theme/app_theme.dart';

class MemoryGames extends StatefulWidget {
  const MemoryGames({super.key});
  @override
  State<MemoryGames> createState() => _MemoryGamesState();
}

class _MemoryGamesState extends State<MemoryGames> {
  int _score = 0;
  int _timerSeconds = 120;
  int _completedSessions = 0;
  final int _totalGoal = 5;
  Timer? _timer;
  bool _gameOver = false;

  // بيانات البطاقات
  final List<IconData> _icons = [
    Icons.psychology_alt_outlined,
    Icons.psychology_alt_outlined,
    Icons.healing_outlined,
    Icons.healing_outlined,
    Icons.favorite,
    Icons.favorite,
    Icons.star,
    Icons.star,
    Icons.back_hand_outlined,
    Icons.back_hand_outlined,
    Icons.fitness_center,
    Icons.fitness_center,
  ];

  late List<IconData> _shuffledIcons;
  final List<bool> _flipped = List.filled(12, false);
  final List<bool> _matched = List.filled(12, false);
  int? _firstFlipped;
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _shuffledIcons = List.from(_icons)..shuffle();
    _startTimer();
    _loadUserData();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _gameOver = true);
        _showGameOver();
      }
    });
  }

  void _onCardTap(int index) {
    if (_waiting || _flipped[index] || _matched[index] || _gameOver) return;

    setState(() => _flipped[index] = true);

    if (_firstFlipped == null) {
      _firstFlipped = index;
    } else {
      if (_shuffledIcons[_firstFlipped!] == _shuffledIcons[index]) {
        setState(() {
          _matched[_firstFlipped!] = true;
          _matched[index] = true;
          _score += 20;
        });
        _firstFlipped = null;
        if (_matched.every((m) => m)) _saveSession();
      } else {
        _waiting = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _flipped[_firstFlipped!] = false;
            _flipped[index] = false;
            _firstFlipped = null;
            _waiting = false;
          });
        });
      }
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('⏰ Time\'s Up!'),
        content: Text('Your score: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveSession();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
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
    _timer?.cancel();
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': 'memory_match',
        'completedAt': FieldValue.serverTimestamp(),
        'durationSeconds': 120 - _timerSeconds,
        'repsCompleted': _matched.where((m) => m).length ~/ 2,
        'accuracyScore': _score,
        'type': 'memory',
      });
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const OfflineSaveScreen()));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        const Icon(Icons.timer_outlined,
                            color: Color(0xffC2410C), size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "${_timerSeconds ~/ 60}:${(_timerSeconds % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: _timerSeconds < 30
                                ? Colors.red
                                : const Color(0xff64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                    ),
                    Text("Memory Match",
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: const Color(0xffC2410C),
                          fontWeight: FontWeight.bold,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("⭐ $_score",
                          style: const TextStyle(
                            color: Color(0xffC2410C),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Find the matching pairs to strengthen focus.",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: const Color(0xff6B7280))),
                const SizedBox(height: 20),
                // Grid البطاقات
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _matched[index]
                              ? const Color(0xffDDF2DD)
                              : _flipped[index]
                                  ? Colors.white
                                  : const Color(0xffD9E6FF),
                          borderRadius: BorderRadius.circular(22),
                          border: _matched[index]
                              ? Border.all(
                                  color: const Color(0xff0D6C1E), width: 2)
                              : null,
                        ),
                        child: Center(
                          child: _flipped[index] || _matched[index]
                              ? Icon(_shuffledIcons[index],
                                  color: _matched[index]
                                      ? const Color(0xff0D6C1E)
                                      : const Color(0xff934800),
                                  size: 34)
                              : const Icon(Icons.question_mark,
                                  color: Color(0xff8EA2CC), size: 28),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Progress
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(children: [
                    Text("Daily Goal: $_completedSessions/$_totalGoal Sessions",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: _totalGoal > 0
                            ? (_completedSessions / _totalGoal).clamp(0.0, 1.0)
                            : 0.0,
                        minHeight: 8,
                        backgroundColor: const Color(0xffDDDDDD),
                        valueColor:
                            const AlwaysStoppedAnimation(Color(0xff0D6C1E)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
