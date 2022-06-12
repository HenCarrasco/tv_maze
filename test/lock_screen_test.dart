import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tv_maze/main.dart';

void main() {
  testWidgets('Lock screen - Set pin validations', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('TV Maze'), findsOneWidget);
    expect(find.text("Welcome to TV Maze! \nWe're glad to see you back."),
        findsOneWidget);
    expect(find.text('Pin Number'), findsOneWidget);
    expect(find.text('Please, enter your pin code to enjoy our material.'),
        findsNothing);
    expect(find.byIcon(Icons.live_tv), findsOneWidget);

    await tester.tap(find.byKey(Key("pin-btn")));
    await tester.pumpAndSettle();

    expect(find.text('Enter your new pin number'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    await tester.enterText(find.byKey(Key("pin-input")), "123456");
    await tester.tap(find.byKey(Key("pin-save-btn")));
    await tester.pumpAndSettle();

    expect(find.text('Pin number must contains 6 characters.'), findsNothing);
    expect(find.text('Pin Number'), findsOneWidget);
  });
}
