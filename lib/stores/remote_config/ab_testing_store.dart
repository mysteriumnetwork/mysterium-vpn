import 'package:configcat_client/configcat_client.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:talker/talker.dart';

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
  ABTestingStoreBase({
    required this.client,
    required this.logger,
    required this.analytics,
  });
  final ConfigCatClient client;
  final Talker logger;
  final AnalyticsStore analytics;

  @observable
  ObservableMap<String, dynamic> config = ObservableMap();

  @action
  Future<void> setDefaultUser({
    required String email,
    required String userId,
  }) async {
    client.setDefaultUser(
      ConfigCatUser(
        identifier: userId,
        email: email,
      ),
    );
    await getAllABTestingValues().whenComplete(refreshABTestingValues);
  }

  @action
  Future<void> getAllABTestingValues() async {
    try {
      config = ObservableMap.of(await client.getAllValues());
      asUserProperties.forEach(analytics.setUserProperty);
    } catch (e, st) {
      logger.handle(e, st);
    }
  }

  @action
  Future<void> refreshABTestingValues() async {
    client.hooks.addOnConfigChanged((flags) async {
      getAllABTestingValues();
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
