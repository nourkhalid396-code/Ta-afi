import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CameraService {

  static Future<Map<String, dynamic>> analyzeAndSave({
    required String exerciseId,
    required String videoUrl,
    required int accuracyScore,
    required String feedbackText,
    required Map<String, dynamic> movementData,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('cameraAnalysis')
          .add({
        'userId': uid,
        'exerciseId': exerciseId,
        'videoUrl': videoUrl,
        'accuracyScore': accuracyScore,
        'feedbackText': feedbackText,
        'movementData': movementData,
        'analyzedAt': FieldValue.serverTimestamp(),
      });

      await _updateUserStats(uid, accuracyScore);

      return {
        'success': true,
        'analysisId': docRef.id,
        'accuracyScore': accuracyScore,
        'feedbackText': feedbackText,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Stream<QuerySnapshot> getUserAnalyses() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('cameraAnalysis')
        .where('userId', isEqualTo: uid)
        .orderBy('analyzedAt', descending: true)
        .snapshots();
  }

  static Future<DocumentSnapshot?> getLastAnalysis() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('cameraAnalysis')
        .where('userId', isEqualTo: uid)
        .orderBy('analyzedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) return snapshot.docs.first;
    return null;
  }

  static String getMovementFeedback(int accuracyScore) {
    if (accuracyScore >= 90) return 'ممتاز! حركتك مثالية 🌟';
    if (accuracyScore >= 75) return 'جيد جداً! استمر على هذا المستوى 💪';
    if (accuracyScore >= 60) return 'جيد! حاول تحسين مرونة الأصابع 👍';
    return 'تحتاج تدريب أكثر، لا تستسلم! 🎯';
  }

  static Future<void> _updateUserStats(String uid, int accuracyScore) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    int totalSessions = (userDoc['totalSessions'] ?? 0) + 1;
    double avgAccuracy = ((userDoc['avgAccuracy'] ?? 0.0) *
            (totalSessions - 1) +
        accuracyScore) /
        totalSessions;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'totalSessions': totalSessions,
      'avgAccuracy': avgAccuracy,
      'lastActive': FieldValue.serverTimestamp(),
    });
  }
}
