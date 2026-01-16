import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'promotional_content_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockRemoteConfigStore mockRemoteConfigStore;
  late PromotionalContentStore store;

  setUp(() {
    mockRemoteConfigStore = MockRemoteConfigStore();
    store = PromotionalContentStore(mockRemoteConfigStore);
  });

  group('activeBanner', () {
    test('returns null when promotionalBanner is null', () {
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(null);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when no date constraints', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is before startDate', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now.add(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when current time is after startDate', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now.subtract(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is after endDate', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        endDate: now.subtract(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when current time is before endDate', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        endDate: now.add(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns banner when current time is between startDate and endDate', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now.subtract(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is before startDate with endDate set', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now.add(const Duration(hours: 1)),
        endDate: now.add(const Duration(hours: 2)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns null when current time is after endDate with startDate set', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now.subtract(const Duration(hours: 2)),
        endDate: now.subtract(const Duration(hours: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when startDate equals current time', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: now,
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when endDate equals current time', () {
      final now = DateTime.now();
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        endDate: now,
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      // isBefore and isAfter are exclusive, so at exact endDate it should still be null
      // This depends on your business logic - adjust if needed
      expect(store.activeBanner, isNull);
    });
  });
}
