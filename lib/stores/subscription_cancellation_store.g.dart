// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_cancellation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionCancellationStore on _SubscriptionCancellationStore, Store {
  late final _$_isProcessingAtom = Atom(
    name: '_SubscriptionCancellationStore._isProcessing',
    context: context,
  );

  bool get isProcessing {
    _$_isProcessingAtom.reportRead();
    return super._isProcessing;
  }

  @override
  bool get _isProcessing => isProcessing;

  @override
  set _isProcessing(bool value) {
    _$_isProcessingAtom.reportWrite(value, super._isProcessing, () {
      super._isProcessing = value;
    });
  }

  late final _$_errorAtom = Atom(name: '_SubscriptionCancellationStore._error', context: context);

  Exception? get error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  Exception? get _error => error;

  @override
  set _error(Exception? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$_availablePauseDurationsAtom = Atom(
    name: '_SubscriptionCancellationStore._availablePauseDurations',
    context: context,
  );

  ObservableList<String> get availablePauseDurations {
    _$_availablePauseDurationsAtom.reportRead();
    return super._availablePauseDurations;
  }

  @override
  ObservableList<String> get _availablePauseDurations => availablePauseDurations;

  @override
  set _availablePauseDurations(ObservableList<String> value) {
    _$_availablePauseDurationsAtom.reportWrite(value, super._availablePauseDurations, () {
      super._availablePauseDurations = value;
    });
  }

  late final _$_pauseOfferShownAtom = Atom(
    name: '_SubscriptionCancellationStore._pauseOfferShown',
    context: context,
  );

  bool get pauseOfferShown {
    _$_pauseOfferShownAtom.reportRead();
    return super._pauseOfferShown;
  }

  @override
  bool get _pauseOfferShown => pauseOfferShown;

  @override
  set _pauseOfferShown(bool value) {
    _$_pauseOfferShownAtom.reportWrite(value, super._pauseOfferShown, () {
      super._pauseOfferShown = value;
    });
  }

  late final _$setSurveyAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.setSurvey',
    context: context,
  );

  @override
  Future<bool> setSurvey({required Set<String> reasons, String? feedback}) {
    return _$setSurveyAsyncAction.run(() => super.setSurvey(reasons: reasons, feedback: feedback));
  }

  late final _$pauseSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.pauseSubscription',
    context: context,
  );

  @override
  Future<bool> pauseSubscription(String periodCode) {
    return _$pauseSubscriptionAsyncAction.run(() => super.pauseSubscription(periodCode));
  }

  late final _$_loadPauseDurationsAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore._loadPauseDurations',
    context: context,
  );

  @override
  Future<void> _loadPauseDurations() {
    return _$_loadPauseDurationsAsyncAction.run(() => super._loadPauseDurations());
  }

  late final _$_SubscriptionCancellationStoreActionController = ActionController(
    name: '_SubscriptionCancellationStore',
    context: context,
  );

  @override
  void markPauseOfferShown() {
    final _$actionInfo = _$_SubscriptionCancellationStoreActionController.startAction(
      name: '_SubscriptionCancellationStore.markPauseOfferShown',
    );
    try {
      return super.markPauseOfferShown();
    } finally {
      _$_SubscriptionCancellationStoreActionController.endAction(_$actionInfo);
    }
  }

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

    ''';
  }
}
