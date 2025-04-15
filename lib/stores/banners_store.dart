import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'banners_store.g.dart';

// ignore: library_private_types_in_public_api
class BannersStore = _BannersStore with _$BannersStore;

abstract class _BannersStore with Store {
  _BannersStore(
    this._localDBService,
    this._subscriptionStore,
    this._locationsStore,
    this._authSessionStore,
  );

  final LocalDBService _localDBService;
  final SubscriptionStore _subscriptionStore;
  final LocationsStore _locationsStore;
  final AuthSessionStore _authSessionStore;

  @readonly
  late ObservableFuture<List<BannerType>> _shownBanners =
      ObservableFuture(_localDBService.getShownBanners());

  @computed
  List<BannerType> get mainBanners {
    final shown = _shownBanners.value ?? [];
    final isSubscribed = _subscriptionStore.isSubscribed ?? true;
    final status = _authSessionStore.status;

    final banners = <BannerType>{
      if (status == AuthStatus.unauthenticated) BannerType.unauthenticated,
      if (!isSubscribed) BannerType.subscription,
      if (_locationsStore.dcLocationsStream.value?.isEmpty == false) BannerType.datacenter,
      // Add remaining main banners which require no conditions
      ...BannerType.mainBanners.toSet().difference({
        BannerType.unauthenticated,
        BannerType.subscription,
        BannerType.datacenter,
      }),
    };

    return banners.toList()
      ..removeWhere((banner) => banner.isDismissable && shown.contains(banner));
  }

  @computed
  BannerType? get mainBanner => mainBanners.firstOrNull;

  @computed
  List<BannerType> get secondaryBanners {
    final shown = _shownBanners.value ?? [];

    return BannerType.secondaryBanners
      ..removeWhere((banner) => banner.isDismissable && shown.contains(banner));
  }

  bool canShow(BannerType banner) {
    if (banner.isDismissable) {
      return !(_shownBanners.value ?? []).contains(banner);
    }
    return true;
  }

  @action
  Future<void> setShown(BannerType banner) async {
    if (!banner.isDismissable) {
      return;
    }
    final shownBanners = [...(await _shownBanners), banner];
    await _localDBService.setShownBanners(shownBanners);

    _shownBanners = ObservableFuture.value(shownBanners);
  }

  @action
  Future<void> resetShown() async {
    await _localDBService.resetShownBanners();
    _shownBanners = ObservableFuture.value([]);
  }
}
