import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'promotional_content_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>()])
void main() {
  late MockRemoteConfigStore mockRemoteConfigStore;
  late PromotionalContentStore store;

  // Use fixed date for deterministic testing
  final fixedDate = DateTime(2026, 1, 16, 12);

  setUp(() {
    mockRemoteConfigStore = MockRemoteConfigStore();
    store = PromotionalContentStore(mockRemoteConfigStore, getCurrentTime: () => fixedDate);
  });

  group('activeBanner', () {
    test('returns null when promotionalBanner is null', () {
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(null);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when no date constraints', () {
      final banner = PromotionalBanner(id: '1', title: 'Test Banner');
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is before startDate', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: fixedDate.add(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when current time is after startDate', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: fixedDate.subtract(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is after endDate', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        endDate: fixedDate.subtract(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when current time is before endDate', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        endDate: fixedDate.add(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns banner when current time is between startDate and endDate', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: fixedDate.subtract(const Duration(days: 1)),
        endDate: fixedDate.add(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when current time is before startDate with endDate set', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: fixedDate.add(const Duration(days: 1)),
        endDate: fixedDate.add(const Duration(days: 2)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns null when current time is after endDate with startDate set', () {
      final banner = PromotionalBanner(
        id: '1',
        title: 'Test Banner',
        startDate: fixedDate.subtract(const Duration(days: 2)),
        endDate: fixedDate.subtract(const Duration(days: 1)),
      );
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });

    test('returns banner when startDate equals current time', () {
      final banner = PromotionalBanner(id: '1', title: 'Test Banner', startDate: fixedDate);
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, equals(banner));
    });

    test('returns null when endDate equals current time', () {
      final banner = PromotionalBanner(id: '1', title: 'Test Banner', endDate: fixedDate);
      when(mockRemoteConfigStore.promotionalBanner).thenReturn(banner);

      expect(store.activeBanner, isNull);
    });
  });
}
