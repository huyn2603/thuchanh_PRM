import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab6_responsive_genre_browsing/main.dart';

void main() {
  testWidgets('filters movies by search text', (tester) async {
    await tester.pumpWidget(const ResponsiveMovieApp());

    expect(find.text('Find a Movie'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'arrival');
    await tester.pump();

    expect(find.text('Arrival'), findsOneWidget);
    expect(find.text('Interstellar'), findsNothing);
  });
}
