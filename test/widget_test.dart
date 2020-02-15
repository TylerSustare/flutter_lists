// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_lists/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lists/main.dart';

void main() {
  testWidgets('Navigate to settings from home', (WidgetTester tester) async {
    // home screen
    await tester.pumpWidget(MyApp());
    expect(find.text('Settings'), findsNothing);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
    await tester.pump();
    // settings screen
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Navigate to add item from home', (WidgetTester tester) async {
    // home screen
    await tester.pumpWidget(MyApp());
    expect(find.text('Add Item to a List'), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump();
    // add item screen
    expect(find.text('Add Item to a List'), findsOneWidget);
  });

  test('AppState test theme', () {
    var app = AppState();
    expect(app.theme, Brightness.light);
    app.toggleDark();
    expect(app.theme, Brightness.dark);
  });
  test('AppState test count', () {
    var app = AppState();
    expect(app.counter, 0);
    app.incrementCouter();
    expect(app.counter, 1);
  });
}
