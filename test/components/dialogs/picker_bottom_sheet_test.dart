import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Opens a two-item picker; [onPick] stands in for the caller's `onChanged`.
  Future<List<String>> openPicker(WidgetTester tester, Future<void> Function(String) onPick) async {
    final picked = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showPickerBottomSheet<String>(
                context: ctx,
                title: 'Pick one',
                items: const ['Alpha', 'Beta'],
                value: 'Alpha',
                labelOf: (it) => it,
                onChanged: (it) async {
                  picked.add(it);
                  await onPick(it);
                },
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return picked;
  }

  testWidgets('a second tap while in flight is ignored and pops only the sheet', (tester) async {
    final gate = Completer<void>();
    final picked = await openPicker(tester, (_) => gate.future);

    await tester.tap(find.text('Beta'));
    await tester.pump();
    await tester.tap(find.text('Alpha'));
    await tester.pump();

    gate.complete();
    await tester.pumpAndSettle();

    expect(picked, ['Beta']);
    expect(find.text('Pick one'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('cannot be dismissed while a selection is being applied', (tester) async {
    final gate = Completer<void>();
    await openPicker(tester, (_) => gate.future);

    await tester.tap(find.text('Beta'));
    await tester.pump();

    // Barrier tap, then two pumps so a dismissal would have time to finish.
    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Pick one'), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('Pick one'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });
}
