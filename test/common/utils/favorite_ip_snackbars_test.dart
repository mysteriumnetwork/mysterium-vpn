import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

void main() {
  Future<void> pumpTrigger(WidgetTester tester, VoidCallback onPressed) => tester.pumpWidget(
    MaterialApp(
      theme: DesignSystem.lightTheme,
      locale: testLocale,
      localizationsDelegates: testLocalizationsDelegates,
      supportedLocales: testSupportedLocales,
      home: ModalMessengerScope(
        child: Scaffold(
          body: Builder(
            builder: (context) => TextButton(onPressed: onPressed, child: const Text('trigger')),
          ),
        ),
      ),
    ),
  );

  testWidgets('limit snackbar offers a shortcut to the favourites list', (tester) async {
    var managed = false;
    await pumpTrigger(tester, () => showFavoriteIpLimitSnackbar(onManage: () => managed = true));

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
    expect(find.text(S.current.favoriteIpLimitReached), findsOneWidget);

    await tester.tap(find.text(S.current.manageFavoriteIpsBtn));
    await tester.pumpAndSettle();
    expect(managed, isTrue, reason: 'the action must lead to the favourites list');
  });

  testWidgets('limit snackbar is an error', (tester) async {
    await pumpTrigger(tester, () => showFavoriteIpLimitSnackbar(onManage: () {}));

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(tester.widget<Snackbar>(find.byType(Snackbar)).type, SnackbarType.error);
  });
}
