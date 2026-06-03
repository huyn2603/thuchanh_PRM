import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab4_flutter_ui_fundamentals/main.dart';

void main() {
  testWidgets('Lab 4 home opens exercise pages', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab4App());

    expect(find.text('Lab 4 - Flutter UI Fundamentals'), findsOneWidget);
    expect(find.text('Exercise 1'), findsOneWidget);

    await tester.tap(find.text('Exercise 1'));
    await tester.pumpAndSettle();

    expect(find.text('Exercise 1 - Core Widgets'), findsOneWidget);
    expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
  });
}
