import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseService {

  static Stream<QuerySnapshot> getExercisesByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('exercises')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDailyExercises() {
    return FirebaseFirestore.instance
        .collection('exercises')
        .where('category', isEqualTo: 'daily_motion')
        .limit(3)
        .snapshots();
  }

  static Future<DocumentSnapshot> getExerciseDetails(String exerciseId) async {
    return FirebaseFirestore.instance
        .collection('exercises')
        .doc(exerciseId)
        .get();
  }

  static Future<void> saveSession({
    required String exerciseId,
    required int durationSeconds,
    required int repsCompleted,
    required int accuracyScore,
    String? videoUrl,
    String? notes,
  }) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('sessions').add({
      'userId': uid,
      'exerciseId': exerciseId,
      'completedAt': FieldValue.serverTimestamp(),
      'durationSeconds': durationSeconds,
      'repsCompleted': repsCompleted,
      'accuracyScore': accuracyScore,
      'videoUrl': videoUrl ?? '',
      'notes': notes ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _updateStreak(uid);
  }

  static Stream<QuerySnapshot> getUserSessions() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: uid)
        .orderBy('completedAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserAchievements() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('achievements')
        .where('userId', isEqualTo: uid)
        .orderBy('unlockedAt', descending: true)
        .snapshots();
  }

  static Future<Map<String, dynamic>> getUserStats() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var sessions = await FirebaseFirestore.instance
        .collection('sessions')
        .where('userId', isEqualTo: uid)
        .get();
    var userDoc = await FirebaseFirestore.instance
        .collection('users').doc(uid).get();
    int totalSeconds = sessions.docs.fold(0, (sum, doc) =>
        sum + (doc['durationSeconds'] as int? ?? 0));
    return {
      'totalSessions': sessions.docs.length,
      'totalMinutes': (totalSeconds / 60).round(),
      'streak': userDoc['streak'] ?? 0,
    };
  }

  static Future<void> _updateStreak(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users').doc(uid).get();
    int currentStreak = userDoc['streak'] ?? 0;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'streak': currentStreak + 1,
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
