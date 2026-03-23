import 'package:configcat_client/configcat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'remote_config_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ConfigCatClient>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
  MockSpec<RealIPInfoStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<ConfigCatUser>(),
])
void main() {
  late RemoteConfigStore store;
  late MockConfigCatClient client;
  late MockTalker logger;
  late MockRealIPInfoStore ipInfoStore;
  late ConfigCatUser configCatUser;

  setUp(() async {
    client = MockConfigCatClient();
    logger = MockTalker();
    ipInfoStore = MockRealIPInfoStore();
    configCatUser = ConfigCatUser(identifier: 'mock');

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
      RemoteConfigStore(client, logger, isDev: isDev)..setUser(configCatUser);

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

  group('RemoteConfigStore.gatewaysSupportingUpgrade', () {
    test('returns parsed set if valid JSON array is provided', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '["stripe", "adyen", "paypal"]'},
      );
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'adyen', 'paypal'}),
      );
    });

    test('lowercases all keys from the array', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '["Stripe", "ADYEN", "PayPal"]'},
      );
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'adyen', 'paypal'}),
      );
    });

    test('returns default set if key is not present in config', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'adyen'}),
      );
    });

    test('returns default set if JSON is invalid', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '{not valid json'},
      );
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'adyen'}),
      );
    });

    test('returns default set if JSON is not an array', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '"just a string"'},
      );
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'adyen'}),
      );
    });

    test('handles empty array gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '[]'},
      );
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals(<String>{}));
    });

    test('handles array with null values gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'gatewaysSupportingUpgrade': '["stripe", null, "adyen"]'},
      );
      await store.configFuture;
      expect(
        store.gatewaysSupportingUpgrade,
        equals({'stripe', 'null', 'adyen'}),
      );
    });
  });

  group('RemoteConfigStore.checkoutWebRedirectUrl', () {
    test('returns parsed Uri if valid URL string is provided', () async {
      store = createStore();
      const testUrl = 'https://example.com/checkout';

      when(client.getAllValues()).thenAnswer(
        (_) async => {'checkoutWebRedirectUrl': testUrl},
      );
      await store.configFuture;
      expect(store.checkoutWebRedirectUrl, equals(Uri.parse(testUrl)));
    });

    test('returns default Uri if key is not present in config', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;

      // The default should be Uri.https(Env.webAppUrl, '/checkout/payment-upgrade')
      expect(store.checkoutWebRedirectUrl.path, contains('/checkout/payment-upgrade'));
      expect(store.checkoutWebRedirectUrl.scheme, equals('https'));
    });

    test('returns default Uri if URL parsing fails with invalid scheme', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'checkoutWebRedirectUrl': ':::invalid:::'},
      );
      await store.configFuture;

      expect(store.checkoutWebRedirectUrl.path, contains('/checkout/payment-upgrade'));
      expect(store.checkoutWebRedirectUrl.scheme, equals('https'));
    });

    test('handles relative path gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'checkoutWebRedirectUrl': '/checkout/custom'},
      );
      await store.configFuture;

      final uri = store.checkoutWebRedirectUrl;
      expect(uri.path, equals('/checkout/custom'));
    });

    test('handles URL with path segments correctly', () async {
      store = createStore();
      const testUrl = 'https://api.example.com/v1/checkout/payment';

      when(client.getAllValues()).thenAnswer(
        (_) async => {'checkoutWebRedirectUrl': testUrl},
      );
      await store.configFuture;

      final uri = store.checkoutWebRedirectUrl;
      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('api.example.com'));
      expect(uri.path, equals('/v1/checkout/payment'));
    });

    test('handles URL with query parameters correctly', () async {
      store = createStore();
      const testUrl = 'https://example.com/checkout?token=123&lang=en';

      when(client.getAllValues()).thenAnswer(
        (_) async => {'checkoutWebRedirectUrl': testUrl},
      );
      await store.configFuture;

      final uri = store.checkoutWebRedirectUrl;
      expect(uri.queryParameters['token'], equals('123'));
      expect(uri.queryParameters['lang'], equals('en'));
    });
  });

  group('RemoteConfigStore.hideReedemCode', () {
    test('returns false if key is not present in config (default)', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.hideReedemCode, isFalse);
    });

    test('returns true if config has true value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'hideReedemCode': true},
      );
      await store.configFuture;
      expect(store.hideReedemCode, isTrue);
    });

    test('returns false if config has false value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'hideReedemCode': false},
      );
      await store.configFuture;
      expect(store.hideReedemCode, isFalse);
    });
  });

  group('RemoteConfigStore.pricingMonthly', () {
    test('returns true if config has true value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'pricingMonthly': true},
      );
      await store.configFuture;
      expect(store.pricingMonthly, isTrue);
    });

    test('returns false if config has false value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'pricingMonthly': false},
      );
      await store.configFuture;
      expect(store.pricingMonthly, isFalse);
    });

    test('returns true if key is not present in config (default)', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.pricingMonthly, isTrue);
    });

    test('handles non-boolean values gracefully by type casting', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer(
        (_) async => {'pricingMonthly': 'true'},
      );
      await store.configFuture;

      // This will throw because the string 'true' cannot be cast to bool
      expect(
        () => store.pricingMonthly,
        throwsA(isA<MobXCaughtException>()),
      );
    });

    test('returns default true when config is empty', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.pricingMonthly, isTrue);
    });
  });
}
