import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'favorite_ips_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<FavoriteIpsAvailabilityService>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  late MockLocalDBService mockDB;
  late MockFavoriteIpsAvailabilityService mockAvailability;
  late MockSubscriptionStore mockSubscription;
  late MockRemoteConfigStore mockRemoteConfig;
  late MockAnalyticsStore mockAnalytics;
  late StreamController<List<FavoriteIp>> dbChanges;
  late List<FavoriteIp> saved;

  FavoriteIp fav(String ip, {IPType ipType = IPType.residential}) => FavoriteIp(
    ip: ip,
    countryCode: 'al',
    city: 'Tirana',
    ipType: ipType,
    savedAt: DateTime.utc(2026, 8, 5),
  );

  FavoriteIpsStore buildStore() {
    final store = FavoriteIpsStore(
      mockDB,
      mockAvailability,
      mockSubscription,
      mockRemoteConfig,
      mockAnalytics,
    );
    addTearDown(store.dispose);
    return store;
  }

  setUp(() {
    mockDB = MockLocalDBService();
    mockAvailability = MockFavoriteIpsAvailabilityService();
    mockSubscription = MockSubscriptionStore();
    mockRemoteConfig = MockRemoteConfigStore();
    mockAnalytics = MockAnalyticsStore();
    dbChanges = StreamController<List<FavoriteIp>>.broadcast();
    saved = [];

    when(mockDB.getFavoriteIps()).thenAnswer((_) async => saved);
    when(mockDB.watchFavoriteIps()).thenAnswer((_) => dbChanges.stream);
    when(mockDB.setFavoriteIps(any)).thenAnswer((invocation) async {
      saved = invocation.positionalArguments.first as List<FavoriteIp>;
      dbChanges.add(saved);
    });
    when(mockSubscription.favoriteIpsAllowed).thenReturn(true);
    when(mockSubscription.favoriteIpsLimit).thenReturn(5);
    when(mockRemoteConfig.favoriteLocationsEnabled).thenReturn(true);
    when(mockAvailability.checkAvailability(any)).thenAnswer((_) async => {});
  });

  tearDown(() async {
    await dbChanges.close();
  });

  group('loading', () {
    test('loads favorites from db', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();

      await store.future;

      expect(store.favorites.map((it) => it.ip), ['1.1.1.1']);
    });

    test('db watch stream updates favorites', () async {
      final store = buildStore();
      await store.future;

      dbChanges.add([fav('2.2.2.2')]);
      await Future<void>.delayed(Duration.zero);

      expect(store.favorites.map((it) => it.ip), ['2.2.2.2']);
    });
  });

  group('add', () {
    test('prepends new favorite and logs add event', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.add(fav('2.2.2.2')), isTrue);

      expect(saved.map((it) => it.ip), ['2.2.2.2', '1.1.1.1']);
      verify(mockAnalytics.logFavoriteIpAdd(any, favoriteIpCount: 1)).called(1);
    });

    test('duplicate ip is a no-op', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.add(fav('1.1.1.1')), isFalse);

      expect(saved.map((it) => it.ip), ['1.1.1.1']);
      verifyNever(
        mockAnalytics.logFavoriteIpAdd(any, favoriteIpCount: anyNamed('favoriteIpCount')),
      );
    });

    test('at limit sets limitReached notice and does not save', () async {
      when(mockSubscription.favoriteIpsLimit).thenReturn(2);
      saved = [fav('1.1.1.1'), fav('2.2.2.2')];
      final store = buildStore();
      await store.future;

      expect(await store.add(fav('3.3.3.3')), isFalse);

      expect(saved.length, 2);
      expect(store.notice, FavoriteIpsNotice.limitReached);
      store.clearNotice();
      expect(store.notice, isNull);
    });

    test('logs the add tap even when the limit rejects it', () async {
      when(mockSubscription.favoriteIpsLimit).thenReturn(1);
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.add(fav('2.2.2.2')), isFalse);

      // The event is the tap, so hitting the limit stays measurable.
      verify(mockAnalytics.logFavoriteIpAdd(any, favoriteIpCount: 1)).called(1);
    });

    test('canAddMore respects the plan limit', () async {
      when(mockSubscription.favoriteIpsLimit).thenReturn(1);
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(store.canAddMore, isFalse);
    });
  });

  group('remove & undo', () {
    test('removes favorite and logs removed event', () async {
      saved = [fav('1.1.1.1'), fav('2.2.2.2')];
      final store = buildStore();
      await store.future;

      await store.remove('1.1.1.1');

      expect(saved.map((it) => it.ip), ['2.2.2.2']);
      verify(
        mockAnalytics.logFavoriteIpRemoved(any, favoriteIpCount: 1, availabilityState: 'available'),
      ).called(1);
    });

    test('remove of unknown ip is a no-op', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      await store.remove('9.9.9.9');

      expect(saved.map((it) => it.ip), ['1.1.1.1']);
      verifyNever(
        mockAnalytics.logFavoriteIpRemoved(
          any,
          favoriteIpCount: anyNamed('favoriteIpCount'),
          availabilityState: anyNamed('availabilityState'),
        ),
      );
    });

    test('undoRemove restores the last removed favorite and logs undo', () async {
      saved = [fav('1.1.1.1'), fav('2.2.2.2')];
      final store = buildStore();
      await store.future;

      await store.remove('1.1.1.1');
      expect(await store.undoRemove(), isTrue);

      expect(saved.map((it) => it.ip), ['1.1.1.1', '2.2.2.2']);
      verify(mockAnalytics.logFavoriteIpUndoRemove()).called(1);
    });

    test('undoRemove without a prior remove is a no-op', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.undoRemove(), isFalse);

      expect(saved.map((it) => it.ip), ['1.1.1.1']);
      verifyNever(mockAnalytics.logFavoriteIpUndoRemove());
    });
  });

  group('availability', () {
    test('refreshAvailability splits available and unavailable favorites', () async {
      saved = [fav('1.1.1.1'), fav('2.2.2.2')];
      when(
        mockAvailability.checkAvailability(any),
      ).thenAnswer((_) async => {'1.1.1.1': true, '2.2.2.2': false});
      final store = buildStore();
      await store.future;

      await store.refreshAvailability();

      expect(store.availableFavorites.map((it) => it.ip), ['1.1.1.1']);
      expect(store.unavailableFavorites.map((it) => it.ip), ['2.2.2.2']);
      verify(mockAnalytics.logFavoriteIpUnavailableShown(any, favoriteIpCount: 2)).called(1);
    });

    test('refreshAvailability does not re-log unavailable on a TTL cache hit', () async {
      saved = [fav('1.1.1.1')];
      when(mockAvailability.checkAvailability(any)).thenAnswer((_) async => {'1.1.1.1': false});
      final store = buildStore();
      await store.future;

      await store.refreshAvailability();
      await store.refreshAvailability();

      verify(mockAnalytics.logFavoriteIpUnavailableShown(any, favoriteIpCount: 1)).called(1);
    });

    test('unavailable analytics use the favorites snapshot from before the request', () async {
      saved = [fav('1.1.1.1')];
      final completer = Completer<Map<String, bool>>();
      when(mockAvailability.checkAvailability(any)).thenAnswer((_) => completer.future);
      final store = buildStore();
      await store.future;

      final refresh = store.refreshAvailability();
      await store.add(fav('2.2.2.2'));
      completer.complete({'1.1.1.1': false});
      await refresh;

      // Count/IPs must match the pre-await snapshot, not the list after add.
      verify(mockAnalytics.logFavoriteIpUnavailableShown(any, favoriteIpCount: 1)).called(1);
    });

    test('favorites are available by default before any check', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(store.availableFavorites.map((it) => it.ip), ['1.1.1.1']);
      expect(store.unavailableFavorites, isEmpty);
    });

    test('does not auto-check availability on load or list changes', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;
      await store.add(fav('2.2.2.2'));
      await Future<void>.delayed(Duration.zero);

      // Refreshing is owned by the tab visit / explicit refresh — the
      // user-data stream fires on unrelated writes too.
      verifyNever(mockAvailability.checkAvailability(any));
    });

    test('refreshAvailability skips the request when the feature is disabled', () async {
      when(mockSubscription.favoriteIpsAllowed).thenReturn(false);
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.refreshAvailability(), isTrue);

      verifyNever(mockAvailability.checkAvailability(any));
    });

    test('a fresh result is reused instead of re-requesting (remount safety)', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      await store.refreshAvailability();
      await store.refreshAvailability();

      verify(mockAvailability.checkAvailability(any)).called(1);
    });

    test('an explicit (forced) refresh always hits the backend', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      await store.refreshAvailability();
      await store.refreshAvailability(force: true);

      verify(mockAvailability.checkAvailability(any)).called(2);
    });

    test('a changed favorites list bypasses the freshness window', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;
      await store.refreshAvailability();

      await store.add(fav('2.2.2.2'));
      await store.refreshAvailability();

      verify(mockAvailability.checkAvailability(any)).called(2);
    });

    test('concurrent refreshes share one request', () async {
      saved = [fav('1.1.1.1')];
      final completer = Completer<Map<String, bool>>();
      when(mockAvailability.checkAvailability(any)).thenAnswer((_) => completer.future);
      final store = buildStore();
      await store.future;

      final first = store.refreshAvailability();
      final second = store.refreshAvailability();
      completer.complete({'1.1.1.1': true});
      expect(await first, isTrue);
      expect(await second, isTrue);

      verify(mockAvailability.checkAvailability(any)).called(1);
    });

    test('refreshAvailability reports success', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(await store.refreshAvailability(), isTrue);

      when(mockAvailability.checkAvailability(any)).thenThrow(Exception('network'));
      // force: the previous success is still inside the freshness window.
      expect(await store.refreshAvailability(force: true), isFalse);
    });

    test('recordConnectOutcome logs success when the connection landed on the ip', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      store.recordConnectOutcome(fav('1.1.1.1'), connectedIp: '1.1.1.1');

      expect(store.unavailableFavorites, isEmpty);
      verify(mockAnalytics.logFavoriteIpConnectionSucceeded(any, favoriteIpCount: 1)).called(1);
    });

    test('recordConnectOutcome marks the favorite unavailable on any other outcome', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      store.recordConnectOutcome(fav('1.1.1.1'), connectedIp: null);

      expect(store.unavailableFavorites.map((it) => it.ip), ['1.1.1.1']);
      verify(mockAnalytics.logFavoriteIpUnknownShown(any, favoriteIpCount: 1)).called(1);
      verifyNever(
        mockAnalytics.logFavoriteIpUnavailableShown(
          any,
          favoriteIpCount: anyNamed('favoriteIpCount'),
        ),
      );
    });

    test('markUnavailable moves a favorite to the unavailable list', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      store.markUnavailable('1.1.1.1');

      expect(store.unavailableFavorites.map((it) => it.ip), ['1.1.1.1']);
    });

    test('failed refresh keeps the previous availability map', () async {
      saved = [fav('1.1.1.1')];
      when(mockAvailability.checkAvailability(any)).thenAnswer((_) async => {'1.1.1.1': false});
      final store = buildStore();
      await store.future;
      await store.refreshAvailability();

      when(mockAvailability.checkAvailability(any)).thenThrow(Exception('network'));
      await store.refreshAvailability(force: true);

      expect(store.unavailableFavorites.map((it) => it.ip), ['1.1.1.1']);
    });
  });

  group('connectingIp', () {
    test('tracks the in-flight connect target', () async {
      final store = buildStore();
      await store.future;

      expect(store.connectingIp, isNull);

      store.setConnectingIp('1.1.1.1');
      expect(store.connectingIp, '1.1.1.1');

      store.setConnectingIp(null);
      expect(store.connectingIp, isNull);
    });
  });

  group('clear', () {
    test('removes every favorite', () async {
      saved = [fav('1.1.1.1'), fav('2.2.2.2')];
      final store = buildStore();
      await store.future;

      await store.clear();

      expect(saved, isEmpty);
    });
  });

  group('gating', () {
    test('isEnabled requires both the kill-switch and the plan allowance', () async {
      final store = buildStore();

      expect(store.isEnabled, isTrue);

      when(mockRemoteConfig.favoriteLocationsEnabled).thenReturn(false);
      expect(store.isEnabled, isFalse);

      when(mockRemoteConfig.favoriteLocationsEnabled).thenReturn(true);
      when(mockSubscription.favoriteIpsAllowed).thenReturn(false);
      expect(store.isEnabled, isFalse);
    });
  });

  group('isFavorite', () {
    test('true only for saved ips', () async {
      saved = [fav('1.1.1.1')];
      final store = buildStore();
      await store.future;

      expect(store.isFavorite('1.1.1.1'), isTrue);
      expect(store.isFavorite('9.9.9.9'), isFalse);
    });
  });
}
