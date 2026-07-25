import 'dart:async';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_cancellation_store.g.dart';

enum SubscriptionCancellationFlow {
  /// Displays a prompt modal to confirm the cancellation.
  prompt,

  /// Retrieves the reason for cancellation from the user.
  survey,

  /// Freezes the subscription for the next month.
  freeze,

  /// Sends the user to the web flow to continue the cancellation.
  transferToWebFlow,

  /// Displays a summary modal with the cancellation details.
  cancellationSummary,
}

// ignore: library_private_types_in_public_api
class SubscriptionCancellationStore = _SubscriptionCancellationStore
    with _$SubscriptionCancellationStore;

abstract class _SubscriptionCancellationStore with Store {
  _SubscriptionCancellationStore({
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required SubscriptionStore subscriptionStore,
  }) : _analyticsStore = analyticsStore,
       _remoteConfigStore = remoteConfigStore,
       _subscriptionStore = subscriptionStore {
    _reactions.add(
      autorun((_) {
        final options = _remoteConfigStore.subscriptionFreezeDurationOptions;
        _freezeDurations = options;
        if (_freezeDurations.isEmpty) {
          _freezeDurations = [1, 3, 6];
        }
      }),
    );
  }

  late final List<ReactionDisposer> _reactions = [];
  late final SubscriptionStore _subscriptionStore;
  late final AnalyticsStore _analyticsStore;
  late final RemoteConfigStore _remoteConfigStore;

  @observable
  SubscriptionCancellationFlow _cancellationFlowStep = SubscriptionCancellationFlow.prompt;

  @computed
  SubscriptionCancellationFlow get cancellationFlowStep => _cancellationFlowStep;

  @observable
  bool _isProcessing = false;

  @computed
  bool get isProcessing => _isProcessing;

  @observable
  List<int> _freezeDurations = [];

  @computed
  List<int> get freezeDurations => _freezeDurations;

  @observable
  int? _selectedFreezeDuration;

  @computed
  int? get selectedFreezeDuration => _selectedFreezeDuration;

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

  @action
  Future<void> setSurvey({required Set<String> reasons, String? feedback}) async {
    if (reasons.isNotEmpty || feedback != null || feedback!.isNotEmpty) {
      _isProcessing = true;
      await _analyticsStore.logSubscriptionCancellationSurvey(reasons: reasons, feedback: feedback);
      _isProcessing = false;
    }

    await moveToNextStep();
  }

  @action
  Future<void> setPauseDuration(int months) async {
    _isProcessing = true;
    _selectedFreezeDuration = months;
    await Future.delayed(const Duration(seconds: 3));
    // await _analyticsStore.logSubscriptionCancellationPauseDuration(months: months);
    //TODO: Implement the logic to set the freeze duration.
    _isProcessing = false;

    await moveToNextStep();
  }

  @action
  Future<void> cancelSubscription() async {
    _isProcessing = true;
    await Future.delayed(const Duration(seconds: 3));
    // await _analyticsStore.logSubscriptionCancellation();
    _isProcessing = false;
    await moveToNextStep();
  }

  Future<void> moveToNextStep() async {
    switch (_cancellationFlowStep) {
      case SubscriptionCancellationFlow.prompt:
        _cancellationFlowStep = SubscriptionCancellationFlow.survey;
        _analyticsStore.logCancellationStarted().ignore();
        break;
      case SubscriptionCancellationFlow.survey:
        if (_freezeDurations.isEmpty) {
          _cancellationFlowStep = SubscriptionCancellationFlow.cancellationSummary;
        } else {
          _cancellationFlowStep = SubscriptionCancellationFlow.freeze;
        }
        break;
      case SubscriptionCancellationFlow.freeze:
        //TODO: Check if the user decided to freeze the subscription or cancel it.
        // If the user decided to freeze the subscription, the flow should end here.
        // If the user decided to cancel the subscription, the user should be redirected to the web flow.
        _cancellationFlowStep = SubscriptionCancellationFlow.transferToWebFlow;
        break;
      case SubscriptionCancellationFlow.transferToWebFlow:
        //TODO: Redirect the user to the web flow.
        break;
      case SubscriptionCancellationFlow.cancellationSummary:
        _cancellationFlowStep = SubscriptionCancellationFlow.prompt;
    }
  }

  @action
  void reset() {
    _cancellationFlowStep = SubscriptionCancellationFlow.prompt;
    _isProcessing = false;
    _selectedFreezeDuration = null;
  }

  FutureOr<void> dispose() async {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
