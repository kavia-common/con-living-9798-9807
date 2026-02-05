import 'package:con_living_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard renders key sections', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Xfinity Mobile.'), findsOneWidget);

    expect(find.text('Featured'), findsOneWidget);
    expect(find.text('Curated for you'), findsOneWidget);

    // Bottom nav icons (a couple sanity checks)
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
  });
}

