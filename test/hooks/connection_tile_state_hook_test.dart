import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/connection_tile_state_hook.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_features_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'connection_tile_state_hook_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<ConnectionDisplayStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<SelectedLocationStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<UnavailableLocationsStore>(),
  MockSpec<ABTestingStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionFeaturesStore>(),
])
void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  const testLocation = VPNLocation(
    id: 'DE',
    ipType: IPType.datacenter,
    translations: {'en': 'Germany'},
    countryCode: 'DE',
  );

  final activeSubscription = Subscription(active: true, expired: false, recurring: false);

  // State captured by _HookHarness — reset before each test.
  ConnectionTileState? capturedState;

  // Mocks — declared here, initialised in setUp.
  late MockVpnStore mockVpnStore;
  late MockConnectionDisplayStore mockConnectionDisplayStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockSelectedLocationStore mockSelectedLocationStore;
  late MockLocationsStore mockLocationsStore;
  late MockUnavailableLocationsStore mockUnavailableLocationsStore;
  late MockABTestingStore mockAbTestingStore;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionFeaturesStore mockSubscriptionFeaturesStore;

  setUp(() {
    capturedState = null;

    mockVpnStore = MockVpnStore();
    mockConnectionDisplayStore = MockConnectionDisplayStore();
    mockAnalyticsStore = MockAnalyticsStore();
    mockSelectedLocationStore = MockSelectedLocationStore();
    mockLocationsStore = MockLocationsStore();
    mockUnavailableLocationsStore = MockUnavailableLocationsStore();
    mockAbTestingStore = MockABTestingStore();
    mockSubscriptionStore = MockSubscriptionStore();
    mockSubscriptionFeaturesStore = MockSubscriptionFeaturesStore();

    // Default stubs — individual tests may override these.
    when(mockConnectionDisplayStore.hasDifferentSelection).thenReturn(false);
    when(mockConnectionDisplayStore.isLoading).thenReturn(false);
    when(mockConnectionDisplayStore.isConnected).thenReturn(false);
    when(mockConnectionDisplayStore.displayLocation).thenReturn(null);
    when(mockConnectionDisplayStore.parentLocation).thenReturn(null);
    when(mockConnectionDisplayStore.targetLocation).thenReturn(null);
    when(mockConnectionDisplayStore.isLocationAvailable).thenReturn(false);
    when(mockConnectionDisplayStore.connectionIP).thenReturn(null);
    when(mockConnectionDisplayStore.connectionIntent).thenReturn(null);
    when(mockConnectionDisplayStore.connectionRated).thenReturn(null);

    when(mockVpnStore.isConnected).thenReturn(false);
    when(mockVpnStore.isLoading).thenReturn(false);
    when(mockVpnStore.location).thenReturn(null);
    when(mockVpnStore.connectingLocation).thenReturn(null);
    when(mockVpnStore.vpnStatus).thenReturn(VpnConnectionStatus.disconnected);

    when(mockSelectedLocationStore.value).thenReturn(null);

    when(mockLocationsStore.findParent(any)).thenReturn(null);

    when(mockUnavailableLocationsStore.unavailableLocations).thenReturn(const {});

    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(activeSubscription));

    when(mockSubscriptionFeaturesStore.residentialIPsAllowed).thenReturn(true);
  });

  // ---------------------------------------------------------------------------
  // Harness widget
  // ---------------------------------------------------------------------------

  Widget buildHarness() => ProviderScope(
    overrides: [
      vpnStorePOD.overrideWithValue(mockVpnStore),
      connectionDisplayStorePOD.overrideWithValue(mockConnectionDisplayStore),
      analyticsStorePOD.overrideWithValue(mockAnalyticsStore),
      selectedLocationStorePOD.overrideWithValue(mockSelectedLocationStore),
      locationsStorePOD.overrideWithValue(mockLocationsStore),
      unavailableLocationsStorePOD.overrideWithValue(mockUnavailableLocationsStore),
      abTestingStorePOD.overrideWithValue(mockAbTestingStore),
      subscriptionStorePOD.overrideWithValue(mockSubscriptionStore),
      subscriptionFeaturesStorePOD.overrideWithValue(mockSubscriptionFeaturesStore),
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('en', 'US')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (ctx) {
          final delegate = BeamerDelegate(
            locationBuilder: RoutesLocationBuilder(
              routes: {'/': (_, a, b) => const SizedBox.shrink()},
            ).call,
          );
          return BeamerProvider(
            routerDelegate: delegate,
            child: MaterialApp(
              locale: EasyLocalization.of(ctx)?.locale,
              localizationsDelegates: EasyLocalization.of(ctx)?.delegates,
              supportedLocales: EasyLocalization.of(ctx)?.supportedLocales ?? const [Locale('en')],
              home: Consumer(
                builder: (_, ref, child) => _HookHarness(onState: (state) => capturedState = state),
              ),
            ),
          );
        },
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Test cases
  // ---------------------------------------------------------------------------

  group('useConnectionTileState', () {
    testWidgets('not connected, no location → MainIpCardNotConnected', (tester) async {
      // Default stubs already set: isConnected=false, isLoading=false, displayLocation=null

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.status, isA<MainIpCardNotConnected>());
    });

    testWidgets('connected → MainIpCardConnected', (tester) async {
      when(mockVpnStore.isConnected).thenReturn(true);
      when(mockConnectionDisplayStore.isConnected).thenReturn(true);
      when(mockConnectionDisplayStore.displayLocation).thenReturn(testLocation);
      when(mockConnectionDisplayStore.isLocationAvailable).thenReturn(true);
      when(mockVpnStore.location).thenReturn(testLocation);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.status, isA<MainIpCardConnected>());
    });

    testWidgets('loading → MainIpCardConnecting', (tester) async {
      when(mockVpnStore.isConnected).thenReturn(false);
      when(mockConnectionDisplayStore.isConnected).thenReturn(false);
      when(mockConnectionDisplayStore.isLoading).thenReturn(true);
      when(mockConnectionDisplayStore.displayLocation).thenReturn(testLocation);
      when(mockConnectionDisplayStore.isLocationAvailable).thenReturn(true);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.status, isA<MainIpCardConnecting>());
    });

    testWidgets('location selected (not loading, not connected) → MainIpCardLocationSelected', (
      tester,
    ) async {
      when(mockVpnStore.isConnected).thenReturn(false);
      when(mockConnectionDisplayStore.isConnected).thenReturn(false);
      when(mockConnectionDisplayStore.isLoading).thenReturn(false);
      when(mockConnectionDisplayStore.displayLocation).thenReturn(testLocation);
      when(mockConnectionDisplayStore.isLocationAvailable).thenReturn(true);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.status, isA<MainIpCardLocationSelected>());
    });

    testWidgets('connectingLabel is "Disconnecting" when vpnStatus == disconnecting', (
      tester,
    ) async {
      when(mockVpnStore.vpnStatus).thenReturn(VpnConnectionStatus.disconnecting);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.connectingLabel.toLowerCase(), contains('disconnecting'));
    });

    testWidgets('connectionRating maps like → thumbsUp', (tester) async {
      when(
        mockConnectionDisplayStore.connectionRated,
      ).thenReturn(RateConnectionRequestModeEnum.like);

      await tester.pumpWidget(buildHarness());
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.connectionRating, ConnectionRating.thumbsUp);
    });

    testWidgets(
      'onToggle is handleUpgradePlan for residential location without residentialIPsAllowed',
      (tester) async {
        const residentialLocation = VPNLocation(
          id: 'DE-RES',
          ipType: IPType.residential,
          translations: {'en': 'Germany Residential'},
          countryCode: 'DE',
        );
        when(mockConnectionDisplayStore.displayLocation).thenReturn(residentialLocation);
        when(mockConnectionDisplayStore.isLocationAvailable).thenReturn(true);
        when(mockSubscriptionFeaturesStore.residentialIPsAllowed).thenReturn(false);

        await tester.pumpWidget(buildHarness());
        await tester.pump();

        expect(capturedState, isNotNull);
        // onToggle should be non-null (upgrade callback), not null (loading guard)
        expect(capturedState!.onToggle, isNotNull);
      },
    );
  });
}

// ---------------------------------------------------------------------------
// Hook harness widget
// ---------------------------------------------------------------------------

class _HookHarness extends HookConsumerWidget {
  const _HookHarness({required this.onState});

  final void Function(ConnectionTileState) onState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useConnectionTileState(ref);
    useEffect(() {
      onState(state);
      return null;
    }, []);
    return const SizedBox.shrink();
  }
}
