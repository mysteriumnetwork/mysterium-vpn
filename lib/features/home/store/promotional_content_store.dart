import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/models/models.dart';

part 'promotional_content_store.g.dart';

// ignore: library_private_types_in_public_api
class PromotionalContentStore = _PromotionalContentStore with _$PromotionalContentStore;

abstract class _PromotionalContentStore with Store {
  _PromotionalContentStore(this._remoteConfigStore, {DateTime Function()? getCurrentTime})
    : _getCurrentTime = getCurrentTime ?? DateTime.now;

  final RemoteConfigStore _remoteConfigStore;
  final DateTime Function() _getCurrentTime;

  @computed
  PromotionalBanner? get activeBanner {
    final banner = _remoteConfigStore.promotionalBanner;
    if (banner == null) {
      return null;
    }

    final now = _getCurrentTime();

    // Check if banner has started
    if (banner.startDate != null && now.isBefore(banner.startDate!)) {
      return null;
    }

    // Check if banner has ended (expired at or after endDate)
    if (banner.endDate != null && !now.isBefore(banner.endDate!)) {
      return null;
    }

    return banner;
  }
}
