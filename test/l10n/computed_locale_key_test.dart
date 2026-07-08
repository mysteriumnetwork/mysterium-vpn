import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

// Regression: names resolved via `Localizations` inside a `useComputedValue`
// (as location_item_state_hook does for city names) are NOT reactive to a
// locale switch unless the locale keys the Computed — MobX doesn't track it.
const _translations = {'en': 'Karlsruhe', 'ja': 'カールスルーエ'};

class _CityRow extends HookWidget {
  const _CityRow({required this.withLocaleKey});
  final bool withLocaleKey;
  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final lang = Localizations.localeOf(context).languageCode;
    final name = useComputedValue(
      () => _translations[lang] ?? _translations['en']!,
      withLocaleKey ? [localeTag] : const [],
    );
    return Text(name, textDirection: TextDirection.ltr);
  }
}

Future<void> _pumpAndSwitch(WidgetTester tester, bool withKey) async {
  final locale = ValueNotifier<Locale>(const Locale('en'));
  await tester.pumpWidget(
    ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (_, loc, _) => MaterialApp(
        locale: loc,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: _CityRow(withLocaleKey: withKey),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('Karlsruhe'), findsOneWidget);
  locale.value = const Locale('ja');
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Computed without a locale key stays stale on locale switch', (tester) async {
    await _pumpAndSwitch(tester, false);
    expect(find.text('Karlsruhe'), findsOneWidget); // stale
    expect(find.text('カールスルーエ'), findsNothing);
  });

  testWidgets('Computed keyed on locale re-translates on locale switch', (tester) async {
    await _pumpAndSwitch(tester, true);
    expect(find.text('カールスルーエ'), findsOneWidget);
  });
}
