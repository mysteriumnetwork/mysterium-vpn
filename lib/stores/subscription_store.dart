import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';
import 'package:mysterium_vpn/common/utils/subscription_plan_resolver.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:vpn_api/vpn_api.dart' as api;

// Include generated file
part 'subscription_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionStore = _SubscriptionStore with _$SubscriptionStore;

abstract class _SubscriptionStore with Store {
  _SubscriptionStore({
    required api.VpnApi api,
    required this._subscriptionService,
    required this._authSessionStore,
    required this._analyticsStore,
    required this._remoteConfigStore,
    required this._configStore,
  }) : _apiSubscription = api.getSubscription() {
    _reactions = [
      reaction<bool>((_) => _authSessionStore.isAuthenticated, (status) {
        _hasShownExistingSubscriptionDialog = false;
        _existingSubscriptionCheck = null;
        if (status) {
          _subscriptionFuture = ObservableFuture(_fetchSubscription());
        }
      }, fireImmediately: true),
    ];
  }

  final api.Subscription _apiSubscription;
  final SubscriptionService _subscriptionService;
  final AuthSessionStore _authSessionStore;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final SubscriptionConfigStore _configStore;
  late final List<ReactionDisposer> _reactions;

  /// Once-per-session gate for the existing-subscription dialog.
  bool _hasShownExistingSubscriptionDialog = false;

  bool get hasShownExistingSubscriptionDialog => _hasShownExistingSubscriptionDialog;

  void markExistingSubscriptionDialogShown() {
    _hasShownExistingSubscriptionDialog = true;
  }

  // Single-flight; reset on auth flip below.
  Future<String?>? _existingSubscriptionCheck;

  Future<String?> checkForExistingSubscriber() =>
      _existingSubscriptionCheck ??= refreshOtherSubscriber();

  @visibleForTesting
  bool testIsIOS = false;

  @visibleForTesting
  bool testIsWindows = false;

  @visibleForTesting
  bool testIsAndroid = false;

  @visibleForTesting
  bool testIsMacOS = false;

  /// When any `testIsX` is set, getters use only those (host `Platform` ignored).
  bool get _useTestPlatform => testIsIOS || testIsWindows || testIsAndroid || testIsMacOS;

  bool get _isIOS => _useTestPlatform ? testIsIOS : Platform.isIOS;

  bool get _isWindows => _useTestPlatform ? testIsWindows : Platform.isWindows;

  bool get _isAndroid => _useTestPlatform ? testIsAndroid : Platform.isAndroid;

  bool get _isMacOS => _useTestPlatform ? testIsMacOS : Platform.isMacOS;

  @readonly
  late ObservableFuture<Subscription> _subscriptionFuture = ObservableFuture.value(
    Subscription.empty(),
  );

  ObservableFuture<api.SubscriptionConfigResponse?> get subscriptionConfigFuture =>
      _configStore.future;

  @readonly
  late ObservableFuture<String?> _otherSubscriberEmailFuture = ObservableFuture(
    _fetchOtherSubscriber(),
  );

  @computed
  bool? get isSubscribed => _subscriptionFuture.value?.active;

  @computed
  bool get isSubscriptionLoading =>
      _subscriptionFuture.status == FutureStatus.pending ||
      subscriptionConfigFuture.status == FutureStatus.pending;

  @computed
  StoreState get storeState => switch (subscriptionConfigFuture.status) {
    FutureStatus.pending => StoreState.loading,
    FutureStatus.rejected => StoreState.notAvailable,
    FutureStatus.fulfilled =>
      subscriptionConfigFuture.value != null ? StoreState.available : StoreState.notAvailable,
  };

  /// Plan metadata for the current subscription's `planId`, resolved from the
  /// static subscription config. Returns null if the subscription is inactive,
  /// has no planId, or the config doesn't contain that plan.
  @computed
  api.SubscriptionConfigResponsePlansInnerMetadata? get planMetadata {
    final subscription = _subscriptionFuture.value;
    if (subscription == null || !subscription.active) {
      return null;
    }
    final planId = subscription.planId;
    if (planId == null) {
      return null;
    }
    final plans = subscriptionConfigFuture.value?.plans ?? const [];
    return plans.firstWhereOrNull((plan) => plan.id == planId)?.metadata;
  }

