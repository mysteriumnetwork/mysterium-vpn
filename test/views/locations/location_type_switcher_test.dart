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
    required ValueChanged<LocationsTab> onChanged,
    VoidCallback? onTrailingPressed,
    List<LocationsTab> options = const [
      LocationsTab.datacenter,
      LocationsTab.residential,
      LocationsTab.favorite,
    ],
    LocationsTab value = LocationsTab.datacenter,
    bool favoriteLocked = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: LocationTypeSwitcher(
            value: value,
            options: options,
            onChanged: onChanged,
            favoriteLocked: favoriteLocked,
            activeTabTrailing: onTrailingPressed == null
                ? null
                : IconButton(
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
    LocationsTab? changedTo;
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

  testWidgets('tapping the residential tab switches type', (tester) async {
    LocationsTab? changedTo;

    await pumpSwitcher(tester, onChanged: (v) => changedTo = v);

    // Tab labels drop the "IPs" word.
    expect(find.text(S.current.ipTypeDataCenterTab), findsOneWidget);
    await tester.tap(find.text(S.current.ipTypeResidentialTab));
    await tester.pump();

    expect(changedTo, LocationsTab.residential);
  });

  testWidgets('favourite tab renders and is selectable', (tester) async {
    LocationsTab? changedTo;

    await pumpSwitcher(tester, onChanged: (v) => changedTo = v);

    expect(find.text(S.current.favoriteIpsTab), findsOneWidget);
    expect(find.byIcon(UntitledUI.lock_01), findsNothing);

    await tester.tap(find.text(S.current.favoriteIpsTab));
    await tester.pump();

    expect(changedTo, LocationsTab.favorite);
  });

  testWidgets('locked favourite tab shows a lock icon but stays tappable', (tester) async {
    LocationsTab? changedTo;

    await pumpSwitcher(tester, onChanged: (v) => changedTo = v, favoriteLocked: true);

    expect(find.byIcon(UntitledUI.lock_01), findsOneWidget);

    await tester.tap(find.text(S.current.favoriteIpsTab));
    await tester.pump();

    expect(changedTo, LocationsTab.favorite);
  });

  testWidgets('residential keeps its own label when it is the only IP type', (tester) async {
    await pumpSwitcher(
      tester,
      onChanged: (_) {},
      options: const [LocationsTab.residential, LocationsTab.favorite],
      value: LocationsTab.residential,
    );

    // The tab names what it lists — residential IPs — not "all locations".
    expect(find.text(S.current.ipTypeResidentialTab), findsOneWidget);
    expect(find.text(S.current.allLocations), findsNothing);
  });
}
