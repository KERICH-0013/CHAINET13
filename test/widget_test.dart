// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chainet_app/main.dart'; // ✅ corrected import (matches pubspec.yaml)

void main() {
  testWidgets('App launches and shows CHAINET title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the main title 'CHAINET' appears.
    expect(find.text('CHAINET'), findsOneWidget);
    expect(find.text('Smarter Tea Farming'), findsOneWidget);
  });
}