// File: test/stores/user_intents_store_test.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/user_intents_store.dart';

import 'user_intents_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockApiService mockApi;
  late MockRealIPInfoStore mockRealIPInfo;
  late MockLocationsStore mockLocationsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  const mockNewYorkIPInfo = IPInfo(ip: 'ip', country: 'US', city: 'new_york');

  UserIntentsStore buildStore() => UserIntentsStore(
        mockApi,
        mockRealIPInfo,
        mockLocationsStore,
        mockRemoteConfigStore,
      );

  setUp(() {
    mockApi = MockApiService();
    mockRealIPInfo = MockRealIPInfoStore();
    mockLocationsStore = MockLocationsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();

    when(mockRemoteConfigStore.userIntentBlacklist).thenReturn(<UserIntent>{});
    when(mockRemoteConfigStore.userIntentsRefreshInterval).thenReturn(const Duration(minutes: 10));
  });

  group('Local intents', () {
    test('adds nearestLocation intent when country available', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(mockNewYorkIPInfo));
      when(mockLocationsStore.countryCodes).thenReturn({'US', 'CA'});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => const <UserIntent>{});

      final store = buildStore();
      await store.intentsFuture;

      expect(store.intents, contains(UserIntent.nearestLocation));
    });

    test('no nearestLocation when country not available', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(mockNewYorkIPInfo));
      when(mockLocationsStore.countryCodes).thenReturn({'CA'});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => const <UserIntent>{});

      final store = buildStore();
      await store.intentsFuture;

      expect(store.intents, isNot(contains(UserIntent.nearestLocation)));
    });

    test('no nearestLocation when country is available but the intent is blacklisted', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(mockNewYorkIPInfo));
      when(mockLocationsStore.countryCodes).thenReturn({'US', 'CA'});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => const <UserIntent>{});
      when(mockRemoteConfigStore.userIntentBlacklist).thenReturn({UserIntent.nearestLocation});

      final store = buildStore();
      await store.intentsFuture;

      expect(store.intents, isNot(contains(UserIntent.nearestLocation)));
    });
  });

  group('Remote intents', () {
    test('first remote emission applied', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(null));
      when(mockLocationsStore.countryCodes).thenReturn(<String>{});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => {UserIntent.p2p});

      final store = buildStore();
      await store.intentsFuture;

      expect(store.intents, contains(UserIntent.p2p));
    });
  });

  group('Union logic', () {
    test('remote + local merged', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(mockNewYorkIPInfo));
      when(mockLocationsStore.countryCodes).thenReturn({'US'});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => {UserIntent.p2p});

      final store = buildStore();
      await store.intentsFuture;

      expect(
        store.intents,
        equals({UserIntent.nearestLocation, UserIntent.p2p}),
      );
    });

    test('one side empty equals other', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(null));
      when(mockLocationsStore.countryCodes).thenReturn(<String>{});
      when(mockApi.fetchUserIntents()).thenAnswer((_) async => {UserIntent.p2p});

      final store = buildStore();
      await store.intentsFuture;

      expect(store.intents, equals({UserIntent.p2p}));
    });
  });

  group('Loading state', () {
    test('isLoading true until first remote completes', () async {
      when(mockRealIPInfo.infoFuture).thenAnswer((_) => ObservableFuture.value(mockNewYorkIPInfo));
      when(mockLocationsStore.countryCodes).thenReturn({'US'});
      final remoteCompleter = Completer<Set<UserIntent>>();
      when(mockApi.fetchUserIntents()).thenAnswer((_) => remoteCompleter.future);

      final store = buildStore();
      expect(store.intentsFuture.status == FutureStatus.pending, isTrue);

      remoteCompleter.complete(<UserIntent>{});
      await store.intentsFuture;

      expect(store.intentsFuture.status == FutureStatus.pending, isFalse);
    });
  });
}
