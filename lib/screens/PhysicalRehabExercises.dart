import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/CameraSetup.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/ExerciseReminder.dart';

class PhysicalRehabExercises extends StatefulWidget {
  const PhysicalRehabExercises({super.key});

  @override
  State<PhysicalRehabExercises> createState() => _PhysicalRehabExercisesState();
}

class _PhysicalRehabExercisesState extends State<PhysicalRehabExercises> {
  String _selectedCategory = 'All';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _exercises = [
    {
      'id': 'finger_extensions',
      'title': 'Finger\nExtensions',
      'subtitle': 'Releasing tension and\nimproving span.',
      'duration': '5 mins',
      'image': 'assets/images/hand2.png',
      'category': 'Mobility'
    },
    {
      'id': 'wrist_rotations',
      'title': 'Wrist Rotations',
      'subtitle': 'Enhancing circular range of\nmotion.',
      'duration': '8 mins',
      'image': 'assets/images/hand3.png',
      'category': 'Mobility'
    },
    {
      'id': 'grip_strengthening',
      'title': 'Grip\nStrengthening',
      'subtitle': 'Building foundational muscle\npower.',
      'duration': '12 mins',
      'image': 'assets/images/hand4.png',
      'category': 'Strength'
    },
  ];

  Future<void> _startExercise(String exerciseId) async {
    setState(() => _isLoading = true);
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': exerciseId,
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'in_progress',
      });
      if (mounted)
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CameraSetup()));
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredExercises {
    if (_selectedCategory == 'All') return _exercises;
    return _exercises.where((e) => e['category'] == _selectedCategory).toList();
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
                padding: const EdgeInsets.only(
                    top: 20, left: 22, right: 22, bottom: 20),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileScreen())),
                      child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/Avatar2.png'),
                                  fit: BoxFit.cover))),
                    ),
                    const SizedBox(width: 8),
                    Text("Ta'afi",
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ExerciseReminder())),
                      child: const Icon(Icons.notifications_none,
                          color: AppColors.lightTextColor),
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
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Daily ",
                            style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff1A1C1C))),
                        TextSpan(
                            text: "Motion",
                            style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff934800))),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    Text(
                        "Focused physical therapy designed\nto restore hand dexterity and wrist\nmobility through gentle, progressive\nmovements.",
                        style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.8,
                            fontSize: 14,
                            color: const Color(0xff414752))),
                    const SizedBox(height: 22),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          filterButton(
                              title: "All Exercises",
                              active: _selectedCategory == 'All',
                              onTap: () =>
                                  setState(() => _selectedCategory = 'All')),
                          const SizedBox(width: 10),
                          filterButton(
                              title: "Mobility",
                              active: _selectedCategory == 'Mobility',
                              onTap: () => setState(
                                  () => _selectedCategory = 'Mobility')),
                          const SizedBox(width: 10),
                          filterButton(
                              title: "Strength",
                              active: _selectedCategory == 'Strength',
                              onTap: () => setState(
                                  () => _selectedCategory = 'Strength')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    ..._filteredExercises.map((exercise) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: exerciseCard(
                              context: context, exercise: exercise),
                        )),
                    const SizedBox(height: 30),
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
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
        ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeDashboard()),
                  (route) => false),
              child: navItem(
                  icon: Icons.home_outlined, title: "Home", active: false)),
          GestureDetector(
              onTap: () {},
              child: navItem(
                  icon: Icons.back_hand, title: "Exercises", active: true)),
          GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CognitiveGame())),
              child: navItem(
                  icon: Icons.psychology_outlined,
                  title: "Games",
                  active: false)),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProgressAchievements())),
              child: navItem(
                  icon: Icons.auto_graph, title: "Progress", active: false)),
        ]),
      ),
    );
  }

  Widget filterButton(
      {required String title,
      required bool active,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
            color: active ? const Color(0xff54A0FE) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20)),
        child: Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xff003567) : AppColors.textColor)),
      ),
    );
  }

  Widget exerciseCard(
      {required BuildContext context, required Map<String, dynamic> exercise}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 185,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: DecorationImage(
                      image: AssetImage(exercise['image']), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  const Icon(Icons.access_time,
                      size: 12, color: Color(0xff934800)),
                  const SizedBox(width: 5),
                  Text(exercise['duration'],
                      style: const TextStyle(
                          color: Color(0xff1A1C1C),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise['title'],
                      style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff1A1C1C))),
                  const SizedBox(height: 8),
                  Text(exercise['subtitle'],
                      style: AppTextStyles.bodyMedium.copyWith(
                          height: 1.6, color: const Color(0xff414752))),
                ],
              ),
            ),
            GestureDetector(
              onTap: _isLoading ? null : () => _startExercise(exercise['id']),
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                    color: Color(0xff934800), shape: BoxShape.circle),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Icon(Icons.play_arrow, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget navItem(
      {required IconData icon, required String title, required bool active}) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon,
          size: 22,
          color: active ? const Color(0xff9A3412) : AppColors.lightTextColor),
      const SizedBox(height: 5),
      Text(title,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  active ? const Color(0xff9A3412) : AppColors.lightTextColor)),
    ]);
  }
}
