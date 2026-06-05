import 'package:flutter_test/flutter_test.dart';

import 'package:lab7_signup_validation_ux/main.dart';

void main() {
  testWidgets('empty signup form shows validation errors', (tester) async {
    await tester.pumpWidget(const SignupApp());

    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
