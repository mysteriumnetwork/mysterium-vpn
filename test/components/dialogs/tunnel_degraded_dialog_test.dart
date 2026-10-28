import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Opens the dialog and exposes whatever it resolves to through the list.
  Future<List<bool>> openDialog(WidgetTester tester, {required bool canRefresh}) async {
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
              onPressed: () async =>
                  result.add(await showTunnelDegradedDialog(ctx, canRefresh: canRefresh)),
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

  testWidgets('offers a refresh when the pool has other IPs', (tester) async {
    await openDialog(tester, canRefresh: true);

    expect(find.text(S.current.tunnelDegradedTitle), findsOneWidget);
    expect(find.text(S.current.tunnelDegradedDesc), findsOneWidget);
    expect(find.text(S.current.tunnelDegradedRefresh), findsOneWidget);
    expect(find.text(S.current.closeBtn), findsOneWidget);
  });

  testWidgets('advises a country switch only when the pool has one IP', (tester) async {
    await openDialog(tester, canRefresh: false);

    expect(find.text(S.current.tunnelDegradedDescNoRefresh), findsOneWidget);
    expect(find.text(S.current.tunnelDegradedRefresh), findsNothing);
    expect(find.text(S.current.closeBtn), findsOneWidget);
  });

  testWidgets('resolves true when the user chooses refresh', (tester) async {
    final result = await openDialog(tester, canRefresh: true);
    await tester.tap(find.text(S.current.tunnelDegradedRefresh));
    await tester.pumpAndSettle();

    expect(result, [true]);
  });

  testWidgets('resolves false when the user closes it', (tester) async {
    final result = await openDialog(tester, canRefresh: true);
    await tester.tap(find.text(S.current.closeBtn));
    await tester.pumpAndSettle();

    expect(result, [false]);
  });

  testWidgets('the single-IP variant resolves false on its only button', (tester) async {
    final result = await openDialog(tester, canRefresh: false);
    await tester.tap(find.text(S.current.closeBtn));
    await tester.pumpAndSettle();

    expect(result, [false]);
  });
}
