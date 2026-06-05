import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_1_mock_login/main.dart';

void main() {
  testWidgets('mock login screen renders', (tester) async {
    await tester.pumpWidget(const MockLoginApp());
    expect(find.text('Mock Login'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
