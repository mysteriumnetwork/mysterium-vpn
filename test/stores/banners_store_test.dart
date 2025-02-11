import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/banners_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

import 'banners_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  group('BannersStore', () {
    late BannersStore bannersStore;
    late MockApiService mockApiService;
    late MockSubscriptionStore mockSubscriptionStore;
    late MockRemoteConfigStore mockRemoteConfigStore;

    setUp(() async {
      mockApiService = MockApiService();
      mockSubscriptionStore = MockSubscriptionStore();
      mockRemoteConfigStore = MockRemoteConfigStore();

      bannersStore = BannersStore(mockApiService, mockSubscriptionStore, mockRemoteConfigStore);
    });

    group('banners', () {
      test('returns all banners when no banners are shown and not subscribed', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => <BannerType>[]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn(['NL', 'DE']);

        await bannersStore.shownBanners;

        expect(bannersStore.banners, BannerType.values);
      });

      test('returns empty list when shown banners and subscription status are null', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(null);

        await bannersStore.shownBanners;

        expect(bannersStore.banners, []);
      });

      test('excludes shown banners from the list', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => [BannerType.datacenter]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn(['NL', 'DE']);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.datacenter).toList(),
        );
      });

      test('excludes subscription banner when subscribed', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(true);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn(['NL', 'DE']);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.subscription).toList(),
        );
      });

      test('excludes datacenter banner when dataCenterCountries is empty', () async {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn([]);

        await bannersStore.shownBanners;

        expect(
          bannersStore.banners,
          BannerType.values.where((b) => b != BannerType.datacenter).toList(),
        );
      });
    });
  });
}
