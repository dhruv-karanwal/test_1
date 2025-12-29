import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'rosters_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make sure you have added google-services.json (Android) / GoogleService-Info.plist (iOS)
  await Firebase.initializeApp();

  runApp(const RosterDetailApp());
}
