import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/banners_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

import 'banners_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<FlavorConfig>(),
])
void main() {
  group('BannersStore', () {
    late BannersStore bannersStore;
    late MockLocalDBService mockLocalDBService;
    late MockSubscriptionStore mockSubscriptionStore;
    late MockLocationsStore mockLocationsStore;
    late MockAuthSessionStore mockAuthSessionStore;
    late MockRemoteConfigStore mockRemoteConfigStore;
    late MockFlavorConfig mockFlavorConfig;
    final mockDCLocations = VPNLocations(
      locations: [
        const VPNLocation(code: 'NL', ipType: IPType.datacenter),
        const VPNLocation(code: 'DE', ipType: IPType.datacenter),
      ],
    );

    setUp(() async {
      mockLocalDBService = MockLocalDBService();
      mockSubscriptionStore = MockSubscriptionStore();
      mockLocationsStore = MockLocationsStore();
      mockAuthSessionStore = MockAuthSessionStore();
      mockRemoteConfigStore = MockRemoteConfigStore();
      mockFlavorConfig = MockFlavorConfig();

      when(mockLocalDBService.getMainBanners()).thenAnswer((_) async => <BannerType>[]);
      when(mockSubscriptionStore.isSubscribed).thenReturn(true);
      when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);
      when(mockLocationsStore.dcLocationsStream).thenAnswer(
        (_) => ObservableStream(Stream.value(mockDCLocations), initialValue: mockDCLocations),
      );
      when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');
      when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '0.0.0'));

      bannersStore = BannersStore(
        mockLocalDBService,
        mockSubscriptionStore,
        mockLocationsStore,
        mockAuthSessionStore,
        mockRemoteConfigStore,
        mockFlavorConfig,
      );
    });

    group('banners', () {
      test('returns all banners when no banners are shown and not subscribed', () async {
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.1');

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, BannerType.mainBanners);
      });

      test('returns empty list when shown banners and subscription status are null', () async {
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);
        when(mockSubscriptionStore.isSubscribed).thenReturn(null);
        when(mockLocationsStore.dcLocationsStream).thenAnswer(
          (_) => ObservableStream(Stream.value(VPNLocations()), initialValue: VPNLocations()),
        );

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, []);
      });

      test('excludes shown banners from the list', () async {
        when(mockLocalDBService.getMainBanners()).thenAnswer((_) async => [BannerType.datacenter]);
        when(mockLocationsStore.dcLocationsStream).thenAnswer(
          (_) => ObservableStream(Stream.value(VPNLocations()), initialValue: VPNLocations()),
        );
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.1');

        await bannersStore.shownBanners;

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.datacenter).toList(),
        );
      });

      test('excludes subscription banner when subscribed', () async {
        await bannersStore.shownBanners;
        when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.1');

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.subscription).toList(),
        );
      });

      test('excludes datacenter banner when dataCenterCountries is empty', () async {
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockLocationsStore.dcLocationsStream).thenAnswer(
          (_) => ObservableStream(Stream.value(VPNLocations()), initialValue: VPNLocations()),
        );
        when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.1');
        await bannersStore.shownBanners;

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.datacenter).toList(),
        );
      });
    });
  });
}
