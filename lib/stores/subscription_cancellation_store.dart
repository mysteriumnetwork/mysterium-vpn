import 'dart:async';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/subscription_pause_duration.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_cancellation_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionCancellationStore = _SubscriptionCancellationStore
    with _$SubscriptionCancellationStore;

abstract class _SubscriptionCancellationStore with Store {
  _SubscriptionCancellationStore({required this._analyticsStore, required this._subscriptionStore});

  late final List<ReactionDisposer> _reactions = [];
  late final SubscriptionStore _subscriptionStore;
  late final AnalyticsStore _analyticsStore;

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

  /// Called when the user confirms the pre-flow cancellation prompt.
  void onCancellationConfirmed() {
    _analyticsStore.logCancellationStarted().ignore();
  }

  @action
  Future<void> setSurvey({required Set<String> reasons, String? feedback}) async {
    final trimmedFeedback = feedback?.trim();
    if (reasons.isEmpty && (trimmedFeedback == null || trimmedFeedback.isEmpty)) {
      return;
    }
    _isProcessing = true;
    await _analyticsStore.logSubscriptionCancellationSurvey(
      reasons: reasons,
      feedback: trimmedFeedback,
    );
    _isProcessing = false;
  }

  /// Returns `true` when the pause succeeded.
  @action
  Future<bool> pauseSubscription(SubscriptionPauseDuration duration) async {
    _isProcessing = true;

    try {
      await _subscriptionStore.pauseSubscription(duration);
      await _analyticsStore.logSubscriptionCancellationPauseDuration(months: duration.value);
      _isProcessing = false;
      return true;
    } on Exception catch (e) {
      showSnackbar(e.toString());
      _error = e;
      _isProcessing = false;
      return false;
    }
  }

  bool isStoreSubscription() => !_subscriptionStore.useWebFlow;

  Future<bool> canPauseSubscription() async {
    final subscription = await _subscriptionStore.subscriptionFuture;
    if (isStoreSubscription()) {
      return false;
    }
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
