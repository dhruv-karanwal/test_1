import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/rooster/rosters_detail_screen.dart';
import 'screens/guide/guide_detail_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/landing/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make sure you have added google-services.json (Android) / GoogleService-Info.plist (iOS)
  await Firebase.initializeApp();

  // runApp(const RosterDetailApp());
  // runApp(const GuideDetailApp());
  // runApp(const HomeApp());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bandhavgarh Safari',
      home: const SplashScreen(), // Start at Splash Screen
    );
  }
}


class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bandhavgarh Safari',
      home: HomeScreen(),
    );
  }
}
