import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locations_refresh_icon_button_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsStore>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLocationsStore store;
  late MockAnalyticsStore analytics;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    store = MockLocationsStore();
    analytics = MockAnalyticsStore();
  });

  Future<void> pumpButton(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationsStorePOD.overrideWithValue(store),
          analyticsStorePOD.overrideWithValue(analytics),
        ],
        child: EasyLocalization(
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
              home: const Scaffold(body: LocationsRefreshIconButton(type: IPType.datacenter)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tapping refreshes the active type and logs the button source', (tester) async {
    when(store.refresh(IPType.datacenter)).thenAnswer((_) async => true);

    await pumpButton(tester);
    expect(find.byIcon(UntitledUI.refresh_cw_05), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    verify(store.refresh(IPType.datacenter)).called(1);
    verify(analytics.logLocationsRefresh(type: IPType.datacenter, source: 'button')).called(1);
  });

  testWidgets('ignores taps while a refresh is already in flight', (tester) async {
    final completer = Completer<bool>();
    when(store.refresh(IPType.datacenter)).thenAnswer((_) => completer.future);

    await pumpButton(tester);
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    // While in flight the button is disabled (spinning), so a second tap no-ops.
    await tester.tap(find.byType(IconButton), warnIfMissed: false);
    await tester.pump();

    verify(store.refresh(IPType.datacenter)).called(1);

    completer.complete(true);
    await tester.pump();
  });
}
