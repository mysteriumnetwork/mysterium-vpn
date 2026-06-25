import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpSwitcher(
    WidgetTester tester, {
    required ValueChanged<IPType> onChanged,
    required VoidCallback onTrailingPressed,
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'resources/langs',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        useOnlyLangCode: true,
        assetLoader: const CodegenLoader(),
        child: Builder(
          builder: (ctx) => MaterialApp(
            theme: DesignSystem.lightTheme,
            locale: EasyLocalization.of(ctx)?.locale,
            localizationsDelegates: EasyLocalization.of(ctx)?.delegates,
            supportedLocales: EasyLocalization.of(ctx)?.supportedLocales ?? const [Locale('en')],
            home: Scaffold(
              body: LocationTypeSwitcher(
                value: IPType.datacenter,
                options: const [IPType.datacenter, IPType.residential],
                onChanged: onChanged,
                activeTabTrailing: IconButton(
                  key: const Key('trailing'),
                  icon: const Icon(Icons.refresh),
                  onPressed: onTrailingPressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('trailing action fires without switching tabs', (tester) async {
    IPType? changedTo;
    var trailingTapped = false;

    await pumpSwitcher(
      tester,
      onChanged: (v) => changedTo = v,
      onTrailingPressed: () => trailingTapped = true,
    );

    // The trailing action only renders on the active (datacenter) tab.
    expect(find.byKey(const Key('trailing')), findsOneWidget);

    await tester.tap(find.byKey(const Key('trailing')));
    await tester.pump();

    expect(trailingTapped, isTrue);
    expect(changedTo, isNull);
  });

  testWidgets('tapping the other tab switches type', (tester) async {
    IPType? changedTo;

    await pumpSwitcher(tester, onChanged: (v) => changedTo = v, onTrailingPressed: () {});

    await tester.tap(find.text(LocaleKeys.ipTypeResidential.tr()));
    await tester.pump();

    expect(changedTo, IPType.residential);
  });
}
