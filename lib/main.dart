import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/SplashScreen.dart';
import 'package:my_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAjmpH2kJT3QztJ_CG1xrMwWznlJaaDGxo",
      authDomain: "taafi-hand-recovery.firebaseapp.com",
      projectId: "taafi-hand-recovery",
      storageBucket: "taafi-hand-recovery.firebasestorage.app",
      messagingSenderId: "666637158846",
      appId: "1:666637158846:web:010292d89db9811b2491ef",
    ),
  );

  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
