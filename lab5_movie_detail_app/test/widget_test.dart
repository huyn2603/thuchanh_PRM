import 'package:flutter_test/flutter_test.dart';

import 'package:lab5_movie_detail_app/main.dart';

void main() {
  testWidgets('home screen navigates to movie detail', (tester) async {
    await tester.pumpWidget(const MovieApp());

    expect(find.text('Movie Explorer'), findsOneWidget);
    expect(find.text('Interstellar'), findsOneWidget);

    await tester.tap(find.text('Interstellar'));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Trailers'), findsOneWidget);
    expect(find.text('Favorite'), findsOneWidget);
  });
}
