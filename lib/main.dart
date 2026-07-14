import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:my_app/screens/SplashScreen.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/SignUp.dart';
import 'package:my_app/screens/ForgetScreen.dart';
import 'package:my_app/screens/onboarding1.dart';
import 'package:my_app/screens/onboarding2.dart';
import 'package:my_app/screens/onboarding3.dart';
import 'package:my_app/screens/HomeDashboard.dart';
import 'package:my_app/screens/PhysicalRehabExercises.dart';
import 'package:my_app/screens/CognitiveGame.dart';
import 'package:my_app/screens/Progress&Achievements.dart';
import 'package:my_app/screens/ProfileScreen.dart';
import 'package:my_app/screens/ExerciseReminder.dart';
import 'package:my_app/screens/OfflineSaveScreen.dart';
import 'package:my_app/screens/CameraSetup.dart';
import 'package:my_app/screens/MemoryGames.dart';
import 'package:my_app/screens/DailyGoalStatus.dart';
import 'package:my_app/screens/ActiveTrackingSession.dart';
import 'package:my_app/services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => _getScreen(settings.name),
        );
      },
    );
  }

  Widget _getScreen(String? routeName) {
    // الشاشات المفتوحة (بدون login)
    final openRoutes = {
      '/': const SplashScreen(),
      '/splash': const SplashScreen(),
      '/onboarding1': const Onboarding1(),
      '/onboarding2': const Onboarding2(),
      '/onboarding3': const Onboarding3(),
      '/login': const Login(),
      '/signup': const SignUp(),
      '/forget': const ForgetScreen(),
    };

    // الشاشات المحمية (بتحتاج login)
    final protectedRoutes = {
      '/home': const HomeDashboard(),
      '/exercises': const PhysicalRehabExercises(),
      '/games': const CognitiveGame(),
      '/progress': const ProgressAchievements(),
      '/profile': const ProfileScreen(),
      '/reminder': const ExerciseReminder(),
      '/offline': const OfflineSaveScreen(),
      '/camera': const CameraSetup(),
      '/memory': const MemoryGames(),
      '/dailygoal': const DailyGoalStatus(),
      '/tracking': const ActiveTrackingSession(),
    };

    // لو الشاشة مفتوحة → رجعها مباشرة
    if (openRoutes.containsKey(routeName)) {
      return openRoutes[routeName]!;
    }

    // لو الشاشة محمية → تحقق من login
    if (protectedRoutes.containsKey(routeName)) {
      return _AuthWrapper(child: protectedRoutes[routeName]!);
    }

    // Route مش معروف → رجع Splash
    return const SplashScreen();
  }
}

// Widget يتحقق من حالة المستخدم
class _AuthWrapper extends StatelessWidget {
  final Widget child;

  const _AuthWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // جاري التحقق
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff934800)),
            ),
          );
        }

        // مسجل دخول → افتح الشاشة
        if (snapshot.hasData && snapshot.data != null) {
          return child;
        }

        // مش مسجل دخول → روح للـ Login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
            (route) => false,
          );
        });

        return const SizedBox.shrink();
      },
    );
  }
}
