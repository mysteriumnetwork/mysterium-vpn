import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/utils/config_cat_client_wrapper.dart';

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
  showVpnPrivacyPolicyPage,
  pricingMonthly,
  mqttExperiment,
  dataCenterCountries,
}

class RemoteConfigStore = RemoteConfigStoreBase with _$RemoteConfigStore;

abstract class RemoteConfigStoreBase with Store {
  RemoteConfigStoreBase(this._client) {
    _init();
  }

  final ConfigCatClientWrapper _client;

  @observable
  late ObservableFuture<Map<String, dynamic>> configFuture = ObservableFuture(_client.fetch());

  @computed
  Map<String, dynamic> get config => configFuture.value ?? {};

  @action
  Future<void> _init() async {
    await configFuture;
    _client.watch(() => configFuture = ObservableFuture(_client.fetch()));
  }

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
  bool get showVpnPrivacyPolicyPage {
    if (config.containsKey(_FeatureToggleKey.showVpnPrivacyPolicyPage.name)) {
      return config[_FeatureToggleKey.showVpnPrivacyPolicyPage.name] as bool;
    }
    return false;
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
  List<String> get dataCenterCountries {
    if (config.containsKey(_FeatureToggleKey.dataCenterCountries.name)) {
      final raw = config[_FeatureToggleKey.dataCenterCountries.name];
      if (raw is String) {
        return raw
            .trim()
            .split(RegExp('[^a-zA-Z]+'))
            .map((code) => code.trim().toUpperCase())
            .where((it) => it.length == 2)
            .toList();
      }
    }
    return [];
  }

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry(key.toSnakeCase, value.toString()));
}
