import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'smart_refresh_store.g.dart';

// ignore: library_private_types_in_public_api
class SmartRefreshStore = _SmartRefreshStore with _$SmartRefreshStore;

abstract class _SmartRefreshStore
    with Store, Disposeable, WidgetsBindingObserver, BackgroundDurationObserver {
  _SmartRefreshStore(
    this._locationsStore,
    this._subscriptionStore,
    this._authSessionStore,
    this._termsConditionsStore,
    this._logger,
  ) {
    _init();
  }

  final LocationsStore _locationsStore;
  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;
  final TermsConditionsStore _termsConditionsStore;
  final Talker _logger;
  late final List<ReactionDisposer> _disposers;
  late final Debouncer _subscriptionDebouncer;

  Subscription? _lastSubscription;

  void _init() {
    _subscriptionDebouncer = Debouncer();

    _disposers = [
      // Tracks the subscription itself, not its planId: a plan-less
      // subscription also reports a null planId, so only the value's own
      // nullability separates a first load from a plan change.
      reaction<Subscription?>(
        (_) => _subscriptionStore.subscriptionFuture.value,
        _handlePlanChange,
        delay: 200,
        fireImmediately: false,
      ),
      // Locations carry per-user isAvailable flags from the API. Refresh
      // on every auth-state transition so the cache reflects the current
      // user — especially after logout/login to the same account, where
      // planId doesn't change and the planId reaction wouldn't fire.
      reaction(
        (_) => _authSessionStore.isAuthenticated,
        (_) => _refreshLocations(invalidate: true),
        fireImmediately: false,
      ),
    ];
    WidgetsBinding.instance.addObserver(this);
  }

  /// No minimum: any return to the foreground re-checks. Cold start is
  /// deliberately excluded — SubscriptionStore and TermsConditionsStore both
  /// fetch from their own `fireImmediately` auth reactions, so firing here too
  /// would just duplicate both calls on every launch.
  @override
  void onReturnedToForeground(Duration backgroundedFor) => _onResume();

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _subscriptionDebouncer.dispose();
    for (final disposer in _disposers) {
      disposer();
    }
  }

  Future<void> _onResume() async {
    // No post-frame hop: a static page schedules no frame, so it could hang.
    _subscriptionDebouncer.debounce(() {
      refreshSubscriptionOnResume();
      // Swallows its own failures, so nothing to catch here.
      _termsConditionsStore.checkForUpdatedTermsConditions();
    });
  }

  @visibleForTesting
  Future<void> refreshSubscriptionOnResume() async {
    try {
      await _subscriptionStore.refreshSubscription(force: true);
    } on Object catch (e, stack) {
      _logger.handle(e, stack);
    }
  }

  /// Locations carry per-user `isAvailable` flags derived from the plan, so a
  /// plan change invalidates them. The first resolved subscription is not a
  /// change — the backend derives those flags from the token, so the initial
  /// fetch already carried them. A fresh future (login) resolves to null and is
  /// left to the auth reaction above.
  void _handlePlanChange(Subscription? subscription) {
    if (subscription == null) {
      return;
    }
    final previous = _lastSubscription;
    _lastSubscription = subscription;
    if (previous != null && previous.planId != subscription.planId) {
      _refreshLocations();
    }
  }

  Future<void> _refreshLocations({bool invalidate = false}) async {
    try {
      await _locationsStore.refreshAll(invalidate: invalidate);
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
  }
}
