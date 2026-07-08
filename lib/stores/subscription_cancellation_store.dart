import 'dart:async';

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

  /// Offers a discount subscription to applicable users.
  offer,

  /// Displays a confirmation modal to confirm the cancellation.
  confirmation,

  /// Displays a summary modal with the cancellation details.
  summary,
}

// ignore: library_private_types_in_public_api
class SubscriptionCancellationStore = _SubscriptionCancellationStore
    with _$SubscriptionCancellationStore;

abstract class _SubscriptionCancellationStore with Store {
  _SubscriptionCancellationStore({
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
  }) : _analyticsStore = analyticsStore,
       _remoteConfigStore = remoteConfigStore {
    _reactions.add(
      autorun((_) {
        _freezeDurations = _remoteConfigStore.subscriptionFreezeDurationOptions;
      }),
    );
  }

  late final List<ReactionDisposer> _reactions;
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
  Future<void> setFreezeDuration(int months) async {
    _isProcessing = true;
    _selectedFreezeDuration = months;
    await _analyticsStore.logSubscriptionCancellationPauseDuration(months: months);
    //TODO: Implement the logic to set the freeze duration.
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
        _cancellationFlowStep = SubscriptionCancellationFlow.freeze;
        break;
      case SubscriptionCancellationFlow.freeze:
        _cancellationFlowStep = SubscriptionCancellationFlow.offer;
      case SubscriptionCancellationFlow.offer:
        _cancellationFlowStep = SubscriptionCancellationFlow.confirmation;
        break;
      case SubscriptionCancellationFlow.confirmation:
        _cancellationFlowStep = SubscriptionCancellationFlow.summary;
        break;
      case SubscriptionCancellationFlow.summary:
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
