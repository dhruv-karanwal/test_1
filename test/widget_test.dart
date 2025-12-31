// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/screens/rooster/add_roster_screen.dart';
import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('Add Roster screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Ensure we are testing the actual app/screen we built
    await tester.pumpWidget(const AddRosterApp());

    // Verify that our title is present.
    expect(find.text('Add Roster'), findsOneWidget);
    expect(find.text('DETAILS'), findsOneWidget); 
  });
}
