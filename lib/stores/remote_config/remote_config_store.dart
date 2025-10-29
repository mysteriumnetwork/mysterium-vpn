import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/models/map_config.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_store.dart';

part 'remote_config_store.g.dart';

enum _FeatureToggleKey {
  isServiceAvailable,
  isServiceAvailableMessage,
  hideDeleteAccount,
  hideKillSwitch,
  minAndroidBuildNumber,
  minIosBuildNumber,
  minWindowsBuildNumber,
  minWindowsStandAloneBuildNumber,
  minMacosBuildNumber,
  hideReedemCode,
  hideMalwareBlocker,
  hideNotSafeContentBlocker,
  malwareBlockerDnsAddress,
  notSafeContentBlockerDnsAddress,
  pricingMonthly,
  mqttExperiment,
  locationsRefreshInterval,
  showSalesView,
  sentryDsn,
  hideResetAppSetting,
  browseUnauthenticated,
  shouldCheckUdp,
  latestStableAppVersion,
  isRateConnectionAvailable,
  cancelSurveyOptions,
  useStoreVersionChecker,
  enableQaHelpers,
  showCitiesAndStates,
  countriesWithCitiesOnMap,
  showUserIntents,
  userIntentBlacklist,
  userIntentsRefreshInterval,
  recentLocationsLimit,
  mapConfig,
  subscriptionUpgradeBannerEnabled,
  subscriptionUpgradeAutoDisplayEnabled,
}

class RemoteConfigStore = RemoteConfigStoreBase with _$RemoteConfigStore;

abstract class RemoteConfigStoreBase extends ConfigCatStore with Store {
  RemoteConfigStoreBase(
    super.client,
    super.logger,
    super.ipInfoStore, {
    bool isDev = false,
  }) : _isDev = isDev;

  final bool _isDev;

  @computed
  bool get isServiceAvailable {
    if (config.containsKey(_FeatureToggleKey.isServiceAvailable.name)) {
      return config[_FeatureToggleKey.isServiceAvailable.name] as bool;
    }
    return true;
  }

  @computed
  String get isServiceAvailableMessage {
    if (config.containsKey(_FeatureToggleKey.isServiceAvailableMessage.name)) {
      return config[_FeatureToggleKey.isServiceAvailableMessage.name] as String;
    }
    return 'Service is not available. Please try again later.';
  }

  @computed
  bool get hideDeleteAccount {
    if (config.containsKey(_FeatureToggleKey.hideDeleteAccount.name)) {
      return config[_FeatureToggleKey.hideDeleteAccount.name] as bool;
    }
    return false;
  }

  @computed
  bool get hideKillSwitch {
    if (config.containsKey(_FeatureToggleKey.hideKillSwitch.name)) {
      return config[_FeatureToggleKey.hideKillSwitch.name] as bool;
    }
    return false;
  }

