import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'update_available_store.g.dart';

// ignore: library_private_types_in_public_api
class UpdateAvailableStore = _UpdateAvailableStore with _$UpdateAvailableStore;

abstract class _UpdateAvailableStore with Store {
  _UpdateAvailableStore(this._remoteConfigStore, this._buildInfo) {
    updateAvailabilityFuture = ObservableFuture(_getNewVersionStatus());
  }

  final RemoteConfigStore _remoteConfigStore;
  final BuildInfo _buildInfo;

  @observable
  late ObservableFuture<UpdateAvailability?> updateAvailabilityFuture;

  @action
  Future<UpdateAvailability?> _getNewVersionStatus() async {
    if (!_remoteConfigStore.useStoreVersionChecker) {
      return null;
    }
    if (Platform.isAndroid) {
      try {
        return (await InAppUpdate.checkForUpdate()).updateAvailability;
      } catch (e, s) {
        Sentry.captureException(e, stackTrace: s);
        return null;
      }
    }
    return null;
  }

  @computed
  bool get appUpdateAvailable {
    final latestStableAppVersion = _remoteConfigStore.latestStableAppVersion;
    final currentBuildVersion = _buildInfo.buildVersion;
    final updateAvailable = updateAvailabilityFuture.value == UpdateAvailability.updateAvailable;
    if (isCurrentVersionBehind(
          currentAppVersion: currentBuildVersion,
          comparisonVersion: latestStableAppVersion,
        ) ||
        updateAvailable) {
      return true;
    }
    return false;
  }
}
