import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'banners_store.g.dart';

// ignore: library_private_types_in_public_api
class BannersStore = _BannersStore with _$BannersStore;

abstract class _BannersStore with Store {
  _BannersStore(
    this._localDBService,
    this._subscriptionStore,
    this._locationsStore,
    this._authSessionStore,
    this._vpnStore,
    this._remoteConfigStore,
    this._flavorConfig,
  );

  final LocalDBService _localDBService;
  final SubscriptionStore _subscriptionStore;
  final LocationsStore _locationsStore;
  final AuthSessionStore _authSessionStore;
  final VpnStore _vpnStore;
  final RemoteConfigStore _remoteConfigStore;
  final FlavorConfig _flavorConfig;

  /// User can dismiss the banner when unauthenticated
  /// Banners will be hidden until the app is restarted or the user logs in.
  final ObservableList<BannerType> _unauthenticatedHidden = ObservableList<BannerType>();

  /// Banners that are temporarily hidden and should not be shown
  /// until the app is restarted or the user logs out.
  final ObservableList<BannerType> _temporaryHidden = ObservableList<BannerType>();

  @readonly
  late ObservableFuture<VersionStatus?> _newVersionFuture = ObservableFuture(
    _getNewVersionStatus(),
  );

  Future<VersionStatus?> _getNewVersionStatus() async {
    if (!_remoteConfigStore.useStoreVersionChecker) {
      return null;
    }
    try {
      final newVersion = NewVersionPlus();
      return await newVersion.getVersionStatus();
    } catch (e, s) {
      Sentry.captureException(
        e,
        stackTrace: s,
      );
      return null;
    }
  }

  final Set<BannerType> _bannerRequireConditions = {
    BannerType.unauthenticated,
    BannerType.subscription,
    BannerType.datacenter,
    BannerType.appUpdateAvailable,
    BannerType.tooManyConnections,
  };

  @readonly
  late ObservableFuture<List<BannerType>> _shownBanners =
      ObservableFuture(_localDBService.getShownBanners());

  @computed
  List<BannerType>? get shown => _authSessionStore.status == AuthStatus.authenticated
      ? _shownBanners.value
      : _unauthenticatedHidden;

  @computed
  bool get shouldShowSubscriptionBanner {
    final status = _subscriptionStore.subscriptionFuture.status;
    if (status == FutureStatus.pending || status == FutureStatus.rejected) {
      return true;
    }
    return _subscriptionStore.isSubscribed == false;
  }

  @computed
  List<BannerType> get mainBanners {
    final authStatus = _authSessionStore.status;

    final banners = <BannerType>{
      if (authStatus == AuthStatus.unauthenticated) BannerType.unauthenticated,
      if (shouldShowSubscriptionBanner) BannerType.subscription,
      if (shouldShowAppUpdateBanner) BannerType.appUpdateAvailable,
      if (_locationsStore.dcLocationsStream.value?.isEmpty == false && shown != null)
        BannerType.datacenter,
      if (_vpnStore.connectionLimitReached) BannerType.tooManyConnections,

      // Add remaining main banners which require no conditions
      ...BannerType.mainBanners.toSet().difference(_bannerRequireConditions),
    };
    if (shown == null) {
      return banners.toList();
    }

    return banners.toList()
      ..removeWhere((banner) => banner.isDismissable && shown!.contains(banner));
  }

  @computed
  BannerType? get mainBanner => mainBanners.firstOrNull;

  @computed
  List<BannerType> get secondaryBanners {
    if (shown == null) {
      return [];
    }

    return BannerType.secondaryBanners
      ..removeWhere((banner) => banner.isDismissable && shown!.contains(banner));
  }

  bool canShow(BannerType banner) {
    if (banner.isDismissable) {
      if (shown == null) {
        return false;
      }
      return !shown!.contains(banner);
    }
    return true;
  }

  @computed
  bool get shouldShowAppUpdateBanner {
    if (_temporaryHidden.contains(BannerType.appUpdateAvailable)) {
      return false;
    }
    final latestStableAppVersion = _remoteConfigStore.latestStableAppVersion;
    final currentBuildVersion = _flavorConfig.buildInfo.buildVersion;
    final storeVersion = _newVersionFuture.value?.storeVersion;
    if (currentBuildVersion.compareTo(latestStableAppVersion) >= 0 ||
        (storeVersion != null && currentBuildVersion.compareTo(storeVersion) >= 0)) {
      return false;
    }
    return true;
  }

  @action
  Future<void> setShown(BannerType banner) async {
    if (!banner.isDismissable) {
      return;
    }
    if (_authSessionStore.status == AuthStatus.unauthenticated) {
      _unauthenticatedHidden.add(banner);
      return;
    }
    if (!banner.shouldPersist) {
      _temporaryHidden.add(banner);
      return;
    }
    final shownBanners = [...(await _shownBanners), banner];
    await _localDBService.setShownBanners(shownBanners);

    _shownBanners = ObservableFuture.value(shownBanners);
  }

  @action
  Future<void> resetShown() async {
    if (_authSessionStore.status == AuthStatus.unauthenticated) {
      _unauthenticatedHidden.clear();
      return;
    }
    await _localDBService.resetShownBanners();
    _shownBanners = ObservableFuture.value([]);
  }
}