  @computed
  bool get residentialIPsAllowed => planMetadata?.residentialIpsAllowed ?? false;

  /// True when the Products tab should route the user to the web instead of
  /// the in-app upgrade picker: Windows (no active store sub), or an active
  /// subscription paid through any non-mobile gateway (Stripe/Adyen/PayPal/
  /// CoinGate).
  ///
  /// Active mobile-store (Apple/Google) subs are never routed to the web —
  /// they can only be managed in their originating store, even on Windows —
  /// so they fall through to [isStoreSubOnForeignPlatform] instead.
  @computed
  bool get useWebFlow {
    final subscription = _subscriptionFuture.value;
    final isActive = subscription?.active ?? false;
    final gateway = subscription?.gateway?.toLowerCase();
    if (isActive && isMobilePaymentGateway(gateway)) {
      return false;
    }
    if (_isWindows) {
      return true;
    }
    // Otherwise, web flow only for an active sub paid through a web gateway.
    return isActive && gateway != null && !isMobilePaymentGateway(gateway);
  }

  /// True when the active subscription was paid through a mobile store
  /// (Apple/Google) but the current platform can't manage that store (e.g. an
  /// Apple sub opened on Windows/Android, or a Google sub on iOS/macOS/
  /// Windows). Such subs can never move to web billing, so the Products tab
  /// must direct the user back to the originating store.
  @computed
  bool get isStoreSubOnForeignPlatform {
    final subscription = _subscriptionFuture.value;
    if (subscription == null || !subscription.active) {
      return false;
    }
    final gateway = subscription.gateway?.toLowerCase();
    if (!isMobilePaymentGateway(gateway)) {
      return false;
    }
    return !isGatewayOnPlatform(gateway, isIOS: _isIOS, isAndroid: _isAndroid, isMacOS: _isMacOS);
  }

  /// `true` when the active subscription is already on the highest tier +
  /// longest duration plan available for its gateway. No further upgrade
  /// is possible in that case.
  @computed
  bool get isOnMaxPlan {
    final subscription = _subscriptionFuture.value;
    if (subscription == null || !subscription.active) {
      return false;
    }
    final gateway = subscription.gateway?.toLowerCase();
    if (gateway == null) {
      return false;
    }
    final config = subscriptionConfigFuture.value;
    if (config == null) {
      return false;
    }
    final maxPlanId = maxPlanIdForGateway(gateway, config, _remoteConfigStore.planFeatures);
    return maxPlanId != null && subscription.planId == maxPlanId;
  }

  /// The screen the Products tab will render. `@computed` so store-driven
  /// analytics reactions recompute when the underlying subscription/config
  /// state settles. Read by both `HomeProductsTab` and `HomeTabsStore`.
  @computed
  ProductsScreenVariant get productsScreenVariant => resolveProductsScreenVariant(
    subscriptionStatus: _subscriptionFuture.status,
    hasActiveSub: _subscriptionFuture.value?.active ?? false,
    configStatus: subscriptionConfigFuture.status,
    isOnMaxPlan: isOnMaxPlan,
    isStoreSubOnForeignPlatform: isStoreSubOnForeignPlatform,
    useWebFlow: useWebFlow,
  );

  @computed
  bool get malwareBlockingAllowed => planMetadata?.malwareBlockingAllowed ?? false;

  @computed
  bool get canRedeemCode {
    if (_remoteConfigStore.hideReedemCode) {
      return false;
    }
    if (_isIOS) {
      final iosInfo = Env.deviceInfo;
      if (iosInfo is! IosDeviceInfo) {
        return false;
      }
      final majorVersion = int.tryParse(iosInfo.systemVersion.split('.').first) ?? 0;
      if (majorVersion < 14) {
        return false;
      }
      final subscription = _subscriptionFuture.value;
      if (subscription != null && subscription.active) {
        return subscription.gateway == 'apple';
      }
      return true;
    }
    return false;
  }

