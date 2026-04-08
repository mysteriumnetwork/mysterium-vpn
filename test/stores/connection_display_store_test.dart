import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'connection_display_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<SelectedLocationStore>(),
  MockSpec<UnavailableLocationsStore>(),
])
void main() {
  late ConnectionDisplayStore store;
  late MockVpnStore mockVpnStore;
  late MockLocationsStore mockLocationsStore;
  late MockSelectedLocationStore mockSelectedLocationStore;
  late MockUnavailableLocationsStore mockUnavailableLocationsStore;

  setUp(() {
    mockVpnStore = MockVpnStore();
    mockLocationsStore = MockLocationsStore();
    mockSelectedLocationStore = MockSelectedLocationStore();
    mockUnavailableLocationsStore = MockUnavailableLocationsStore();
    store = ConnectionDisplayStore(
      mockVpnStore,
      mockLocationsStore,
      mockSelectedLocationStore,
      mockUnavailableLocationsStore,
    );
  });

  group('ConnectionDisplayStore', () {
    group('hasDifferentSelection', () {
      const locationDE = VPNLocation(
        id: 'DE',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'DE',
      );

      const locationFR = VPNLocation(
        id: 'FR',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'FR',
      );

      const cityDE = VPNLocation(
        id: 'DE-HH',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'DE',
      );

      test('returns false when not connected', () {
        when(mockVpnStore.isConnected).thenReturn(false);
        when(mockSelectedLocationStore.value).thenReturn(locationFR);
        when(mockVpnStore.location).thenReturn(locationDE);

        expect(store.hasDifferentSelection, isFalse);
      });

      test('returns false when selected is null', () {
        when(mockVpnStore.isConnected).thenReturn(true);
        when(mockSelectedLocationStore.value).thenReturn(null);
        when(mockVpnStore.location).thenReturn(locationDE);

        expect(store.hasDifferentSelection, isFalse);
      });

      test('returns false when connected is null', () {
        when(mockVpnStore.isConnected).thenReturn(true);
        when(mockSelectedLocationStore.value).thenReturn(locationFR);
        when(mockVpnStore.location).thenReturn(null);

        expect(store.hasDifferentSelection, isFalse);
      });

      test('returns false when connected == VPNLocation.closest', () {
        when(mockVpnStore.isConnected).thenReturn(true);
        when(mockSelectedLocationStore.value).thenReturn(locationDE);
        when(mockVpnStore.location).thenReturn(VPNLocation.closest);

        expect(store.hasDifferentSelection, isFalse);
      });

      test('returns false when selected.id == connected.id', () {
        when(mockVpnStore.isConnected).thenReturn(true);
        when(mockSelectedLocationStore.value).thenReturn(locationDE);
        when(mockVpnStore.location).thenReturn(locationDE);

        expect(store.hasDifferentSelection, isFalse);
      });

      test(
        'returns false when selected is a country matching connected countryCode',
        () {
          // locationDE has id == countryCode == 'DE', so isCountry is true.
          // cityDE has countryCode 'DE' but a different id.
          when(mockVpnStore.isConnected).thenReturn(true);
          when(mockSelectedLocationStore.value).thenReturn(locationDE);
          when(mockVpnStore.location).thenReturn(cityDE);

          expect(store.hasDifferentSelection, isFalse);
        },
      );

      test('returns true when selected differs from connected', () {
        when(mockVpnStore.isConnected).thenReturn(true);
        when(mockSelectedLocationStore.value).thenReturn(locationFR);
        when(mockVpnStore.location).thenReturn(locationDE);

        expect(store.hasDifferentSelection, isTrue);
      });
    });
  });
}
