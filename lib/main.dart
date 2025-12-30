import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'screens/rooster/rosters_detail_screen.dart'; // Original Roster App
import 'screens/guide/guide_detail_screen.dart'; // New Guide App

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make sure you have added google-services.json (Android) / GoogleService-Info.plist (iOS)
  await Firebase.initializeApp();

  // runApp(const RosterDetailApp());
  runApp(const GuideDetailApp());
}