  @action
  Future<Subscription> _fetchSubscription() async {
    if (!_authSessionStore.isAuthenticated) {
      return Subscription.empty();
    }
    final subscription = await _subscriptionService.fetchSubscriptionDetails();
    _setSubscriptionAnalyticsProps(subscription).ignore();
    return subscription;
  }

  Future<void> _setSubscriptionAnalyticsProps(Subscription subscription) async {
    final userStatus = subscription.active
        ? 'paid'
        : (subscription.expired ?? false)
        ? 'expired_paid'
        : 'not_paid';
    _analyticsStore
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.planId,
          value: subscription.planId ?? '',
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.validTo,
          value: subscription.activeUntil.toString(),
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(name: AnalyticsUserPropName.userStatus, value: userStatus),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.gateway,
          value: subscription.gateway?.toLowerCase() ?? '',
        ),
      );
  }

  Future<Subscription> updateSubscription(Future<Subscription> Function() update) async {
    _subscriptionFuture = _subscriptionFuture.replace(update());
    return await _subscriptionFuture;
  }

  Future<String?> _fetchOtherSubscriber() async {
    final subscription = await _subscriptionFuture;
    if (subscription.active) {
      return null;
    }

    try {
      final user = await _authSessionStore.userFuture;
      final (email, activeUntil) = await _secureStorageService.getSubscriptionPaymentInfo();
      if (email != user!.username && activeUntil.isAfter(DateTime.now())) {
        return email;
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('Failed to fetch other subscriber', error: e, stackTrace: stack);
      }
    }

    return null;
  }

  @action
  Future<Subscription> refreshSubscription({bool force = false}) async {
    if (force ||
        _subscriptionFuture.value?.active == false ||
        (_subscriptionFuture.value?.isExpired ?? false) ||
        _subscriptionFuture.status == FutureStatus.rejected) {
      _subscriptionFuture = _subscriptionFuture.replaceOrReset(_fetchSubscription());
    }

    return await _subscriptionFuture;
  }

  @action
  Future<api.SubscriptionConfigResponse?> refreshSubscriptionConfig() async {
    try {
      return await _configStore.refreshConfig();
    } catch (e, stack) {
      if (kDebugMode) {
        log('Failed to refresh subscription config', error: e, stackTrace: stack);
      }
      return null;
    }
  }

  @action
  Future<String?> refreshOtherSubscriber() async {
    _otherSubscriberEmailFuture = _otherSubscriberEmailFuture.replaceOrReset(
      _fetchOtherSubscriber(),
    );
    return await _otherSubscriberEmailFuture;
  }

  @action
  Future<void> refreshAll() async {
    await Future.wait([refreshSubscriptionConfig(), refreshSubscription()]);
    await refreshOtherSubscriber();
  }

  @action
  Future<void> pauseSubscription(String periodCode) async {
    await _subscriptionService.pauseSubscription(periodCode);
    await refreshSubscription(force: true);
  }

  Future<void> resumeSubscription() async {
    await _subscriptionService.resumeSubscription();
    await refreshSubscription(force: true);
  }

  Future<api.OrderSummaryResponse> calculateOrderBreakdown({
    required String planId,
    required String country,
    String? state,
    String? couponCode,
  }) async {
    final subscription = _subscriptionFuture.value;
    final subscriptionId = subscription?.id;
    if (subscriptionId.isNotNullOrEmpty) {
      final response = await _apiSubscription.orderUpdateSummary(
        id: subscriptionId!,
        planId: planId,
        currency: 'USD',
        couponCode: couponCode,
      );
      return response.data!;
    }

    final response = await _apiSubscription.orderSummary(
      orderSummaryRequest: api.OrderSummaryRequest(
        planId: planId,
        country: country,
        state: state,
        couponCode: couponCode,
      ),
    );
    return response.data!;
  }

  @action
  void mockSubscriptionFailureStatus() {
    _subscriptionFuture = ObservableFuture.error(Exception('mock error'));
  }

  FutureOr<void> dispose() async {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
