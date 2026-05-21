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
    required SubscriptionService subscriptionService,
    required AuthSessionStore authSessionStore,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required SubscriptionConfigStore configStore,
  }) : _apiSubscription = api.getSubscription(),
       _subscriptionService = subscriptionService,
       _authSessionStore = authSessionStore,
       _analyticsStore = analyticsStore,
       _remoteConfigStore = remoteConfigStore,
       _configStore = configStore {
    _reactions = [
      reaction<bool>((_) => _authSessionStore.isAuthenticated, (status) {
        // Reset session-scoped dialog memoization so a new login (or
        // re-login as a different user) gets the existing-subscription
        // prompt again if applicable.
        _hasShownExistingSubscriptionDialog = false;
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

  /// Session-scoped flag — set once after the "you already have an active
  /// subscription as X, log out?" dialog has been shown in the current
  /// session, so the dialog doesn't pop up again every time the user re-
  /// opens the upgrade / plans modal (each open creates a fresh
  /// `SubscriptionStatusContainer`, which would otherwise re-trigger the
  /// check). Reset on auth-state changes so a new login can re-prompt.
  bool _hasShownExistingSubscriptionDialog = false;

  bool get hasShownExistingSubscriptionDialog => _hasShownExistingSubscriptionDialog;

  void markExistingSubscriptionDialogShown() {
    _hasShownExistingSubscriptionDialog = true;
  }

  @visibleForTesting
  bool testIsIOS = false;

  @visibleForTesting
  bool testIsAndroid = false;

  @visibleForTesting
  bool testIsMacOS = false;

  @visibleForTesting
  bool testIsWindows = false;

  /// When any `testIsX` flag is set, the platform getters use ONLY the test
  /// values (so a test running on macOS can simulate Android by setting
  /// `testIsAndroid = true` and the real macOS isn't leaked through).
  /// When no test flag is set, falls back to the real `Platform`.
  bool get _useTestPlatform => testIsIOS || testIsAndroid || testIsMacOS || testIsWindows;

  bool get _isIOS => _useTestPlatform ? testIsIOS : Platform.isIOS;

  bool get _isAndroid => _useTestPlatform ? testIsAndroid : Platform.isAndroid;

  bool get _isMacOS => _useTestPlatform ? testIsMacOS : Platform.isMacOS;

  bool get _isWindows => _useTestPlatform ? testIsWindows : Platform.isWindows;

  /// Whether the active subscription's gateway matches the gateway that the
  /// current platform can purchase through. Lives on the store (not on the
  /// [Subscription] model) so tests can simulate Android/iOS/macOS without
  /// touching `dart:io`'s `Platform`.
  bool _gatewayMatchesCurrentPlatform(String? gateway) => switch (gateway?.toLowerCase()) {
    'apple' => _isIOS || _isMacOS,
    'google' => _isAndroid,
    _ => false,
  };

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

  /// `true` when the user can't perform an in-app upgrade — either they're
  /// on a desktop platform without IAP (Windows), or they have an active
  /// subscription paid through a non-mobile gateway (Stripe/Adyen/PayPal/
  /// CoinGate), or through a mobile gateway from a different store
  /// (cross-platform mismatch). Callers should surface a "manage on the
  /// web" CTA instead of the IAP purchase flow in these cases.
  @computed
  bool get useWebFlow {
    if (_isWindows) {
      return true;
    }
    final subscription = _subscriptionFuture.value;
    if (subscription == null || !subscription.active) {
      return false;
    }
    final gateway = subscription.gateway;
    if (gateway == null) {
      return false;
    }
    if (!isMobilePaymentGateway(gateway)) {
      return true;
    }
    return !_gatewayMatchesCurrentPlatform(gateway);
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
