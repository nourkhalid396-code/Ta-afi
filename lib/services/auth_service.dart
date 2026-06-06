import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = cred.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'streak': 0,
        'lastActive': FieldValue.serverTimestamp(),
        'settings': {'language': 'ar', 'notifications': true, 'theme': 'light'},
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {'success': true, 'uid': uid};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .update({'lastActive': FieldValue.serverTimestamp()});
      return {'success': true, 'uid': cred.user!.uid};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Stream<DocumentSnapshot> getCurrentUserData() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.empty();
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  static String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use': return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email': return 'بريد إلكتروني غير صالح';
      case 'weak-password': return 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
      case 'user-not-found': return 'المستخدم غير موجود';
      case 'wrong-password': return 'كلمة المرور غير صحيحة';
      default: return 'حدث خطأ، حاول مرة أخرى';
    }
  }
}
