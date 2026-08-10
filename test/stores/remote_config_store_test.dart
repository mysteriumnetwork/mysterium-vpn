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
      (_) =>
          ObservableFuture.value(const IPInfo(ip: '192.168.1.1', country: 'LT', city: 'Vilnius')),
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

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'cancelSurveyOptions': '["ReasonA", "ReasonB"]'});
      await store.configFuture;
      expect(store.cancelSubscriptionReasonKeys, equals({'ReasonA', 'ReasonB'}));
    });

    test('handles invalid JSON gracefully', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'cancelSurveyOptions': '{not valid json'});
      await store.configFuture;
      expect(() => store.cancelSubscriptionReasonKeys, throwsA(isA<MobXCaughtException>()));
    });

    test('handles non-iterable values gracefully', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'cancelSurveyOptions': '"just a string"'});

      await store.configFuture;
      expect(store.cancelSubscriptionReasonKeys, isNull);
    });
  });

  group('RemoteConfigStore.subscriptionPauseDurations', () {
    test('returns empty map when key is missing', () async {
      store = createStore();
      await store.configFuture;
      expect(store.subscriptionPauseDurations, isEmpty);
    });

    test('returns empty map for empty JSON object', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer((_) async => {'subscriptionPauseDurations': '{}'});
      await store.configFuture;
      expect(store.subscriptionPauseDurations, isEmpty);
    });

    test('parses months to API period codes', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'subscriptionPauseDurations': '{"1":"1m","3":"3m","6":"6m"}'});
      await store.configFuture;
      expect(store.subscriptionPauseDurations, equals({1: '1m', 3: '3m', 6: '6m'}));
    });

    test('skips invalid month keys and empty period codes', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer(
        (_) async => {'subscriptionPauseDurations': '{"1":"1m","x":"3m","3":"","6":"6m"}'},
      );
      await store.configFuture;
      expect(store.subscriptionPauseDurations, equals({1: '1m', 6: '6m'}));
    });

    test('returns empty map for invalid JSON', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'subscriptionPauseDurations': '{not valid json'});
      await store.configFuture;
      expect(store.subscriptionPauseDurations, isEmpty);
    });

    test('returns empty map for non-map JSON', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'subscriptionPauseDurations': '["1m","3m"]'});
      await store.configFuture;
      expect(store.subscriptionPauseDurations, isEmpty);
    });
  });

  group('RemoteConfigStore.pauseSubscriptionEnabled', () {
    test('returns the config value when present', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'pauseSubscriptionEnabled': true});
      store = createStore();
      await store.configFuture;
      expect(store.pauseSubscriptionEnabled, isTrue);
    });

    test('defaults to false when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.pauseSubscriptionEnabled, isFalse);
    });

    test('defaults to false when value has the wrong type', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'pauseSubscriptionEnabled': 'yes'});
      store = createStore();
      await store.configFuture;
      expect(store.pauseSubscriptionEnabled, isFalse);
    });
  });

  group('RemoteConfigStore.enableQaHelpers', () {
    test('returns value from config if present', () async {
      store = createStore();

      // Simulate config with enableQaHelpers set to true
      when(client.getAllValues()).thenAnswer((_) async => {'enableQaHelpers': true});
      await store.configFuture;
      expect(store.enableQaHelpers, isTrue);

      // Simulate config with enableQaHelpers set to false
      when(client.getAllValues()).thenAnswer((_) async => {'enableQaHelpers': false});
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

  group('RemoteConfigStore.locationsPullToRefreshEnabled', () {
    test('returns value from config if present', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'locationsPullToRefreshEnabled': false});
      store = createStore();
      await store.configFuture;
      expect(store.locationsPullToRefreshEnabled, isFalse);
    });

    test('defaults to true when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.locationsPullToRefreshEnabled, isTrue);
    });

    test('defaults to true when value has the wrong type', () async {
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'locationsPullToRefreshEnabled': 'nope'});
      store = createStore();
      await store.configFuture;
      expect(store.locationsPullToRefreshEnabled, isTrue);
    });
  });

  group('RemoteConfigStore.favoriteLocationsEnabled', () {
    test('returns the config value when present', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'favoriteLocationsEnabled': true});
      store = createStore();
      await store.configFuture;
      expect(store.favoriteLocationsEnabled, isTrue);
    });

    test('defaults to false when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.favoriteLocationsEnabled, isFalse);
    });

    test('defaults to false when value has the wrong type', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'favoriteLocationsEnabled': 'yes'});
      store = createStore();
      await store.configFuture;
      expect(store.favoriteLocationsEnabled, isFalse);
    });
  });

  group('RemoteConfigStore.newsCenterEnabled', () {
    test('returns the config value when present (false acts as a kill switch)', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'newsCenterEnabled': false});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterEnabled, isFalse);
    });

    test('defaults to true when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterEnabled, isTrue);
    });

    test('defaults to true when value has the wrong type', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'newsCenterEnabled': 'yes'});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterEnabled, isTrue);
    });
  });

  group('RemoteConfigStore.newsCenterRefreshIntervalMinutes', () {
    test('returns the config value when present (0 disables auto-refresh)', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'newsCenterRefreshIntervalMinutes': 0});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterRefreshIntervalMinutes, 0);
    });

    test('returns a valid positive value', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'newsCenterRefreshIntervalMinutes': 15});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterRefreshIntervalMinutes, 15);
    });

    test('defaults to 30 when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterRefreshIntervalMinutes, 30);
    });

    test('defaults to 30 when value has the wrong type', () async {
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'newsCenterRefreshIntervalMinutes': '15'});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterRefreshIntervalMinutes, 30);
    });

    test('defaults to 30 when value is negative (out of range)', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'newsCenterRefreshIntervalMinutes': -5});
      store = createStore();
      await store.configFuture;
      expect(store.newsCenterRefreshIntervalMinutes, 30);
    });
  });

  group('RemoteConfigStore.locationsRefreshButtonEnabled', () {
    test('returns value from config if present', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'locationsRefreshButtonEnabled': false});
      store = createStore();
      await store.configFuture;
      expect(store.locationsRefreshButtonEnabled, isFalse);
    });

    test('defaults to true when not in config', () async {
      when(client.getAllValues()).thenAnswer((_) async => {});
      store = createStore();
      await store.configFuture;
      expect(store.locationsRefreshButtonEnabled, isTrue);
    });

    test('defaults to true when value has the wrong type', () async {
      when(client.getAllValues()).thenAnswer((_) async => {'locationsRefreshButtonEnabled': 1});
      store = createStore();
      await store.configFuture;
      expect(store.locationsRefreshButtonEnabled, isTrue);
    });
  });

  group('RemoteConfigStore.gatewaysSupportingUpgrade', () {
    test('returns parsed set if valid JSON array is provided', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '["stripe", "adyen", "paypal"]'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'adyen', 'paypal'}));
    });

    test('lowercases all keys from the array', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '["Stripe", "ADYEN", "PayPal"]'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'adyen', 'paypal'}));
    });

    test('returns default set if key is not present in config', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'adyen', 'primer'}));
    });

    test('returns default set if JSON is invalid', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '{not valid json'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'adyen', 'primer'}));
    });

    test('returns default set if JSON is not an array', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '"just a string"'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'adyen', 'primer'}));
    });

    test('handles empty array gracefully', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '[]'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals(<String>{}));
    });

    test('handles array with null values gracefully', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'gatewaysSupportingUpgrade': '["stripe", null, "adyen"]'});
      await store.configFuture;
      expect(store.gatewaysSupportingUpgrade, equals({'stripe', 'null', 'adyen'}));
    });
  });

  group('RemoteConfigStore.checkoutWebRedirectUrl', () {
    test('returns parsed Uri if valid URL string is provided', () async {
      store = createStore();
      const testUrl = 'https://example.com/checkout';

      when(client.getAllValues()).thenAnswer((_) async => {'checkoutWebRedirectUrl': testUrl});
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

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'checkoutWebRedirectUrl': ':::invalid:::'});
      await store.configFuture;

      expect(store.checkoutWebRedirectUrl.path, contains('/checkout/payment-upgrade'));
      expect(store.checkoutWebRedirectUrl.scheme, equals('https'));
    });

    test('handles relative path gracefully', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'checkoutWebRedirectUrl': '/checkout/custom'});
      await store.configFuture;

      final uri = store.checkoutWebRedirectUrl;
      expect(uri.path, equals('/checkout/custom'));
    });

    test('handles URL with path segments correctly', () async {
      store = createStore();
      const testUrl = 'https://api.example.com/v1/checkout/payment';

      when(client.getAllValues()).thenAnswer((_) async => {'checkoutWebRedirectUrl': testUrl});
      await store.configFuture;

      final uri = store.checkoutWebRedirectUrl;
      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('api.example.com'));
      expect(uri.path, equals('/v1/checkout/payment'));
    });

    test('handles URL with query parameters correctly', () async {
      store = createStore();
      const testUrl = 'https://example.com/checkout?token=123&lang=en';

      when(client.getAllValues()).thenAnswer((_) async => {'checkoutWebRedirectUrl': testUrl});
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

      when(client.getAllValues()).thenAnswer((_) async => {'hideReedemCode': true});
      await store.configFuture;
      expect(store.hideReedemCode, isTrue);
    });

    test('returns false if config has false value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'hideReedemCode': false});
      await store.configFuture;
      expect(store.hideReedemCode, isFalse);
    });
  });

  group('RemoteConfigStore.pricingMonthly', () {
    test('returns true if config has true value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'pricingMonthly': true});
      await store.configFuture;
      expect(store.pricingMonthly, isTrue);
    });

    test('returns false if config has false value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'pricingMonthly': false});
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

      when(client.getAllValues()).thenAnswer((_) async => {'pricingMonthly': 'true'});
      await store.configFuture;

      // This will throw because the string 'true' cannot be cast to bool
      expect(() => store.pricingMonthly, throwsA(isA<MobXCaughtException>()));
    });

    test('returns default true when config is empty', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.pricingMonthly, isTrue);
    });
  });

  group('RemoteConfigStore.residentialEducationConnectThreshold', () {
    test('returns 2 if key is not present in config (default)', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.residentialEducationConnectThreshold, 2);
    });

    test('returns config value when a positive int', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialEducationConnectThreshold': 3});
      await store.configFuture;
      expect(store.residentialEducationConnectThreshold, 3);
    });

    test('falls back to default when value is zero or negative', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialEducationConnectThreshold': 0});
      await store.configFuture;
      expect(store.residentialEducationConnectThreshold, 2);
    });

    test('falls back to default when value is not an int', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialEducationConnectThreshold': '3'});
      await store.configFuture;
      expect(store.residentialEducationConnectThreshold, 2);
    });
  });

  group('RemoteConfigStore.residentialReminderInterval', () {
    test('returns 30 days if key is not present in config (default)', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.residentialReminderInterval, const Duration(days: 30));
    });

    test('interprets the config value as minutes', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialReminderIntervalMinutes': 2});
      await store.configFuture;
      expect(store.residentialReminderInterval, const Duration(minutes: 2));
    });

    test('falls back to default when value is zero or negative', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialReminderIntervalMinutes': 0});
      await store.configFuture;
      expect(store.residentialReminderInterval, const Duration(days: 30));
    });

    test('falls back to default when value is not an int', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'residentialReminderIntervalMinutes': '5'});
      await store.configFuture;
      expect(store.residentialReminderInterval, const Duration(days: 30));
    });
  });

  group('RemoteConfigStore.canShowNoSubsOnboardingFlow', () {
    test('returns true if key is not present in config (default)', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.canShowNoSubsOnboardingFlow, isTrue);
    });

    test('returns true if config has true value', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'canShowNoSubsOnboardingFlow': true});
      await store.configFuture;
      expect(store.canShowNoSubsOnboardingFlow, isTrue);
    });

    test('returns false if config has false value (kill switch flipped)', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {'canShowNoSubsOnboardingFlow': false});
      await store.configFuture;
      expect(store.canShowNoSubsOnboardingFlow, isFalse);
    });
  });

  group('RemoteConfigStore.reviewPromptConfig', () {
    test('returns defaults when key is absent', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      final config = store.reviewPromptConfig;
      expect(config.enabled, isTrue);
      expect(config.minAccountAgeMinutes, 10080);
      expect(config.minAppOpens, 5);
      expect(config.minConnections, 10);
      expect(config.cleanSessionsRequired, 3);
      expect(config.stableSessionSeconds, 60);
      expect(config.cooldownDismissMinutes, 43200);
      expect(config.cooldownNegativeMinutes, 108000);
      expect(config.cooldownPositiveMinutes, 151200);
      expect(config.yearlyCap, 3);
    });

    test('parses a full JSON payload', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer(
        (_) async => {
          'reviewPromptConfig':
              '{"enabled":false,"minAccountAgeMinutes":14,"minAppOpens":8,"minConnections":20,'
              '"cleanSessionsRequired":2,"stableSessionSeconds":120,"cooldownDismissMinutes":45,'
              '"cooldownNegativeMinutes":90,"cooldownPositiveMinutes":120,"yearlyCap":5}',
        },
      );
      await store.configFuture;
      final config = store.reviewPromptConfig;
      expect(config.enabled, isFalse);
      expect(config.minAccountAgeMinutes, 14);
      expect(config.minAppOpens, 8);
      expect(config.minConnections, 20);
      expect(config.cleanSessionsRequired, 2);
      expect(config.stableSessionSeconds, 120);
      expect(config.cooldownDismissMinutes, 45);
      expect(config.cooldownNegativeMinutes, 90);
      expect(config.cooldownPositiveMinutes, 120);
      expect(config.yearlyCap, 5);
    });

    test('falls back per-field for missing/invalid entries', () async {
      store = createStore();
      when(client.getAllValues()).thenAnswer(
        // minAppOpens present, cooldownDismissMinutes negative, yearlyCap wrong type.
        (_) async => {
          'reviewPromptConfig': '{"minAppOpens":8,"cooldownDismissMinutes":-1,"yearlyCap":"oops"}',
        },
      );
      await store.configFuture;
      final config = store.reviewPromptConfig;
      expect(config.minAppOpens, 8); // honoured
      expect(config.cooldownDismissMinutes, 43200); // negative → default
      expect(config.yearlyCap, 3); // wrong type → default
      expect(config.minConnections, 10); // absent → default
    });

    test('accepts zero (gate/cooldown disabled)', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'reviewPromptConfig': '{"minAccountAgeMinutes":0,"yearlyCap":0}'});
      await store.configFuture;
      expect(store.reviewPromptConfig.minAccountAgeMinutes, 0);
      expect(store.reviewPromptConfig.yearlyCap, 0);
    });

    test('returns defaults when JSON is malformed', () async {
      store = createStore();
      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'reviewPromptConfig': '{not valid json'});
      await store.configFuture;
      expect(store.reviewPromptConfig.minAppOpens, 5);
    });
  });

  group('RemoteConfigStore.canShowSubscriptionOnboardingFlow', () {
    test('returns true if key is not present in config (default)', () async {
      store = createStore();

      when(client.getAllValues()).thenAnswer((_) async => {});
      await store.configFuture;
      expect(store.canShowSubscriptionOnboardingFlow, isTrue);
    });

    test('returns true if config has true value', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'canShowSubscriptionOnboardingFlow': true});
      await store.configFuture;
      expect(store.canShowSubscriptionOnboardingFlow, isTrue);
    });

    test('returns false if config has false value (kill switch flipped)', () async {
      store = createStore();

      when(
        client.getAllValues(),
      ).thenAnswer((_) async => {'canShowSubscriptionOnboardingFlow': false});
      await store.configFuture;
      expect(store.canShowSubscriptionOnboardingFlow, isFalse);
    });
  });
}
