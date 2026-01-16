import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'promotional_content_store.g.dart';

// ignore: library_private_types_in_public_api
class PromotionalContentStore = _PromotionalContentStore with _$PromotionalContentStore;

abstract class _PromotionalContentStore with Store {
  _PromotionalContentStore(
    this._remoteConfigStore,
  );

  final RemoteConfigStore _remoteConfigStore;

  @computed
  PromotionalBanner? get activeBanner => _remoteConfigStore.promotionalBanner;
}
