import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:vpn_api/vpn_api.dart';

part 'subscription_features_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionFeaturesStore = _SubscriptionFeaturesStore with _$SubscriptionFeaturesStore;

abstract class _SubscriptionFeaturesStore with Store, Disposeable {
  _SubscriptionFeaturesStore(this._subscriptionStore, this._configStore);

  final SubscriptionStore _subscriptionStore;
  final SubscriptionConfigStore _configStore;

  @computed
  SubscriptionConfigResponsePlansInnerMetadata? get metadata {
    final subscription = _subscriptionStore.subscriptionFuture.value;
    final planId = subscription?.planId;

    final config = _configStore.future.value;
    final plans = config?.plans ?? [];

    final plan = plans.firstWhereOrNull((plan) => plan.id == planId);
    return plan?.metadata;
  }

  @computed
  bool get residentialIPsAllowed => metadata?.residentialIpsAllowed ?? true;

  @computed
  bool get malwareBlockingAllowed => metadata?.malwareBlockingAllowed ?? false;

  @override
  void dispose() {}
}
