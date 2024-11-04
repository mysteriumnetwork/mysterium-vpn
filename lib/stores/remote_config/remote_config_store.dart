import 'package:configcat_client/configcat_client.dart';
import 'package:mobx/mobx.dart';
import 'package:talker/talker.dart';

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
}

class RemoteConfigStore = RemoteConfigStoreBase with _$RemoteConfigStore;

abstract class RemoteConfigStoreBase with Store {
  RemoteConfigStoreBase({
    required this.client,
    required this.logger,
  }) {
    getAllRemoteConfigValues().whenComplete(refreshRemoteConfigValues);
  }
  final ConfigCatClient client;
  final Talker logger;

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
    getAllRemoteConfigValues();
  }

  @action
  Future<void> getAllRemoteConfigValues() async {
    try {
      config = ObservableMap.of(await client.getAllValues());
    } catch (e, st) {
      logger.handle(e, st);
      config = ObservableMap();
    }
  }

  @action
  Future<void> refreshRemoteConfigValues() async {
    client.hooks.addOnConfigChanged((flags) async {
      config = ObservableMap.of(await client.getAllValues());
    });
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
}
