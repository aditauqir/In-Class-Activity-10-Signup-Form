import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:signup_app/main.dart';

void main() {
  testWidgets('Test 1: empty submit shows validation errors', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Demo signup complete — your form passed validation!'), findsNothing);
  });

  testWidgets('Test 2: bad email shows error', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Adi Tauqir');
    await tester.enterText(find.byType(TextFormField).at(1), 'bademail');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret123');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Demo signup complete — your form passed validation!'), findsNothing);
  });

  testWidgets('Test 3: short password shows error', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Adi Tauqir');
    await tester.enterText(find.byType(TextFormField).at(1), 'adi@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.text('Demo signup complete — your form passed validation!'), findsNothing);
  });

  testWidgets('Test 4: valid submit shows green snackbar', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Adi Tauqir');
    await tester.enterText(find.byType(TextFormField).at(1), 'noorwastaken@adi.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'myverygoodpassword123#');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Demo signup complete — your form passed validation!'), findsOneWidget);
  });

  testWidgets('Test 5: local demo tip shows preset tip', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Get a signup tip'), findsOneWidget);
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();

    expect(find.text('Loading demo tip...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.textContaining('Tip:'), findsOneWidget);
  });

  testWidgets('Test 6: local error and retry flow', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Long press triggers the forced error state
    await tester.longPress(find.text('Get a signup tip'));
    await tester.pumpAndSettle();

    expect(find.text('Could not load tip. Tap retry.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // Tap retry to recover
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tip:'), findsOneWidget);
  });
}
