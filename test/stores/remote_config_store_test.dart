import 'package:configcat_client/configcat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:talker/talker.dart';

import 'remote_config_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ConfigCatClient>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
  MockSpec<RealIPInfoStore>(),
])
void main() {
  late RemoteConfigStore store;
  late MockConfigCatClient client;
  late MockTalker logger;
  late MockRealIPInfoStore ipInfoStore;

  setUp(() {
    client = MockConfigCatClient();
    logger = MockTalker();
    ipInfoStore = MockRealIPInfoStore();

    when(ipInfoStore.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(
        const IPInfo(ip: '192.168.1.1', country: 'LT', city: 'Vilnius'),
      ),
    );
    when(logger.handle(any, any)).thenAnswer((_) async {});
    when(logger.warning(any)).thenAnswer((_) async {});

    when(client.setDefaultUser(any)).thenAnswer((_) async {});
    when(client.forceRefresh()).thenAnswer((_) async => RefreshResult(true, null));
    when(client.getAllValues()).thenAnswer((_) async => {});
  });

  RemoteConfigStore createStore({bool isDev = true}) =>
      RemoteConfigStore(client, logger, ipInfoStore, isDev: isDev);

  group('RemoteConfigStore.cancelSubscriptionReasonKeys', () {
    test('returns null if config does not have the key', () async {
      store = createStore();
      await store.configFuture;
      expect(store.cancelSubscriptionReasonKeys, isNull);
    });

    test('returns set of strings if key exists and is array', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'cancelSurveyOptions': '["ReasonA", "ReasonB"]'},
      );
      await store.configFuture;
      expect(store.cancelSubscriptionReasonKeys, equals({'ReasonA', 'ReasonB'}));
    });

    test('handles invalid JSON gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'cancelSurveyOptions': '{not valid json'},
      );
      await store.configFuture;
      expect(() => store.cancelSubscriptionReasonKeys, throwsA(isA<MobXCaughtException>()));
    });

    test('handles non-iterable values gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {
          'cancelSurveyOptions': '"just a string"',
        },
      );

      await store.configFuture;
      expect(store.cancelSubscriptionReasonKeys, isNull);
    });
  });

  group('RemoteConfigStore.enableQaHelpers', () {
    test('returns value from config if present', () async {
      store = createStore();

      // Simulate config with enableQaHelpers set to true
      when(client.getAllValues()).thenAnswer(
        (_) async => {'enableQaHelpers': true},
      );
      await store.configFuture;
      expect(store.enableQaHelpers, isTrue);

      // Simulate config with enableQaHelpers set to false
      when(client.getAllValues()).thenAnswer(
        (_) async => {'enableQaHelpers': false},
      );
      // Re-create store to refresh config
      store = createStore();
      await store.configFuture;
      expect(store.enableQaHelpers, isFalse);
    });

    test('returns true if not in config but env is dev', () async {
      // Mock flavorConfig.env.isDev to true
      store = createStore();
      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.enableQaHelpers, isTrue);
    });

    test('returns false if not in config and env is not dev', () async {
      // Mock flavorConfig.env.isDev to false
      store = createStore(isDev: false);
      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.enableQaHelpers, isFalse);
    });
  });
}
