import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
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
    required SubscriptionService subscriptionService,
    required AuthSessionStore authSessionStore,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required SubscriptionConfigStore configStore,
  }) : _subscriptionService = subscriptionService,
       _authSessionStore = authSessionStore,
       _analyticsStore = analyticsStore,
       _remoteConfigStore = remoteConfigStore,
       _configStore = configStore {
    _reactions = [
      reaction<bool>((_) => _authSessionStore.isAuthenticated, (status) {
        if (status) {
          _subscriptionFuture = ObservableFuture(_fetchSubscription());
        }
      }, fireImmediately: true),
      reaction((_) => _subscriptionFuture.value?.planId, (planId) {
        if (planId != null) {
          _configStore.refreshPlan();
        }
      }),
    ];
  }

  final SubscriptionService _subscriptionService;
  final AuthSessionStore _authSessionStore;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final SubscriptionConfigStore _configStore;
  late final List<ReactionDisposer> _reactions;

  @visibleForTesting
  bool testIsIOS = false;

  bool get _isIOS => testIsIOS || Platform.isIOS;

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
  bool get isSubscriptionLoading {
    if (storeState == StoreState.loading) {
      return true;
    }
    if (_subscriptionFuture.status == FutureStatus.pending ||
        subscriptionConfigFuture.status == FutureStatus.pending) {
      return true;
    }
    return false;
  }

  @computed
  StoreState get storeState => switch (subscriptionConfigFuture.status) {
    FutureStatus.pending => StoreState.loading,
    FutureStatus.rejected => StoreState.notAvailable,
    FutureStatus.fulfilled =>
      subscriptionConfigFuture.value != null ? StoreState.available : StoreState.notAvailable,
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
  void mockSubscriptionFailureStatus() {
    _subscriptionFuture = ObservableFuture.error(Exception('mock error'));
  }

  FutureOr<void> dispose() async {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
