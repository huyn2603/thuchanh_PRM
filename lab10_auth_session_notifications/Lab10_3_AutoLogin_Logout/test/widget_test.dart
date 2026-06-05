import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_3_auto_login_logout/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('splash routes to login with empty session', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const AutoLoginApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Auto Login'), findsOneWidget);
  });
}
