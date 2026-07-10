import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/test_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSwitcher(
    WidgetTester tester, {
    required ValueChanged<IPType> onChanged,
    required VoidCallback onTrailingPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
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

    await tester.tap(find.text(S.current.ipTypeResidential));
    await tester.pump();

    expect(changedTo, IPType.residential);
  });
}
