import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'connection_decision_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationsStore>(),
  MockSpec<RecentLocationsStore>(),
  MockSpec<UserIntentsStore>(),
])
void main() {
  late ConnectionDecisionStore store;
  late MockLocationsStore mockLocationsStore;
  late MockRecentLocationsStore mockRecentLocationsStore;
  late MockUserIntentsStore mockUserIntentsStore;

  late VPNLocation closestLocation;
  late VPNLocation usLocation;
  late VPNLocations vpnLocationsWithClosest;
  late VPNLocations vpnLocationsEmpty;

  setUp(() {
    mockLocationsStore = MockLocationsStore();
    mockRecentLocationsStore = MockRecentLocationsStore();
    mockUserIntentsStore = MockUserIntentsStore();

    closestLocation = VPNLocation.closest;
    usLocation = const VPNLocation(
      id: 'us',
      ipType: IPType.residential,
      translations: {'en': 'United States'},
      countryCode: 'US',
    );

    vpnLocationsWithClosest = VPNLocations(
      locations: [usLocation],
      topLocations: [closestLocation],
    );

    vpnLocationsEmpty = VPNLocations();

    when(mockRecentLocationsStore.future).thenAnswer((_) => ObservableFuture.value([]));

    when(mockLocationsStore.dcLocationsFuture)
        .thenAnswer((_) => ObservableFuture.value(vpnLocationsWithClosest));

    when(mockLocationsStore.residentialLocationsFuture)
        .thenAnswer((_) => ObservableFuture.value(vpnLocationsEmpty));

    when(mockUserIntentsStore.userIntent).thenReturn(null);

    store = ConnectionDecisionStore(
      locationsStore: mockLocationsStore,
      recentLocationsStore: mockRecentLocationsStore,
      userIntentsStore: mockUserIntentsStore,
    );
  });

  group('ConnectionDecisionStore', () {
    group('potentialLocation', () {
      test('returns recent location if available', () {
        const recentLocation = VPNLocation(
          id: 'de',
          ipType: IPType.residential,
          translations: {'en': 'Germany'},
          countryCode: 'DE',
        );

        when(mockRecentLocationsStore.future)
            .thenAnswer((_) => ObservableFuture.value([recentLocation]));

        expect(store.potentialLocation, equals(recentLocation));
      });

      test('returns closest location if no recent but available', () {
        when(mockRecentLocationsStore.future).thenAnswer((_) => ObservableFuture.value([]));
        expect(store.potentialLocation, equals(VPNLocation.closest));
      });

      test('returns null if no locations available', () {
        when(mockRecentLocationsStore.future).thenAnswer((_) => ObservableFuture.value([]));
        when(mockLocationsStore.dcLocationsFuture)
            .thenAnswer((_) => ObservableFuture.value(vpnLocationsEmpty));
        when(mockLocationsStore.residentialLocationsFuture)
            .thenAnswer((_) => ObservableFuture.value(vpnLocationsEmpty));

        expect(store.potentialLocation, isNull);
      });
    });

    group('determineToggleAction', () {
      const currentLocation = VPNLocation(
        id: 'us',
        ipType: IPType.residential,
        translations: {'en': 'US'},
        countryCode: 'US',
      );
      const otherLocation = VPNLocation(
        id: 'de',
        ipType: IPType.residential,
        translations: {'en': 'DE'},
        countryCode: 'DE',
      );

      test('returns connect if not connected', () {
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.disconnected,
          currentLocation: null,
          isRefreshIP: false,
        );
        expect(result, ConnectionAction.connect);
      });

      test('returns refreshIP when isRefreshIP is true', () {
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: true,
        );
        expect(result, ConnectionAction.refreshIP);
      });

      test('returns disconnect when no requested location or intent', () {
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: false,
        );
        expect(result, ConnectionAction.disconnect);
      });

      test('returns disconnect when same location requested', () {
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: false,
          requestedLocation: currentLocation,
        );
        expect(result, ConnectionAction.disconnect);
      });

      test('returns disconnect when same intent requested', () {
        when(mockUserIntentsStore.userIntent).thenReturn(UserIntent.bestSpeed);
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: false,
          requestedIntent: UserIntent.bestSpeed,
        );
        expect(result, ConnectionAction.disconnect);
      });

      test('returns reconnect when different location requested', () {
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: false,
          requestedLocation: otherLocation,
        );
        expect(result, ConnectionAction.reconnect);
      });

      test('returns reconnect when different intent requested', () {
        when(mockUserIntentsStore.userIntent).thenReturn(UserIntent.p2p);
        final result = store.determineToggleAction(
          currentStatus: VpnConnectionStatus.connected,
          currentLocation: currentLocation,
          isRefreshIP: false,
          requestedIntent: UserIntent.bestSpeed,
        );
        expect(result, ConnectionAction.reconnect);
      });
    });

    group('determineConnectingLocation', () {
      const currentLocation = VPNLocation(
        id: 'us',
        ipType: IPType.residential,
        translations: {'en': 'US'},
        countryCode: 'US',
      );
      const requestedLocation = VPNLocation(
        id: 'de',
        ipType: IPType.residential,
        translations: {'en': 'DE'},
        countryCode: 'DE',
      );

      test('returns requestedLocation if provided', () {
        final result = store.determineConnectingLocation(
          requestedLocation: requestedLocation,
          currentLocation: currentLocation,
        );
        expect(result, requestedLocation);
      });

      test('returns currentLocation if isRefreshIP', () {
        final result = store.determineConnectingLocation(
          currentLocation: currentLocation,
          isRefreshIP: true,
        );
        expect(result, currentLocation);
      });

      test('returns null if intent is provided', () {
        final result = store.determineConnectingLocation(
          intent: UserIntent.bestSpeed,
        );
        expect(result, isNull);
      });

      test('returns potentialLocation as fallback', () {
        expect(store.determineConnectingLocation(), equals(VPNLocation.closest));
      });
    });

    test('shouldResolveClosestLocation returns true only for closest', () {
      expect(store.shouldResolveClosestLocation(VPNLocation.closest), isTrue);
      expect(store.shouldResolveClosestLocation(usLocation), isFalse);
      expect(store.shouldResolveClosestLocation(null), isFalse);
    });
  });
}
