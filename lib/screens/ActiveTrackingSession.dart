import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/OfflineSaveScreen.dart';
import 'package:my_app/theme/app_theme.dart';

class ActiveTrackingSession extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;
  final String videoFile;

  const ActiveTrackingSession({
    super.key,
    this.exerciseId = '',
    this.exerciseTitle = '',
    this.videoFile = '',
  });

  @override
  State<ActiveTrackingSession> createState() => _ActiveTrackingSessionState();
}

class _ActiveTrackingSessionState extends State<ActiveTrackingSession> {
  final int _totalSeconds = 60;
  int _remainingSeconds = 60;
  bool _isPaused = false;
  bool _isCompleted = false;
  bool _isMuted = false;
  Timer? _timer;

  // ✅ Video player
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initVideo();
  }

  void _initVideo() {
    if (widget.videoFile.isNotEmpty) {
      _videoController = VideoPlayerController.asset(
        'assets/videos/${widget.videoFile}',
      )..initialize().then((_) {
          if (!mounted) return;
          setState(() => _isVideoInitialized = true);
          _videoController!.setLooping(true);
          _videoController!.play();
        }).catchError((e) {
          print('Error loading video: $e');
        });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          if (_remainingSeconds % 10 == 0 && !_isMuted) {
            SystemSound.play(SystemSoundType.click);
          }
        } else {
          _completeSession();
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isVideoInitialized) {
        if (_isPaused) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      }
    });
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    _videoController?.pause(); // ✅ نوقف صوت وتشغيل الفيديو فوراً
    setState(() {
      _isCompleted = true;
    });

    await HapticFeedback.heavyImpact();

    await _saveSession();
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('🎉 أحسنت!'),
          content: const Text('لقد أكملتِ الجلسة!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OfflineSaveScreen(),
                  ),
                );
              },
              child: const Text('متابعة'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveSession() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'durationSeconds': _totalSeconds,
        'completedAt': Timestamp.now(),
        'accuracy': 85,
        'exerciseName': widget.exerciseTitle.isNotEmpty
            ? widget.exerciseTitle
            : 'Finger Extension',
        'status': 'completed',
      });

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDoc = await userRef.get();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      int newStreak = 1;

      if (userDoc.exists) {
        final data = userDoc.data();
        final lastActiveRaw = data?['lastActive'];
        final currentStreak = (data?['streak'] ?? 0) as int;

        if (lastActiveRaw != null) {
          final lastActive = (lastActiveRaw as Timestamp).toDate();
          final lastDay =
              DateTime(lastActive.year, lastActive.month, lastActive.day);
          final diff = today.difference(lastDay).inDays;

          if (diff == 0) {
            newStreak = currentStreak == 0 ? 1 : currentStreak;
          } else if (diff == 1) {
            newStreak = currentStreak + 1;
          } else {
            newStreak = 1;
          }
        }
      }

      await userRef.update({
        'streak': newStreak,
        'lastActive': FieldValue.serverTimestamp(),
      });
      print('✅ Streak updated to: $newStreak');
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  void _endSessionEarly() {
    _timer?.cancel();
    _videoController?.pause(); // ✅ نوقف الفيديو هون كمان
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OfflineSaveScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  double get _progressValue => _totalSeconds > 0
      ? (_totalSeconds - _remainingSeconds) / _totalSeconds
      : 0.0;

  String get _timerText {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hand5.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.12),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.back_hand_outlined,
                              color: Color(0xff934800),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "تعافي",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: const Color(0xff934800),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 158,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "نسبة الدقة",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xff414752),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "85%",
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: const Color(0xff934800),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ✅ عرض الفيديو فوق الـ Timer
                  if (widget.videoFile.isNotEmpty)
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _isVideoInitialized && _videoController != null
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoController!.value.size.width,
                                  height: _videoController!.value.size.height,
                                  child: VideoPlayer(_videoController!),
                                ),
                              )
                            : Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xff934800),
                                  ),
                                ),
                              ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.exerciseTitle.isNotEmpty
                              ? widget.exerciseTitle
                              : "مدّي أصابعك\nبالكامل",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: const Color(0xff1A1C1C),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _timerText,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff934800),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            minHeight: 8,
                            backgroundColor: const Color(0xffE5E7EB),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xff934800),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _isPaused ? "متوقف مؤقتاً" : "واصلي!",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xff414752),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _togglePause,
                        child: controlButton(
                          icon: _isPaused
                              ? Icons.play_arrow_outlined
                              : Icons.pause_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: _endSessionEarly,
                        child: Container(
                          width: 180,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xff934800),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "إنهاء\nالجلسة",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isMuted = !_isMuted),
                        child: controlButton(
                          icon: _isMuted
                              ? Icons.volume_off_outlined
                              : Icons.volume_up_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget controlButton({
    required IconData icon,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.textColor,
        size: 30,
      ),
    );
  }
}
