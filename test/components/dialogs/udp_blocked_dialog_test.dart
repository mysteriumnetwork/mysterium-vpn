import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Opens the dialog and exposes whatever it resolves to through [result].
  Future<List<bool>> openDialog(WidgetTester tester) async {
    final result = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async => result.add(await showUdpBlockedDialog(ctx)),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('explains the block and offers both actions', (tester) async {
    await openDialog(tester);

    expect(find.text(S.current.udpBlockedTitle), findsOneWidget);
    expect(find.text(S.current.udpBlockedDesc), findsOneWidget);
    expect(find.text(S.current.udpBlockedConfirm), findsOneWidget);
    expect(find.text(S.current.notNowBtn), findsOneWidget);
  });

  testWidgets('confirming resolves true', (tester) async {
    final result = await openDialog(tester);

    await tester.tap(find.text(S.current.udpBlockedConfirm));
    await tester.pumpAndSettle();

    expect(result, [true]);
  });

  testWidgets('dismissing resolves false', (tester) async {
    final result = await openDialog(tester);

    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pumpAndSettle();

    expect(result, [false]);
  });
}
