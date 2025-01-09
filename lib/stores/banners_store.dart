import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'banners_store.g.dart';

// ignore: library_private_types_in_public_api
class BannersStore = _BannersStore with _$BannersStore;

abstract class _BannersStore with Store {
  _BannersStore(
    this._apiService,
    this._subscriptionStore,
    this._configStore,
  );

  final ApiService _apiService;
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _configStore;

  @readonly
  late ObservableFuture<List<BannerType>> _shownBanners =
      ObservableFuture(_apiService.getShownBanners());

  @computed
  List<BannerType> get banners {
    final shown = _shownBanners.value;
    final isSubscribed = _subscriptionStore.isSubscribed;

    if (shown == null || isSubscribed == null) {
      return [];
    }

    final all = [...BannerType.values]..removeWhere(shown.contains);

    if (isSubscribed) {
      all.remove(BannerType.subscription);
    }

    if (_configStore.dataCenterCountries.isEmpty) {
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
