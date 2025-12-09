import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'banners_store.g.dart';

// ignore: library_private_types_in_public_api
class BannersStore = _BannersStore with _$BannersStore;

abstract class _BannersStore with Store {
  _BannersStore(
    this._localDBService,
    this._subscriptionStore,
    this._authSessionStore,
    this._connectionsLimitStore,
    this._updateAvailableStore,
  );

  final LocalDBService _localDBService;
  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;
  final ConnectionsLimitStore _connectionsLimitStore;
  final UpdateAvailableStore _updateAvailableStore;

  /// User can dismiss the banner when unauthenticated
  /// Banners will be hidden until the app is restarted or the user logs in.
  final ObservableList<BannerType> _unauthenticatedHidden = ObservableList<BannerType>();

  /// Banners that are temporarily hidden and should not be shown
  /// until the app is restarted or the user logs out.
  final ObservableList<BannerType> _temporaryHidden = ObservableList<BannerType>();

  final Set<BannerType> _bannerRequireConditions = {
    BannerType.unauthenticated,
    BannerType.subscription,
    BannerType.appUpdateAvailable,
    BannerType.tooManyConnections,
  };

  @readonly
  late ObservableFuture<List<BannerType>> _shownBanners =
      ObservableFuture(_localDBService.getShownBanners());

  @computed
  List<BannerType>? get shown => _authSessionStore.isAuthenticated
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
      if (_connectionsLimitStore.connectionLimitReached) BannerType.tooManyConnections,

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
    return _updateAvailableStore.appUpdateAvailable;
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
