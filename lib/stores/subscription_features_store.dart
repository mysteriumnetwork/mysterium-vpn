import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

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
  bool get residentialIPsAllowed =>
      metadata?.residentialIpsAllowed ?? _planMetadata?.residentialIpsAllowed ?? false;

  @computed
  bool get malwareBlockingAllowed =>
      metadata?.malwareBlockingAllowed ?? _planMetadata?.malwareBlockingAllowed ?? false;

  @computed
  PlanMetadata? get _planMetadata => _configStore.subscriptionPlanFuture.value?.metadata;

  @computed
  bool get isLoading {
    if (_subscriptionStore.subscriptionFuture.status == FutureStatus.pending) {
      return true;
    }
    if (_configStore.future.status == FutureStatus.pending) {
      return true;
    }
    if (metadata == null && _configStore.subscriptionPlanFuture.status == FutureStatus.pending) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {}
}
