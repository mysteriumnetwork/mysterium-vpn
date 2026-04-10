import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'banners_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<ConnectionsLimitStore>(),
  MockSpec<UpdateAvailableStore>(),
])
void main() {
  group('BannersStore', () {
    late BannersStore bannersStore;
    late MockLocalDBService mockLocalDBService;
    late MockSubscriptionStore mockSubscriptionStore;
    late MockAuthSessionStore mockAuthSessionStore;
    late MockConnectionsLimitStore mockConnectionsLimitStore;

    late MockUpdateAvailableStore mockUpdateAvailableStore;

    setUp(() async {
      mockLocalDBService = MockLocalDBService();
      mockSubscriptionStore = MockSubscriptionStore();
      mockAuthSessionStore = MockAuthSessionStore();
      mockConnectionsLimitStore = MockConnectionsLimitStore();

      when(mockLocalDBService.getShownBanners()).thenAnswer((_) async => <BannerType>[]);
      mockUpdateAvailableStore = MockUpdateAvailableStore();
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: false)));
      when(mockLocalDBService.getMainBanners()).thenAnswer((_) async => <BannerType>[]);
      when(mockSubscriptionStore.isSubscribed).thenReturn(true);
      when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);
      bannersStore = BannersStore(
        mockLocalDBService,
        mockSubscriptionStore,
        mockAuthSessionStore,
        mockConnectionsLimitStore,
        mockUpdateAvailableStore,
      );
    });

    group('banners', () {
      test('returns all banners when no banners are shown and not subscribed', () async {
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, BannerType.mainBanners);
      });

      test('returns empty list when shown banners and subscription status are null', () async {
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);
        when(mockSubscriptionStore.isSubscribed).thenReturn(null);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, []);
      });

      test('excludes shown banners from the list', () async {
        when(
          mockLocalDBService.getMainBanners(),
        ).thenAnswer((_) async => [BannerType.highSpeedIPs]);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.highSpeedIPs).toList(),
        );
      });

      test('excludes subscription banner when subscribed', () async {
        await bannersStore.shownBanners;
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.subscription).toList(),
        );
      });

      test('excludes tooManyConnections banner when connectionLimitReached is false', () async {
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(false);
        await bannersStore.shownBanners;

        expect(
          bannersStore.mainBanners,
          BannerType.mainBanners.where((b) => b != BannerType.tooManyConnections).toList(),
        );
      });

      test('includes unauthenticated banner when user is unauthenticated', () async {
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, contains(BannerType.unauthenticated));
      });

      test('excludes unauthenticated banner when user is authenticated', () async {
        when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, isNot(contains(BannerType.unauthenticated)));
      });

      test('includes appUpdateAvailable banner when update is available', () async {
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(true);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, contains(BannerType.appUpdateAvailable));
      });

      test('excludes appUpdateAvailable banner when no update is available', () async {
        when(mockUpdateAvailableStore.appUpdateAvailable).thenReturn(false);
        when(mockSubscriptionStore.isSubscribed).thenReturn(false);
        when(mockConnectionsLimitStore.connectionLimitReached).thenReturn(true);

        await bannersStore.shownBanners;

        expect(bannersStore.mainBanners, isNot(contains(BannerType.appUpdateAvailable)));
      });
    });
  });
}
