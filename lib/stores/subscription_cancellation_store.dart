import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_cancellation_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionCancellationStore = _SubscriptionCancellationStore
    with _$SubscriptionCancellationStore;

abstract class _SubscriptionCancellationStore with Store {
  _SubscriptionCancellationStore({
    required this._analyticsStore,
    required this._subscriptionStore,
    required this._subscriptionService,
    required this._remoteConfigStore,
  });

  late final List<ReactionDisposer> _reactions = [];
  late final SubscriptionStore _subscriptionStore;
  late final AnalyticsStore _analyticsStore;
  late final SubscriptionService _subscriptionService;
  late final RemoteConfigStore _remoteConfigStore;

  @observable
  bool _isProcessing = false;

  @computed
  bool get isProcessing => _isProcessing;

  @observable
  Exception? _error;

  @computed
  Exception? get error => _error;

  /// API period codes (e.g. `1m`, `3m`, `6m`). Empty when pause offer is unavailable.
  @readonly
  ObservableList<String> _availablePauseDurations = ObservableList<String>();

  /// Returns `true` when survey data was logged.
  @action
  Future<bool> setSurvey({required Set<String> reasons, String? feedback}) async {
    final trimmedFeedback = feedback?.trim();
    if (reasons.isEmpty && (trimmedFeedback == null || trimmedFeedback.isEmpty)) {
      return false;
    }
    _isProcessing = true;
    try {
      await Future.wait([
        _analyticsStore.logSubscriptionCancellationSurvey(
          reasons: reasons,
          feedback: trimmedFeedback,
        ),
        _analyticsStore.logCancellationReasonSubmitted(reasons: reasons, feedback: trimmedFeedback),
      ]);
      _isProcessing = false;
      return true;
    } on Exception catch (e) {
      _error = e;
      _isProcessing = false;
      return false;
    }
  }

  /// Returns `true` when the pause succeeded.
  @action
  Future<bool> pauseSubscription(String periodCode) async {
    if (!_availablePauseDurations.contains(periodCode)) {
      return false;
    }

    _isProcessing = true;

    try {
      await _subscriptionStore.pauseSubscription(periodCode);
      final analytics = <Future<void>>[_analyticsStore.logCancellationPauseAccepted()];
      final months = periodCode.numeric;
      if (months != null) {
        analytics.add(_analyticsStore.logSubscriptionCancellationPauseDuration(months: months));
      }
      await Future.wait(analytics);
      _isProcessing = false;
      return true;
    } on Exception catch (e) {
      _error = e;
      _isProcessing = false;
      return false;
    }
  }

  bool isStoreSubscription() => !_subscriptionStore.useWebFlow;

  Future<bool> canPauseSubscription() async {
    if (!_remoteConfigStore.pauseSubscriptionEnabled || isStoreSubscription()) {
      return false;
    }
    await _loadPauseDurations();
    if (_availablePauseDurations.isEmpty) {
      return false;
    }
    final subscription = await _subscriptionStore.subscriptionFuture;
    return !(subscription.paused ?? false);
  }

  @action
  Future<void> _loadPauseDurations() async {
    try {
      final periods = await _subscriptionService.fetchPauseDurations();
      _availablePauseDurations = ObservableList.of(
        periods.map((code) => code.trim()).where((code) => code.isNotEmpty),
      );
    } on Exception catch (e) {
      _error = e;
      _availablePauseDurations = ObservableList<String>();
    }
  }

  @action
  void reset() {
    _isProcessing = false;
    _error = null;
  }

  FutureOr<void> dispose() async {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
