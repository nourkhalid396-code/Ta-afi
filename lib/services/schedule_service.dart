import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleService {

  static Stream<QuerySnapshot> getUserSchedule() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('schedules')
        .where('userId', isEqualTo: uid)
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  static Future<void> addSchedule({
    required String exerciseId,
    required int dayOfWeek,
    required String time,
  }) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('schedules').add({
      'userId': uid,
      'exerciseId': exerciseId,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> toggleSchedule(String scheduleId, bool isActive) async {
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId)
        .update({'isActive': isActive});
  }

  static Future<void> deleteSchedule(String scheduleId) async {
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId)
        .delete();
  }
}