  @computed
  String get minMacosBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minMacosBuildNumber.name)) {
      return config[_FeatureToggleKey.minMacosBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minWindowsStandAloneBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minWindowsStandAloneBuildNumber.name)) {
      return config[_FeatureToggleKey.minWindowsStandAloneBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minWindowsBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minWindowsBuildNumber.name)) {
      return config[_FeatureToggleKey.minWindowsBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minAndroidBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minAndroidBuildNumber.name)) {
      return config[_FeatureToggleKey.minAndroidBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minIosBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minIosBuildNumber.name)) {
      return config[_FeatureToggleKey.minIosBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  bool get hideReedemCode {
    if (config.containsKey(_FeatureToggleKey.hideReedemCode.name)) {
      return config[_FeatureToggleKey.hideReedemCode.name] as bool;
    }
    return false;
  }

  @computed
  bool get hideMalwareBlocker {
    if (config.containsKey(_FeatureToggleKey.hideMalwareBlocker.name)) {
      return config[_FeatureToggleKey.hideMalwareBlocker.name] as bool;
    }
    return false;
  }

  @computed
  bool get hideNotSafeContentBlocker {
    if (config.containsKey(_FeatureToggleKey.hideNotSafeContentBlocker.name)) {
      return config[_FeatureToggleKey.hideNotSafeContentBlocker.name] as bool;
    }
    return false;
  }

  @computed
  String get malwareBlockerDnsAddress {
    if (config.containsKey(_FeatureToggleKey.malwareBlockerDnsAddress.name)) {
      return config[_FeatureToggleKey.malwareBlockerDnsAddress.name] as String;
    }
    return malwareBlockerDomainAddress;
  }

  @computed
  String get notSafeContentBlockerDnsAddress {
    if (config.containsKey(_FeatureToggleKey.notSafeContentBlockerDnsAddress.name)) {
      return config[_FeatureToggleKey.notSafeContentBlockerDnsAddress.name] as String;
    }
    return notSafeContentBlockerDomainAddress;
  }

  @computed
  bool get pricingMonthly {
    if (config.containsKey(_FeatureToggleKey.pricingMonthly.name)) {
      return config[_FeatureToggleKey.pricingMonthly.name] as bool;
    }
    return false;
  }

  @computed
  bool get mqttExperiment {
    if (config.containsKey(_FeatureToggleKey.mqttExperiment.name)) {
      return config[_FeatureToggleKey.mqttExperiment.name] as bool;
    }
    return false;
  }

  @computed
  Duration get locationsRefreshInterval {
    if (config.containsKey(_FeatureToggleKey.locationsRefreshInterval.name)) {
      final raw = config[_FeatureToggleKey.locationsRefreshInterval.name];
      if (raw is int) {
        return Duration(seconds: raw);
      }
    }
    return const Duration(minutes: 10);
  }

  @computed
  bool get showSalesView {
    if (config.containsKey(_FeatureToggleKey.showSalesView.name)) {
      return config[_FeatureToggleKey.showSalesView.name] as bool;
    }
    return false;
  }

  @computed
  String? get sentryDsn {
    if (config.containsKey(_FeatureToggleKey.sentryDsn.name)) {
      return config[_FeatureToggleKey.sentryDsn.name] as String;
    }
    return null;
  }

  @computed
  bool get hideResetAppSetting {
    if (config.containsKey(_FeatureToggleKey.hideResetAppSetting.name)) {
      return config[_FeatureToggleKey.hideResetAppSetting.name] as bool;
    }
    return false;
  }

  @computed
  bool get browseUnauthenticated {
    if (config.containsKey(_FeatureToggleKey.browseUnauthenticated.name)) {
      return config[_FeatureToggleKey.browseUnauthenticated.name] as bool;
    }
    return false;
  }

  @computed
  bool get shouldCheckUdp {
    if (config.containsKey(_FeatureToggleKey.shouldCheckUdp.name)) {
      return config[_FeatureToggleKey.shouldCheckUdp.name] as bool;
    }
    return true;
  }

  @computed
  String get latestStableAppVersion {
    if (config.containsKey(_FeatureToggleKey.latestStableAppVersion.name)) {
      return config[_FeatureToggleKey.latestStableAppVersion.name] as String;
    }
    return '2.0.2';
  }

  @computed
  bool get isRateConnectionAvailable {
    if (config.containsKey(_FeatureToggleKey.isRateConnectionAvailable.name)) {
      return config[_FeatureToggleKey.isRateConnectionAvailable.name] as bool;
    }
    return false;
  }

  @computed
  Set<String>? get cancelSubscriptionReasonKeys {
    if (config.containsKey(_FeatureToggleKey.cancelSurveyOptions.name)) {
      final raw = config[_FeatureToggleKey.cancelSurveyOptions.name].toString();
      final json = jsonDecode(raw);
      if (json is Iterable) {
        return json.map((it) => it.toString()).toSet();
      }
    }
    return null;
  }

  @computed
  bool get useStoreVersionChecker {
    if (config.containsKey(_FeatureToggleKey.useStoreVersionChecker.name)) {
      return config[_FeatureToggleKey.useStoreVersionChecker.name] as bool;
    }
    return true;
  }

  @computed
  bool get enableQaHelpers {
    if (config.containsKey(_FeatureToggleKey.enableQaHelpers.name)) {
      return config[_FeatureToggleKey.enableQaHelpers.name] as bool;
    }
    return _isDev; // Enable QA helpers in development mode
  }

  @computed
  bool get showCitiesAndStates {
    if (config.containsKey(_FeatureToggleKey.showCitiesAndStates.name)) {
      return config[_FeatureToggleKey.showCitiesAndStates.name] as bool;
    }
    return false;
  }

  @computed
  Set<String> get countriesWithCitiesOnMap {
    try {
      if (config.containsKey(_FeatureToggleKey.countriesWithCitiesOnMap.name)) {
        final raw = config[_FeatureToggleKey.countriesWithCitiesOnMap.name];
        final decoded = jsonDecode(raw.toString()) as List;
        return decoded.map((it) => it.toString()).toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return const <String>{};
  }

  @computed
  bool get showUserIntents {
    if (config.containsKey(_FeatureToggleKey.showUserIntents.name)) {
      return config[_FeatureToggleKey.showUserIntents.name] as bool;
    }
    return false;
  }

  @computed
  Set<UserIntent> get userIntentBlacklist {
    try {
      if (config.containsKey(_FeatureToggleKey.userIntentBlacklist.name)) {
        final raw = config[_FeatureToggleKey.userIntentBlacklist.name];
        final decoded = jsonDecode(raw.toString()) as List;
        final keys = decoded.map((it) => it.toString()).toSet();

        return keys
            .map(
              (key) => UserIntent.values.firstWhereOrNull(
                (it) => it.key == key || it.name == key,
              ),
            )
            .nonNulls
            .toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return {};
  }

  @computed
  Duration get userIntentsRefreshInterval {
    if (config.containsKey(_FeatureToggleKey.userIntentsRefreshInterval.name)) {
      final raw = config[_FeatureToggleKey.userIntentsRefreshInterval.name];
      if (raw is int) {
        return Duration(seconds: raw);
      }
    }
    return const Duration(minutes: 10);
  }

  @computed
  int get recentLocationsLimit {
    if (config.containsKey(_FeatureToggleKey.recentLocationsLimit.name)) {
      final raw = config[_FeatureToggleKey.recentLocationsLimit.name];
      if (raw is int && raw >= 0) {
        return raw;
      }
    }
    return 5;
  }

  @computed
  MapConfig get mapConfig {
    if (config.containsKey(_FeatureToggleKey.mapConfig.name)) {
      final raw = config[_FeatureToggleKey.mapConfig.name];
      try {
        final decoded = jsonDecode(raw.toString()) as Map<String, dynamic>;
        return MapConfig.fromJson(decoded);
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }

    return const MapConfig();
  }

  @computed
  bool get subscriptionUpgradeBannerEnabled {
    if (config.containsKey(_FeatureToggleKey.subscriptionUpgradeBannerEnabled.name)) {
      return config[_FeatureToggleKey.subscriptionUpgradeBannerEnabled.name] as bool;
    }
    return true;
  }

  @computed
  bool get subscriptionUpgradeAutoDisplayEnabled {
    if (config.containsKey(_FeatureToggleKey.subscriptionUpgradeAutoDisplayEnabled.name)) {
      return config[_FeatureToggleKey.subscriptionUpgradeAutoDisplayEnabled.name] as bool;
    }
    return true;
  }

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry(key.toSnakeCase, value.toString()));
}
