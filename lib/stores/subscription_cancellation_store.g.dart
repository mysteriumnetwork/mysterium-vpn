// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_cancellation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionCancellationStore on _SubscriptionCancellationStore, Store {
  Computed<SubscriptionCancellationFlow>? _$cancellationFlowStepComputed;

  @override
  SubscriptionCancellationFlow get cancellationFlowStep =>
      (_$cancellationFlowStepComputed ??= Computed<SubscriptionCancellationFlow>(
        () => super.cancellationFlowStep,
        name: '_SubscriptionCancellationStore.cancellationFlowStep',
      )).value;
  Computed<bool>? _$isProcessingComputed;

  @override
  bool get isProcessing => (_$isProcessingComputed ??= Computed<bool>(
    () => super.isProcessing,
    name: '_SubscriptionCancellationStore.isProcessing',
  )).value;
  Computed<List<int>>? _$freezeDurationsComputed;

  @override
  List<int> get freezeDurations => (_$freezeDurationsComputed ??= Computed<List<int>>(
    () => super.freezeDurations,
    name: '_SubscriptionCancellationStore.freezeDurations',
  )).value;
  Computed<int?>? _$selectedFreezeDurationComputed;

  @override
  int? get selectedFreezeDuration => (_$selectedFreezeDurationComputed ??= Computed<int?>(
    () => super.selectedFreezeDuration,
    name: '_SubscriptionCancellationStore.selectedFreezeDuration',
  )).value;

  late final _$_cancellationFlowStepAtom = Atom(
    name: '_SubscriptionCancellationStore._cancellationFlowStep',
    context: context,
  );

  @override
  SubscriptionCancellationFlow get _cancellationFlowStep {
    _$_cancellationFlowStepAtom.reportRead();
    return super._cancellationFlowStep;
  }

  @override
  set _cancellationFlowStep(SubscriptionCancellationFlow value) {
    _$_cancellationFlowStepAtom.reportWrite(value, super._cancellationFlowStep, () {
      super._cancellationFlowStep = value;
    });
  }

  late final _$_isProcessingAtom = Atom(
    name: '_SubscriptionCancellationStore._isProcessing',
    context: context,
  );

  @override
  bool get _isProcessing {
    _$_isProcessingAtom.reportRead();
    return super._isProcessing;
  }

  @override
  set _isProcessing(bool value) {
    _$_isProcessingAtom.reportWrite(value, super._isProcessing, () {
      super._isProcessing = value;
    });
  }

  late final _$_freezeDurationsAtom = Atom(
    name: '_SubscriptionCancellationStore._freezeDurations',
    context: context,
  );

  @override
  List<int> get _freezeDurations {
    _$_freezeDurationsAtom.reportRead();
    return super._freezeDurations;
  }

  @override
  set _freezeDurations(List<int> value) {
    _$_freezeDurationsAtom.reportWrite(value, super._freezeDurations, () {
      super._freezeDurations = value;
    });
  }

  late final _$_selectedFreezeDurationAtom = Atom(
    name: '_SubscriptionCancellationStore._selectedFreezeDuration',
    context: context,
  );

  @override
  int? get _selectedFreezeDuration {
    _$_selectedFreezeDurationAtom.reportRead();
    return super._selectedFreezeDuration;
  }

  @override
  set _selectedFreezeDuration(int? value) {
    _$_selectedFreezeDurationAtom.reportWrite(value, super._selectedFreezeDuration, () {
      super._selectedFreezeDuration = value;
    });
  }

  late final _$setSurveyAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.setSurvey',
    context: context,
  );

  @override
  Future<void> setSurvey({required Set<String> reasons, String? feedback}) {
    return _$setSurveyAsyncAction.run(() => super.setSurvey(reasons: reasons, feedback: feedback));
  }

  late final _$setPauseDurationAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.setPauseDuration',
    context: context,
  );

  @override
  Future<void> setPauseDuration(int months) {
    return _$setPauseDurationAsyncAction.run(() => super.setPauseDuration(months));
  }

  late final _$cancelSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.cancelSubscription',
    context: context,
  );

  @override
  Future<void> cancelSubscription() {
    return _$cancelSubscriptionAsyncAction.run(() => super.cancelSubscription());
  }

  late final _$_SubscriptionCancellationStoreActionController = ActionController(
    name: '_SubscriptionCancellationStore',
    context: context,
  );

  @override
  void reset() {
    final _$actionInfo = _$_SubscriptionCancellationStoreActionController.startAction(
      name: '_SubscriptionCancellationStore.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_SubscriptionCancellationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cancellationFlowStep: ${cancellationFlowStep},
isProcessing: ${isProcessing},
freezeDurations: ${freezeDurations},
selectedFreezeDuration: ${selectedFreezeDuration}
    ''';
  }
}
