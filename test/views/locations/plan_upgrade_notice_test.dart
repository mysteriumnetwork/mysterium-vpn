import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'plan_upgrade_notice_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionStore>(), MockSpec<RemoteConfigStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSubscriptionStore subscriptionStore;
  late MockRemoteConfigStore remoteConfigStore;

  setUp(() {
    subscriptionStore = MockSubscriptionStore();
    remoteConfigStore = MockRemoteConfigStore();
    when(subscriptionStore.isSubscriptionLoading).thenReturn(false);
    when(subscriptionStore.hasResolvedPlan).thenReturn(true);
    when(subscriptionStore.residentialIPsAllowed).thenReturn(true);
    when(subscriptionStore.cityLevelAllowed).thenReturn(true);
    when(remoteConfigStore.showCitiesAndStates).thenReturn(true);
  });

  Widget buildHarness(IPType locationType) => ProviderScope(
    overrides: [
      subscriptionStorePOD.overrideWithValue(subscriptionStore),
      remoteConfigStorePOD.overrideWithValue(remoteConfigStore),
    ],
    child: MaterialApp(
      theme: DesignSystem.lightTheme,
      locale: testLocale,
      localizationsDelegates: testLocalizationsDelegates,
      supportedLocales: testSupportedLocales,
      home: Scaffold(body: PlanUpgradeNotice(locationType: locationType)),
    ),
  );

  group('PlanUpgradeNotice', () {
    testWidgets('shows the city message on the datacenter tab when city level is gated', (
      tester,
    ) async {
      when(subscriptionStore.cityLevelAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.datacenter));
      await tester.pump();

      expect(find.text(S.current.cityIpsNotAvailableOnPlan), findsOneWidget);
      expect(find.text(S.current.subscriptionUpgrade), findsOneWidget);
    });

    testWidgets('hides when the plan allows everything on the tab', (tester) async {
      await tester.pumpWidget(buildHarness(IPType.datacenter));
      await tester.pump();

      expect(find.byType(StateCard), findsNothing);
    });

    testWidgets('hides the city message when cities are not rendered at all', (tester) async {
      when(subscriptionStore.cityLevelAllowed).thenReturn(false);
      when(remoteConfigStore.showCitiesAndStates).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.datacenter));
      await tester.pump();

      expect(find.byType(StateCard), findsNothing);
    });

    testWidgets('shows the residential message on the residential tab when gated', (tester) async {
      when(subscriptionStore.residentialIPsAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.residential));
      await tester.pump();

      expect(find.text(S.current.residentialIpsNotAvailableOnPlan), findsOneWidget);
    });

    testWidgets('residential tab reports the city gate when residential itself is allowed', (
      tester,
    ) async {
      when(subscriptionStore.cityLevelAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.residential));
      await tester.pump();

      expect(find.text(S.current.cityIpsNotAvailableOnPlan), findsOneWidget);
    });

    testWidgets('hides while the subscription is still loading', (tester) async {
      when(subscriptionStore.isSubscriptionLoading).thenReturn(true);
      when(subscriptionStore.cityLevelAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.datacenter));
      await tester.pump();

      expect(find.byType(StateCard), findsNothing);
    });

    testWidgets('hides when no plan is resolved, so it never accuses a non-subscriber', (
      tester,
    ) async {
      when(subscriptionStore.hasResolvedPlan).thenReturn(false);
      when(subscriptionStore.cityLevelAllowed).thenReturn(false);
      when(subscriptionStore.residentialIPsAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(IPType.datacenter));
      await tester.pump();

      expect(find.byType(StateCard), findsNothing);
    });
  });
}
