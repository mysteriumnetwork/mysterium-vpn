import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'update_availabe_store.g.dart';

// ignore: library_private_types_in_public_api
class UpdateAvailableStore = _UpdateAvailableStore with _$UpdateAvailableStore;

abstract class _UpdateAvailableStore with Store {
  _UpdateAvailableStore(
    this._remoteConfigStore,
    this._newVersionPlus,
    this._flavorConfig,
  ) {
    newVersionFuture = ObservableFuture(
      _getNewVersionStatus(),
    );
  }

  final RemoteConfigStore _remoteConfigStore;
  final NewVersionPlus _newVersionPlus;
  final FlavorConfig _flavorConfig;

  @observable
  late ObservableFuture<VersionStatus?> newVersionFuture;

  Future<VersionStatus?> _getNewVersionStatus() async {
    if (!_remoteConfigStore.useStoreVersionChecker) {
      return null;
    }
    try {
      return await _newVersionPlus.getVersionStatus();
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );
      return null;
    }
  }

  @computed
  bool get appUpdateAvailable {
    final latestStableAppVersion = _remoteConfigStore.latestStableAppVersion;
    final currentBuildVersion = _flavorConfig.buildInfo.buildVersion;
    final storeVersion = newVersionFuture.value?.storeVersion;
    if (latestStableAppVersion.compareTo(currentBuildVersion) >= 0 ||
        (storeVersion != null && storeVersion.compareTo(currentBuildVersion) >= 0)) {
      return true;
    }
    return false;
  }
}
