import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/ActiveTrackingSession.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ExerciseReminder.dart';

class CameraSetup extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;
  final String videoFile;

  const CameraSetup({
    super.key,
    this.exerciseId = '',
    this.exerciseTitle = '',
    this.videoFile = '',
  });

  @override
  State<CameraSetup> createState() => _CameraSetupState();
}

class _CameraSetupState extends State<CameraSetup>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startTracking() async {
    setState(() => _isLoading = true);
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      await FirebaseFirestore.instance.collection('sessions').add({
        'userId': uid,
        'exerciseId': widget.exerciseId.isNotEmpty
            ? widget.exerciseId
            : 'camera_tracking',
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'tracking',
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ActiveTrackingSession(
              exerciseId: widget.exerciseId,
              exerciseTitle: widget.exerciseTitle,
              videoFile: widget.videoFile,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: topPadding + 30, left: 20, right: 20, bottom: 18),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF934800),
                        size: 20,
                      ),
                    ),
                  ),
                  Text("تعافي",
                      style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExerciseReminder())),
                    child: Icon(Icons.notifications_none,
                        color: AppColors.textColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text("إتقان زاوية\nالعرض",
                      style: AppTextStyles.headlineLarge.copyWith(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: const Color(0xff1A1C1C))),
                  const SizedBox(height: 10),
                  Text("لنتأكد من أفضل جودة تتبع\nلجلستك.",
                      style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xff414752), height: 1.6)),
                  const SizedBox(height: 24),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.95,
                      child: AnimatedBuilder(
                        animation:
                            Listenable.merge([_scanAnimation, _pulseAnimation]),
                        builder: (context, child) {
                          return Container(
                            height: 320,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1A2E),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF934800)
                                    .withOpacity(_pulseAnimation.value),
                                width: 2.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 270,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/Visual Calibration G.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20 + (_scanAnimation.value * 200),
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          const Color(0xFF934800)
                                              .withOpacity(0.9),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ..._buildCorners(),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            color: _pulseAnimation.value > 0.8
                                                ? Colors.greenAccent
                                                : Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "الكاميرا نشطة",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(children: [
                                      Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                              color: Color(0xff0D6C1E),
                                              shape: BoxShape.circle)),
                                      const SizedBox(width: 6),
                                      Text("نطاق الكشف الأمثل",
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xff1A1C1C))),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.only(right: 4, bottom: 14),
                    child: Text(
                      "نصائح الإعداد",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _buildTipCard(
                    icon: Icons.phone_android,
                    title: "سطح ثابت",
                    subtitle: "ضعي هاتفك على حامل ثابت أو اسنديه بإحكام.",
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    icon: Icons.crop_free,
                    title: "اجلسي ضمن الإطار",
                    subtitle:
                        "ابقي على بعد حوالي 50 سم. حافظي على ظهور يدك داخل المربع.",
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    icon: Icons.wb_sunny_outlined,
                    title: "إضاءة متساوية",
                    subtitle:
                        "تجنبي الظلال. الإضاءة الطبيعية الساطعة أفضل للتتبع.",
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _isLoading ? null : _startTracking,
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [Color(0xffB85C00), Color(0xff934800)]),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 6))
                          ]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text("أنا جاهزة، ابدأ التتبع",
                                    style: AppTextStyles.buttonText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                            if (!_isLoading) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_back, color: Colors.white)
                            ],
                          ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const color = Color(0xFF934800);
    const size = 20.0;
    const thickness = 3.0;

    return [
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: size,
          height: thickness,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: thickness,
          height: size,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: size,
          height: thickness,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: thickness,
          height: size,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: size,
          height: thickness,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: thickness,
          height: size,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: size,
          height: thickness,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: thickness,
          height: size,
          color: color,
        ),
      ),
    ];
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF934800), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xff1A1C1C),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.info_outline, color: Color(0xFFD1D5DB), size: 18),
        ],
      ),
    );
  }
}
