import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String vapidKey =
      'BIzkXg1sCHmdUVs41k1NqrkXfKfU_c4otAo54g7HgYivVaYTKRnfGq4mUC_ghXZmrkBttr66C9VLclVVi0wckRk';

  /// تهيئة الإشعارات
  static Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ إذن الإشعارات مقبول');
    }

    String? token;
    if (kIsWeb) {
      token = await _messaging.getToken(vapidKey: vapidKey);
    } else {
      token = await _messaging.getToken();
    }
    print('📱 FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 إشعار جديد: ${message.notification?.title}');
    });
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      return await _messaging.getToken(vapidKey: vapidKey);
    }
    return await _messaging.getToken();
  }
}
