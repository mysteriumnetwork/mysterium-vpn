import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:vpn_api/vpn_api.dart' as api;

// Include generated file
part 'subscription_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionStore = _SubscriptionStore with _$SubscriptionStore;

abstract class _SubscriptionStore with Store {
  _SubscriptionStore({
    required SubscriptionService subscriptionService,
    required AuthSessionStore authSessionStore,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
  }) : _subscriptionService = subscriptionService,
       _authSessionStore = authSessionStore,
       _analyticsStore = analyticsStore,
       _remoteConfigStore = remoteConfigStore {
    _authReactionDisposer = reaction<bool>((_) => _authSessionStore.isAuthenticated, (
      status,
    ) async {
      if (status) {
        _subscriptionFuture = ObservableFuture(_fetchSubscription());
      }
    }, fireImmediately: true);
  }

  final SubscriptionService _subscriptionService;
  final AuthSessionStore _authSessionStore;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  ReactionDisposer? _authReactionDisposer;

  @visibleForTesting
  bool testIsIOS = false;

  bool get _isIOS => testIsIOS || Platform.isIOS;

  @readonly
  late ObservableFuture<Subscription> _subscriptionFuture = ObservableFuture(_fetchSubscription());

  @readonly
  late ObservableFuture<api.SubscriptionConfigResponse?> _subscriptionConfigFuture =
      ObservableFuture(_fetchSubscriptionConfig());

  @readonly
  late ObservableFuture<String?> _otherSubscriberEmailFuture = ObservableFuture(
    _fetchOtherSubscriber(),
  );

  @readonly
  SubscriptionStatus? _subscriptionStatus;

  @computed
  bool? get isSubscribed => _subscriptionFuture.value?.active;

  @computed
  bool get isSubscriptionLoading {
    if (storeState == StoreState.loading) {
      return true;
    }
    if (_subscriptionStatus == SubscriptionStatus.pending ||
        _subscriptionStatus == SubscriptionStatus.verifying) {
      return true;
    }
    if (_subscriptionFuture.status == FutureStatus.pending ||
        _subscriptionConfigFuture.status == FutureStatus.pending) {
      return true;
    }

    return false;
  }

  @computed
  StoreState get storeState => switch (_subscriptionConfigFuture.status) {
    FutureStatus.pending => StoreState.loading,
    FutureStatus.rejected => StoreState.notAvailable,
    FutureStatus.fulfilled =>
      _subscriptionConfigFuture.value != null ? StoreState.available : StoreState.notAvailable,
  };

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

  Future<api.SubscriptionConfigResponse?> _fetchSubscriptionConfig() async {
    if (Platform.isWindows) {
      return null;
    }
    try {
      final config = await _subscriptionService.fetchSubscriptionConfig();
      await _subscriptionService.clearPendingTransactions();
      return config;
    } on NotAvailableException catch (_) {
      return null;
    }
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
    _subscriptionConfigFuture = _subscriptionConfigFuture.replaceOrReset(
      _fetchSubscriptionConfig(),
    );
    return await _subscriptionConfigFuture;
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

    await Future.wait([refreshOtherSubscriber()]);
  }

  @action
  void mockSubscriptionFailureStatus() {
    _subscriptionFuture = ObservableFuture.error(Exception('mock error'));
  }

  FutureOr<void> dispose() async {
    _authReactionDisposer?.call();
  }
}
