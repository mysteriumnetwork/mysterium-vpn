import 'dart:async';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/subscription_pause_duration.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_cancellation_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionCancellationStore = _SubscriptionCancellationStore
    with _$SubscriptionCancellationStore;

abstract class _SubscriptionCancellationStore with Store {
  _SubscriptionCancellationStore({
    required this._analyticsStore,
    required this._subscriptionStore,
    required this._remoteConfigStore,
  });

  late final List<ReactionDisposer> _reactions = [];
  late final SubscriptionStore _subscriptionStore;
  late final AnalyticsStore _analyticsStore;
  late final RemoteConfigStore _remoteConfigStore;

  @observable
  bool _isProcessing = false;

  @computed
  bool get isProcessing => _isProcessing;

  @observable
  Exception? _error;

  @computed
  Exception? get error => _error;

  String get linkToCancelSubscription {
    if (_subscriptionStore.useWebFlow) {
      return 'https://www.google.com';
    } else {
      if (Platform.isAndroid) {
        return 'https://play.google.com/store/account/subscriptions';
      } else if (Platform.isIOS || Platform.isMacOS) {
        return 'https://account.apple.com/account/manage/section/subscriptions';
      } else {
        return 'https://www.google.com';
      }
    }
  }

  /// Pause options from ConfigCat. Empty when pause offer is disabled.
  @computed
  List<SubscriptionPauseDuration> get availablePauseDurations {
    final periods = _remoteConfigStore.subscriptionPauseDurations;
    return SubscriptionPauseDuration.values
        .where((duration) => periods.containsKey(duration.value))
        .toList();
  }

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
  Future<bool> pauseSubscription(SubscriptionPauseDuration duration) async {
    final periodCode = _remoteConfigStore.subscriptionPauseDurations[duration.value];
    if (periodCode == null || periodCode.isEmpty) {
      return false;
    }

    _isProcessing = true;

    try {
      await _subscriptionStore.pauseSubscription(periodCode);
      await Future.wait([
        _analyticsStore.logCancellationPauseAccepted(),
        _analyticsStore.logSubscriptionCancellationPauseDuration(months: duration.value),
      ]);
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
    if (isStoreSubscription() || availablePauseDurations.isEmpty) {
      return false;
    }
    final subscription = await _subscriptionStore.subscriptionFuture;
    return !(subscription.paused ?? false);
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
