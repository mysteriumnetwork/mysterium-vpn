import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'banners_store.g.dart';

// ignore: library_private_types_in_public_api
class BannersStore = _BannersStore with _$BannersStore;

abstract class _BannersStore with Store {
  _BannersStore(
    this._apiService,
    this._subscriptionStore,
    this._locationsStore,
    this._authSessionStore,
  );

  final ApiService _apiService;
  final SubscriptionStore _subscriptionStore;
  final LocationsStore _locationsStore;
  final AuthSessionStore _authSessionStore;

  @readonly
  late ObservableFuture<List<BannerType>> _shownBanners =
      ObservableFuture(_apiService.getShownBanners());

  @computed
  List<BannerType> get banners {
    final shown = _shownBanners.value;
    final isSubscribed = _subscriptionStore.isSubscribed ?? true;
    final status = _authSessionStore.status;

    if (shown == null) {
      return [
        if (status == AuthStatus.unauthenticated) BannerType.unauthenticated,
      ];
    }

    final all = [...BannerType.values]..removeWhere(shown.contains);
    if (status == AuthStatus.authenticated) {
      all.remove(BannerType.unauthenticated);
    }

    if (isSubscribed) {
      all.remove(BannerType.subscription);
    }

    final locations = _locationsStore.dcLocationsFuture.value;
    if (locations?.isEmpty ?? false) {
      all.remove(BannerType.datacenter);
    }

    return all;
  }

  @computed
  BannerType? get banner => banners.firstOrNull;

  @action
  Future<void> setShown(BannerType banner) async {
    final shownBanners = [...(await _shownBanners), banner];
    await _apiService.setShownBanners(shownBanners);

    _shownBanners = ObservableFuture.value(shownBanners);
  }
}
