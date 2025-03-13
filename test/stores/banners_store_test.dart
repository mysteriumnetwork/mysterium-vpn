import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/stores/banners_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

import 'banners_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  group('BannersStore', () {
    late BannersStore bannersStore;
    late MockApiService mockApiService;
    late MockSubscriptionStore mockSubscriptionStore;
    late MockLocationsStore mockLocationsStore;
    late MockAuthSessionStore mockAuthSessionStore;

    final mockDCLocations = VPNLocations(
      locations: [
        const VPNLocation(code: 'NL', ipType: IPType.datacenter),
        const VPNLocation(code: 'DE', ipType: IPType.datacenter),
      ],
    );

    setUp(() async {
      mockApiService = MockApiService();
      mockSubscriptionStore = MockSubscriptionStore();
      mockLocationsStore = MockLocationsStore();
      mockAuthSessionStore = MockAuthSessionStore();

      bannersStore = BannersStore(
        mockApiService,
        mockSubscriptionStore,
        mockLocationsStore,
        mockAuthSessionStore,
      );
    });

    group('banners', () {
      test('returns all banners when no banners are shown and not subscribed', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => <BannerType>[]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);
        when(mockLocationsStore.dcLocationsFuture).thenAnswer(
          (_) => ObservableFuture.value(mockDCLocations),
        );

        await bannersStore.shownBanners;

        expect(bannersStore.banners, BannerType.values);
      });

      test(
          'returns empty list when shown banners and subscription status are null and authentication status is authenticated',
          () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(null);
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

        await bannersStore.shownBanners;

        expect(bannersStore.banners, []);
      });

      test('excludes shown banners from the list', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => [BannerType.datacenter]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);
        when(mockLocationsStore.dcLocationsFuture).thenAnswer(
          (_) => ObservableFuture.value(mockDCLocations),
        );

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.datacenter).toList(),
        );
      });

      test('excludes subscription banner when subscribed', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(true);
        when(mockLocationsStore.dcLocationsFuture).thenAnswer(
          (_) => ObservableFuture.value(mockDCLocations),
        );
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.subscription).toList(),
        );
      });

      test('excludes datacenter banner when dataCenterCountries is empty', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockLocationsStore.dcLocationsFuture).thenAnswer(
          (_) => ObservableFuture.value(VPNLocations()),
        );
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.datacenter).toList(),
        );
      });

      test('excludes unauthenticated banner when authenticated', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockLocationsStore.dcLocationsFuture).thenAnswer(
          (_) => ObservableFuture.value(mockDCLocations),
        );
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.unauthenticated).toList(),
        );
      });
    });
  });
}
