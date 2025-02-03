import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/banners_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

class MockApiService extends Mock implements ApiService {}

class MockSubscriptionStore extends Mock implements SubscriptionStore {}

class MockRemoteConfigStore extends Mock implements RemoteConfigStore {}

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

      when(mockApiService.getShownBanners()).thenAnswer((_) async => []);

      bannersStore = BannersStore(mockApiService, mockSubscriptionStore, mockRemoteConfigStore);
      await bannersStore.shownBanners;
    });

    group('banners', () {
      test('returns all banners when no banners are shown and not subscribed', () async {
        print('W1');
        when(mockApiService.getShownBanners()).thenAnswer((_) async => <BannerType>[]);
        await Future.delayed(Duration.zero); // Allow MobX to react

        print('W2');
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        print('W3');
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn([]);

        print(await mockApiService.getShownBanners());

        expect(bannersStore.banners, BannerType.values);
      });

      test('returns empty list when shown banners and subscription status are null', () {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(null);

        expect(bannersStore.banners, []);
      });

      test('excludes shown banners from the list', () {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => [BannerType.subscription]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn([]);

        expect(bannersStore.banners,
            BannerType.values.where((b) => b != BannerType.subscription).toList());
      });

      test('excludes subscription banner when subscribed', () {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(true);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn([]);

        expect(bannersStore.banners,
            BannerType.values.where((b) => b != BannerType.subscription).toList());
      });

      test('excludes datacenter banner when dataCenterCountries is empty', () {
        when(mockApiService.getShownBanners()).thenAnswer((_) async => []);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockRemoteConfigStore.dataCenterCountries).thenReturn([]);

        expect(bannersStore.banners,
            BannerType.values.where((b) => b != BannerType.datacenter).toList());
      });
    });
  });
}
