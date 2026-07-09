import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/models/models.dart';

// Regression: location names must resolve from `activeLocale` (the app's loaded
// locale), not per-context `Localizations` — the latter lagged/threw inside a
// Computed's initHook, so city names were stuck on the English fallback.
const _karlsruhe = VPNLocation(
  id: 'karlsruhe',
  ipType: IPType.datacenter,
  countryCode: 'DE',
  translations: {'en': 'Karlsruhe', 'ja': 'カールスルーエ'},
);

void main() {
  tearDown(() => activeLocale = const Locale('en'));

  testWidgets('getName re-translates when activeLocale changes', (tester) async {
    final tick = ValueNotifier<int>(0);
    activeLocale = const Locale('en');

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<int>(
          valueListenable: tick,
          builder: (context, _, _) =>
              Text(_karlsruhe.getName(context), textDirection: TextDirection.ltr),
        ),
      ),
    );
    expect(find.text('Karlsruhe'), findsOneWidget);

    activeLocale = const Locale('ja');
    tick.value++; // rebuild
    await tester.pump();
    expect(find.text('カールスルーエ'), findsOneWidget);
    expect(find.text('Karlsruhe'), findsNothing);
  });

  testWidgets('getName falls back to English when the locale is unavailable', (tester) async {
    activeLocale = const Locale('pl'); // not in translations
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Text(_karlsruhe.getName(context), textDirection: TextDirection.ltr),
        ),
      ),
    );
    expect(find.text('Karlsruhe'), findsOneWidget);
  });
}
