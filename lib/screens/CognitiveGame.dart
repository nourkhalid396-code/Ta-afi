import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/PhysicalRehabExercises.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/screens/ProfileScreen.dart';

class CognitiveGame extends StatefulWidget {
  const CognitiveGame({super.key});

  @override
  State<CognitiveGame> createState() => _CognitiveGameState();
}

class _CognitiveGameState extends State<CognitiveGame> {
  int _score = 0;
  int _matches = 0;
  final int _totalPairs = 6; // ✅ زدنا من 3 لـ 6
  bool _gameStarted = false;
  DateTime? _startTime;
  int? _firstCardIndex;

  // ✅ 6 أزواج مختلفة
  final List<Map<String, dynamic>> _cards = [
    {
      'id': 1,
      'icon': Icons.phone_iphone,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 1,
      'icon': Icons.phone_iphone,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 2,
      'icon': Icons.favorite,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 2,
      'icon': Icons.favorite,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 3,
      'icon': Icons.star,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 3,
      'icon': Icons.star,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 4,
      'icon': Icons.sports_basketball,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 4,
      'icon': Icons.sports_basketball,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 5,
      'icon': Icons.music_note,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 5,
      'icon': Icons.music_note,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 6,
      'icon': Icons.bolt,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
    {
      'id': 6,
      'icon': Icons.bolt,
      'color': const Color(0xFFB85C00),
      'matched': false,
      'flipped': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _cards.shuffle(); // ✅ خلط البطاقات عشوائياً
  }

  Future<void> _saveGameResult() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      int durationSeconds = _startTime != null
          ? DateTime.now().difference(_startTime!).inSeconds
          : 0;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': 'memory_game',
        'completedAt': FieldValue.serverTimestamp(),
        'durationSeconds': durationSeconds,
        'repsCompleted': _matches,
        'accuracyScore': (_matches / _totalPairs * 100).round(),
        'type': 'cognitive',
        'status': 'completed', // ✅ سطر جديد
      });
    } catch (e) {
      print('Error saving game: $e');
    }
  }

  void _onCardTap(int index) {
    if (_cards[index]['matched'] || _cards[index]['flipped']) return;
    setState(() {
      _cards[index]['flipped'] = true;
      if (!_gameStarted) {
        _gameStarted = true;
        _startTime = DateTime.now();
      }
    });
    if (_firstCardIndex == null) {
      _firstCardIndex = index;
    } else {
      int first = _firstCardIndex!;
      int second = index;
      _firstCardIndex = null;
      if (_cards[first]['id'] == _cards[second]['id']) {
        setState(() {
          _cards[first]['matched'] = true;
          _cards[second]['matched'] = true;
          _score += 40;
          _matches++;
        });
        if (_matches == _totalPairs) {
          _saveGameResult();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  title: const Text(
                    '🎉 أحسنت!',
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'أكملتِ لعبة الذاكرة!\nالنتيجة: $_score',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeDashboard()),
                        (route) => false,
                      ),
                      child: const Text(
                        'العودة للرئيسية',
                        style: TextStyle(
                          color: Color(0xFF934800),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _cards[first]['flipped'] = false;
            _cards[second]['flipped'] = false;
          });
        });
      }
    }
  }

  String get _timeRemaining {
    if (_startTime == null) return "3:00"; // ✅ زدنا الوقت لـ 3 دقايق
    int elapsed = DateTime.now().difference(_startTime!).inSeconds;
    int remaining = 180 - elapsed;
    if (remaining < 0) remaining = 0;
    return "${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDDE7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileScreen())),
                      child: const CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage('assets/images/Avatar5.png')),
                    ),
                    const SizedBox(width: 10),
                    Text("تعافي",
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: topCard(
                                title: "النتيجة",
                                value: "$_score",
                                titleColor: const Color(0xff005FAF))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: topCard(
                                title: "الوقت\nالمتبقي",
                                value: _timeRemaining,
                                titleColor: const Color(0xff934800))),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text("لعبة الذاكرة",
                        style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: const Color(0xff1A1C1C))),
                    const SizedBox(height: 8),
                    Text("اعثري على الأزواج المتطابقة لتقوية التركيز.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: const Color(0xff414752))),
                    const SizedBox(height: 22),

                    // ✅ Grid بـ 3 أعمدة
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                      children: List.generate(_cards.length, (index) {
                        return GestureDetector(
                          onTap: () => _onCardTap(index),
                          child: gameCard(
                            opened: _cards[index]['flipped'] ||
                                _cards[index]['matched'],
                            icon: _cards[index]['icon'],
                            customColor: _cards[index]['color'],
                            matched: _cards[index]['matched'],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  color: const Color(0xffDDF5E6),
                                  borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.psychology,
                                  color: Colors.green)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("التركيز الإدراكي",
                                    style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff1A1C1C))),
                                const SizedBox(height: 4),
                                Text(
                                    _matches == 0
                                        ? "اقلبي البطاقات لإيجاد الأزواج المتطابقة!"
                                        : _matches == _totalPairs
                                            ? "ممتاز! طابقتِ كل الأزواج! 🎉"
                                            : "نسبة تطابقك ${(_matches / _totalPairs * 100).round()}% — واصلي!",
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: const Color(0xff414752),
                                        height: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeDashboard()),
                  (route) => false),
              child: navItem(
                  icon: Icons.home_outlined, title: "الرئيسية", active: false)),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PhysicalRehabExercises())),
              child: navItem(
                  icon: Icons.back_hand_outlined,
                  title: "التمارين",
                  active: false)),
          GestureDetector(
              onTap: () {},
              child: navItem(
                  icon: Icons.psychology, title: "الألعاب", active: true)),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProgressAchievements())),
              child: navItem(
                  icon: Icons.auto_graph, title: "التقدم", active: false)),
        ]),
      ),
    );
  }

  Widget topCard(
      {required String title,
      required String value,
      required Color titleColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
                color: titleColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11)),
        const SizedBox(height: 10),
        Text(value,
            style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 42,
                color: const Color(0xff1A1C1C))),
      ]),
    );
  }

  Widget gameCard(
      {required bool opened,
      IconData? icon,
      Color? customColor,
      bool matched = false}) {
    return Container(
      decoration: BoxDecoration(
        color: opened
            ? (matched
                ? Colors.green.shade100
                : (customColor ?? AppColors.primaryColor))
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: opened ? null : Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: opened
            ? (icon != null
                ? Icon(icon,
                    color: matched ? Colors.green : Colors.white, size: 36)
                : const Text("؟",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)))
            : const Text("؟",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget navItem(
      {required IconData icon, required String title, required bool active}) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon,
          color: active ? const Color(0xff9A3412) : AppColors.lightTextColor),
      const SizedBox(height: 4),
      Text(title,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  active ? const Color(0xff9A3412) : AppColors.lightTextColor)),
    ]);
  }
}
