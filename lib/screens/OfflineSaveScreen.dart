import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_helper;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/HomeDashboard.dart';

class OfflineSaveScreen extends StatefulWidget {
  const OfflineSaveScreen({super.key});

  @override
  State<OfflineSaveScreen> createState() => _OfflineSaveScreenState();
}

class _OfflineSaveScreenState extends State<OfflineSaveScreen> {
  int _activeTime = 12;
  int _goalSets = 4;
  int _totalGoal = 5;
  double _progress = 0.8;
  bool _isSyncing = false;
  String _syncMessage = '';
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path_helper.join(databasesPath, 'taafi_local.db');
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            exerciseId TEXT,
            durationSeconds INTEGER,
            repsCompleted INTEGER,
            accuracyScore INTEGER,
            completedAt TEXT,
            synced INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE offline_progress (
            id INTEGER PRIMARY KEY,
            activeTime INTEGER DEFAULT 0,
            goalSets INTEGER DEFAULT 0,
            totalGoal INTEGER DEFAULT 5,
            progress REAL DEFAULT 0.0,
            lastUpdated TEXT
          )
        ''');
        await db.execute('''
          INSERT INTO offline_progress (id, activeTime, goalSets, totalGoal, progress, lastUpdated)
          VALUES (1, 0, 0, 5, 0.0, ?)
        ''', [DateTime.now().toIso8601String()]);
      },
    );
    await _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    if (_database == null) return;
    try {
      List<Map<String, dynamic>> result = await _database!.query(
        'offline_progress',
        where: 'id = ?',
        whereArgs: [1],
      );
      if (result.isNotEmpty) {
        setState(() {
          _activeTime = result.first['activeTime'] ?? 12;
          _goalSets = result.first['goalSets'] ?? 4;
          _totalGoal = result.first['totalGoal'] ?? 5;
          _progress = (result.first['progress'] ?? 0.8).toDouble();
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveSessionLocally() async {
    if (_database == null) return;
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      await _database!.insert('sessions', {
        'userId': uid ?? 'guest',
        'exerciseId': 'finger_flexion',
        'durationSeconds': _activeTime * 60,
        'repsCompleted': _goalSets,
        'accuracyScore': (_progress * 100).round(),
        'completedAt': DateTime.now().toIso8601String(),
        'synced': 0,
      });
      await _database!.update(
        'offline_progress',
        {
          'activeTime': _activeTime,
          'goalSets': _goalSets,
          'progress': _progress,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [1],
      );
      setState(() => _syncMessage = 'تم الحفظ محلياً (دون اتصال) ✅');
    } catch (e) {
      setState(() => _syncMessage = 'خطأ: $e');
    }
  }

  Future<void> _syncToCloud() async {
    if (_database == null) return;
    setState(() {
      _isSyncing = true;
      _syncMessage = 'جارِ المزامنة...';
    });
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _syncMessage = 'الرجاء تسجيل الدخول أولاً';
          _isSyncing = false;
        });
        return;
      }
      List<Map<String, dynamic>> unsynced = await _database!.query(
        'sessions',
        where: 'synced = ?',
        whereArgs: [0],
      );
      for (var session in unsynced) {
        await FirebaseFirestore.instance.collection('sessions').add({
          'userId': uid,
          'exerciseId': session['exerciseId'] ?? 'unknown',
          'durationSeconds': session['durationSeconds'] ?? 0,
          'repsCompleted': session['repsCompleted'] ?? 0,
          'accuracyScore': session['accuracyScore'] ?? 0,
          'completedAt':
              Timestamp.fromDate(DateTime.parse(session['completedAt'])),
          'syncedFromLocal': true,
        });
      }
      await _database!.update('sessions', {'synced': 1},
          where: 'synced = ?', whereArgs: [0]);
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'lastActive': FieldValue.serverTimestamp(),
        'streak': FieldValue.increment(1),
      });
      setState(() {
        _syncMessage = 'تمت مزامنة ${unsynced.length} جلسة مع السحابة! ✅';
        _isSyncing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تمت المزامنة مع السحابة بنجاح!'),
              backgroundColor: Color(0xff0D6C1E)),
        );
      }
    } catch (e) {
      setState(() {
        _syncMessage = 'فشلت المزامنة: $e';
        _isSyncing = false;
      });
    }
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeDashboard()),
                          (route) => false,
                        ),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xffC45A1A),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text("تعافي",
                          style: AppTextStyles.headlineMedium.copyWith(
                              color: const Color(0xffC45A1A),
                              fontWeight: FontWeight.bold,
                              fontSize: 26)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen())),
                        child: const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/Avatar7.png')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Align(
                    alignment: Alignment.centerRight,
                    child: Text("العلاج الطبيعي اليومي",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222222)))),
                const SizedBox(height: 4),
                const Align(
                    alignment: Alignment.centerRight,
                    child: Text("أكملي تقدمك من الأمس.",
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff414752)))),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Color(0xffF7DED0),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.hub_outlined,
                                  color: Color(0xff8B4A22), size: 24)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xffDDF2DD),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text("قيد التنفيذ",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0D6C1E))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("سلسلة ثني الأصابع",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222))),
                      const SizedBox(height: 12),
                      const Text(
                          "ركزي على حركات بطيئة ومتحكم بها\nلاستعادة الاتصال العصبي.",
                          style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Color(0xff414752))),
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Text("تقدم الجلسة",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          Spacer(),
                          Text("80%",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffB56B1F))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                              value: 0.8,
                              minHeight: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xffA65B11)))),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xffE9EDF8),
                            borderRadius: BorderRadius.circular(24)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.timer_outlined,
                                  color: Color(0xff2B66B1), size: 28),
                              const Spacer(),
                              Text("$_activeTime د",
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              const Text("الوقت النشط",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xff2B66B1))),
                            ]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xffDDF1DB),
                            borderRadius: BorderRadius.circular(24)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.bolt_outlined,
                                  color: Color(0xff0D6C1E), size: 28),
                              const Spacer(),
                              Text("$_goalSets/$_totalGoal",
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              const Text("مجموعات الهدف",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xff0D6C1E))),
                            ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_syncMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _syncMessage.contains('خطأ') ||
                              _syncMessage.contains('فشل')
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_syncMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _syncMessage.contains('خطأ') ||
                                    _syncMessage.contains('فشل')
                                ? Colors.red
                                : Colors.green.shade800)),
                  ),
                const SizedBox(height: 16),

                // ✅ الزرين المصلحين
                Row(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _saveSessionLocally,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                                color: const Color(0xff2F9133),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(children: [
                              Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.save,
                                      color: Colors.white, size: 22)),
                              const SizedBox(width: 10),
                              const Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text("حفظ دون اتصال",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text("يُحفظ على جهازك",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11)),
                                  ])),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _isSyncing ? null : _syncToCloud,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                                color: const Color(0xff934800),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(children: [
                              Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle),
                                  child: _isSyncing
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2))
                                      : const Icon(Icons.cloud_upload,
                                          color: Colors.white, size: 22)),
                              const SizedBox(width: 10),
                              const Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text("مزامنة مع السحابة",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text("رفع الجلسات المحفوظة",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11)),
                                  ])),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Container(
                  height: 82,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                    builder: (_) =>
                                        const ProgressAchievements()),
                                (route) => false),
                            child: bottomItem(
                                Icons.home_outlined, "الرئيسية", false)),
                        GestureDetector(
                            onTap: () {},
                            child: bottomItem(
                                Icons.hub_outlined, "التأهيل", true)),
                        GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ProgressAchievements())),
                            child: bottomItem(
                                Icons.bar_chart_outlined, "التقدم", false)),
                        GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileScreen())),
                            child: bottomItem(
                                Icons.person_outline, "الملف الشخصي", false)),
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

  Widget bottomItem(IconData icon, String title, bool active) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: active ? const EdgeInsets.all(12) : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: active ? const Color(0xffF5E1D3) : Colors.transparent,
              shape: BoxShape.circle),
          child: Icon(icon,
              size: 24, color: active ? const Color(0xffA95B1A) : Colors.grey)),
      const SizedBox(height: 5),
      Text(title,
          style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xffA95B1A) : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal)),
    ]);
  }
}
