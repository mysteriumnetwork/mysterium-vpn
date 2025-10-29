import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_store.dart';

part 'ab_testing_store.g.dart';

/// [name]'s are added to user properties to the analytics service.
/// Properties are sent as strings and converted to snake_case.
/// The [name] of the event. Should contain 1 to 24 alphanumeric characters or underscores
enum _ABKey {
  subscriptionFlow,
  tunnelConsent,
}

class ABTestingStore = ABTestingStoreBase with _$ABTestingStore;

abstract class ABTestingStoreBase extends ConfigCatStore with Store {
  ABTestingStoreBase(super.client, super.logger, super.ipInfoStore, this._analytics) {
    reaction(
      (_) => configFuture,
      (future) async {
        await future;
        asUserProperties.forEach((key, value) async {
          await _analytics.setUserProperty(
            AnalyticsUserProperty.fromString(
              name: key,
              value: value,
            ),
          );
        });
      },
      fireImmediately: true,
    );
  }

  final AnalyticsStore _analytics;

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

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry('group_${key.toSnakeCase}', value.toString()));
}
