import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'ab_testing_store.g.dart';

// enum _ABKey { subscriptionFlow, tunnelConsent }

class ABTestingStore = ABTestingStoreBase with _$ABTestingStore;

abstract class ABTestingStoreBase extends ConfigCatStore with Store {
  ABTestingStoreBase(super.client, super.logger, this._analytics) {
    reaction((_) => configFuture, (future) async {
      await future;
      asUserProperties.forEach((key, value) async {
        await _analytics.setUserProperty(AnalyticsUserProperty.fromString(name: key, value: value));
      });
    }, fireImmediately: true);
  }

  final AnalyticsStore _analytics;

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry('group_${key.toSnakeCase}', value.toString()));
}
