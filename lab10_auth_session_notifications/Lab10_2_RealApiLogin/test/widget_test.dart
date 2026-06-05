import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_2_real_api_login/main.dart';

void main() {
  testWidgets('real api login screen renders', (tester) async {
    await tester.pumpWidget(const RealApiLoginApp());
    expect(find.text('Real API Login'), findsOneWidget);
    expect(find.text('Login with API'), findsOneWidget);
  });
}
