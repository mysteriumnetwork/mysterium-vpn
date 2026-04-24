import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/location_item_state_hook.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_features_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

import 'location_item_state_hook_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionFeaturesStore>(),
  MockSpec<UnavailableLocationsStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  VPNLocation makeLocation({
    String id = 'DE',
    IPType ipType = IPType.datacenter,
    String countryCode = 'DE',
    bool isAvailable = true,
    List<VPNLocation>? children,
    int? nodeCount,
  }) => VPNLocation(
    id: id,
    ipType: ipType,
    translations: const {'en': 'Germany'},
    countryCode: countryCode,
    isAvailable: isAvailable,
    children: children,
    nodeCount: nodeCount ?? 10,
  );

  final activeSubscription = Subscription(active: true, expired: false, recurring: false);

  // State captured by _HookHarness — reset before each test.
  LocationItemState? capturedState;

  // Mocks — declared here, initialised in setUp.
  late MockVpnStore mockVpnStore;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionFeaturesStore mockSubscriptionFeaturesStore;
  late MockUnavailableLocationsStore mockUnavailableLocationsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  setUp(() {
    capturedState = null;

    mockVpnStore = MockVpnStore();
    mockSubscriptionStore = MockSubscriptionStore();
    mockSubscriptionFeaturesStore = MockSubscriptionFeaturesStore();
    mockUnavailableLocationsStore = MockUnavailableLocationsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();

    // Default stubs — individual tests may override these.
    when(mockVpnStore.isConnected).thenReturn(false);
    when(mockVpnStore.isLoading).thenReturn(false);
    when(mockVpnStore.location).thenReturn(null);
    when(mockVpnStore.connectingLocation).thenReturn(null);

    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(activeSubscription));

    when(mockSubscriptionFeaturesStore.residentialIPsAllowed).thenReturn(true);

    when(mockUnavailableLocationsStore.unavailableLocations).thenReturn(const <VPNLocation>{});

    when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(false);
    when(mockRemoteConfigStore.countriesWithStates).thenReturn(const <String>{});
  });

  // ---------------------------------------------------------------------------
  // Harness widget
  // ---------------------------------------------------------------------------

  Widget buildHarness(VPNLocation location) => ProviderScope(
    overrides: [
      vpnStorePOD.overrideWithValue(mockVpnStore),
      subscriptionStorePOD.overrideWithValue(mockSubscriptionStore),
      subscriptionFeaturesStorePOD.overrideWithValue(mockSubscriptionFeaturesStore),
      unavailableLocationsStorePOD.overrideWithValue(mockUnavailableLocationsStore),
      remoteConfigStorePOD.overrideWithValue(mockRemoteConfigStore),
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('en', 'US')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (ctx) => MaterialApp(
          locale: EasyLocalization.of(ctx)?.locale,
          localizationsDelegates: EasyLocalization.of(ctx)?.delegates,
          supportedLocales: EasyLocalization.of(ctx)?.supportedLocales ?? const [Locale('en')],
          home: Consumer(
            builder: (ctx, ref, _) => _HookHarness(
              location: location,
              onTap: (_) {},
              onState: (state) => capturedState = state,
            ),
          ),
        ),
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Test cases
  // ---------------------------------------------------------------------------

  group('useLocationItemState', () {
    testWidgets('idle for available datacenter location', (tester) async {
      final location = makeLocation();

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.countryStatus, IpCardStatus.idle);
      expect(capturedState!.needsUpgrade, isFalse);
    });

    testWidgets('connected for matching location', (tester) async {
      final location = makeLocation();

      when(mockVpnStore.isConnected).thenReturn(true);
      when(mockVpnStore.location).thenReturn(location);

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.countryStatus, IpCardStatus.connected);
    });

    testWidgets('disabled for unavailable location', (tester) async {
      final location = makeLocation();

      when(mockUnavailableLocationsStore.unavailableLocations).thenReturn({location});

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.countryStatus, IpCardStatus.disabled);
    });

    testWidgets('needsUpgrade for residential location without permission', (tester) async {
      final location = makeLocation(ipType: IPType.residential);

      when(mockSubscriptionFeaturesStore.residentialIPsAllowed).thenReturn(false);

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.needsUpgrade, isTrue);
      // unsupportedByPlan maps to idle in countryStatus
      expect(capturedState!.countryStatus, IpCardStatus.idle);
    });

    testWidgets('no children results in empty items list', (tester) async {
      // Location with no children (children == null)
      final location = makeLocation();

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.items, isEmpty);
    });

    testWidgets('items built for location with two children when showCitiesAndStates is true', (
      tester,
    ) async {
      final child1 = makeLocation(id: 'Berlin', nodeCount: 5);
      final child2 = makeLocation(id: 'Munich', nodeCount: 3);
      final location = makeLocation(children: [child1, child2]);

      when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(true);

      await tester.pumpWidget(buildHarness(location));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.items.length, 2);
    });

    testWidgets('updates from disabled to idle when isAvailable changes to true', (tester) async {
      final unavailableLocation = makeLocation(isAvailable: false);

      await tester.pumpWidget(buildHarness(unavailableLocation));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.countryStatus, IpCardStatus.disabled);

      // Same identity (id/ipType/countryCode) but isAvailable changed to true.
      final availableLocation = makeLocation();

      await tester.pumpWidget(buildHarness(availableLocation));
      await tester.pump();

      expect(capturedState, isNotNull);
      expect(capturedState!.countryStatus, IpCardStatus.idle);
    });
  });
}

// ---------------------------------------------------------------------------
// Hook harness widget
// ---------------------------------------------------------------------------

class _HookHarness extends HookConsumerWidget {
  const _HookHarness({required this.location, required this.onTap, required this.onState});

  final VPNLocation location;
  final void Function(VPNLocation) onTap;
  final void Function(LocationItemState) onState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useLocationItemState(location: location, onTap: onTap, ref: ref);
    // Schedule the callback after the build frame to avoid calling setState
    // inside build.
    useEffect(() {
      onState(state);
      return null;
    }, [state]);
    return const SizedBox.shrink();
  }
}
