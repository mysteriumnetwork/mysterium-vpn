import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/utils/config_cat_client_wrapper.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'ab_testing_store.g.dart';

/// [name]'s are added to user properties to the analytics service.
/// Properties are sent as strings and converted to snake_case.
/// The [name] of the event. Should contain 1 to 24 alphanumeric characters or underscores
enum _ABKey {
  subscriptionFlow,
  tunnelConsent,
  bannerDisplay,
}

class ABTestingStore = ABTestingStoreBase with _$ABTestingStore;

abstract class ABTestingStoreBase with Store {
  ABTestingStoreBase(this._client, this._analytics);

  final ConfigCatClientWrapper _client;
  final AnalyticsStore _analytics;

  @observable
  ObservableFuture<Map<String, dynamic>>? configFuture;

  @computed
  Map<String, dynamic> get config => configFuture?.value ?? {};

  @action
  Future<void> init() async {
    configFuture ??= ObservableFuture(_client.fetch());
    await configFuture;

    asUserProperties.forEach(_analytics.setUserProperty);

    _client.watch(() async {
      configFuture = ObservableFuture(_client.fetch());
      await configFuture;

      asUserProperties.forEach(_analytics.setUserProperty);
    });
  }

  @computed
  String get subscriptionFlowVariant {
    if (config.containsKey(_ABKey.subscriptionFlow.name)) {
      return config[_ABKey.subscriptionFlow.name] as String;
    }
    return 'C';
  }

  @computed
  String get tunnelConsentType {
    if (config.containsKey(_ABKey.tunnelConsent.name)) {
      return config[_ABKey.tunnelConsent.name] as String;
    }
    return 'A';
  }

  @computed
  String get bannerDisplayVariant {
    if (config.containsKey(_ABKey.bannerDisplay.name)) {
      return config[_ABKey.bannerDisplay.name] as String;
    }
    return 'A';
  }

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry('group_${key.toSnakeCase}', value.toString()));
}
