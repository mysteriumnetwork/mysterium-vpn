import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const germany = VPNLocation(
    id: 'de',
    ipType: IPType.datacenter,
    translations: {'en': 'Germany'},
    countryCode: 'de',
  );
  const france = VPNLocation(
    id: 'fr',
    ipType: IPType.datacenter,
    translations: {'en': 'France'},
    countryCode: 'fr',
  );

  Future<void> pumpList(
    WidgetTester tester, {
    required void Function(VPNLocation) onItemPressed,
    VPNLocation? connectedLocation,
    VPNLocation? connectingLocation,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: LocationsHorizontalList(
            title: 'Recent',
            items: const [germany, france],
            onItemPressed: onItemPressed,
            connectedLocation: connectedLocation,
            connectingLocation: connectingLocation,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  LocationCard cardFor(WidgetTester tester, String name) => tester
      .widgetList<LocationCard>(find.byType(LocationCard))
      .firstWhere((it) => it.name == name);

  testWidgets('shows the connecting status on the tapped location only', (tester) async {
    await pumpList(tester, onItemPressed: (_) {}, connectingLocation: germany);

    expect(cardFor(tester, 'Germany').status, LocationCardStatus.connecting);
    expect(cardFor(tester, 'France').status, LocationCardStatus.idle);
    expect(find.byType(LoadingIndicator), findsOneWidget);
  });

  testWidgets('connecting wins over connected while disconnecting', (tester) async {
    await pumpList(
      tester,
      onItemPressed: (_) {},
      connectedLocation: germany,
      connectingLocation: germany,
    );

    expect(cardFor(tester, 'Germany').status, LocationCardStatus.connecting);
  });

  testWidgets('suppresses taps while a connection is in progress', (tester) async {
    final pressed = <VPNLocation>[];
    await pumpList(tester, onItemPressed: pressed.add, connectingLocation: germany);

    await tester.tap(find.text('France'));
    expect(pressed, isEmpty);
  });

  testWidgets('taps are delivered when idle', (tester) async {
    final pressed = <VPNLocation>[];
    await pumpList(tester, onItemPressed: pressed.add);

    await tester.tap(find.text('France'));
    expect(pressed, [france]);
  });

  testWidgets('marks the connected location as selected', (tester) async {
    await pumpList(tester, onItemPressed: (_) {}, connectedLocation: germany);

    expect(cardFor(tester, 'Germany').status, LocationCardStatus.selected);
    expect(find.byType(LoadingIndicator), findsNothing);
  });
}
