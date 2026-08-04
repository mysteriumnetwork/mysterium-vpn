// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_cancellation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionCancellationStore on _SubscriptionCancellationStore, Store {
  Computed<bool>? _$isProcessingComputed;

  @override
  bool get isProcessing => (_$isProcessingComputed ??= Computed<bool>(
    () => super.isProcessing,
    name: '_SubscriptionCancellationStore.isProcessing',
  )).value;
  Computed<Exception?>? _$errorComputed;

  @override
  Exception? get error => (_$errorComputed ??= Computed<Exception?>(
    () => super.error,
    name: '_SubscriptionCancellationStore.error',
  )).value;

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

  late final _$_errorAtom = Atom(name: '_SubscriptionCancellationStore._error', context: context);

  @override
  Exception? get _error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  set _error(Exception? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
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

  late final _$pauseSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionCancellationStore.pauseSubscription',
    context: context,
  );

  @override
  Future<bool> pauseSubscription(SubscriptionPauseDuration duration) {
    return _$pauseSubscriptionAsyncAction.run(() => super.pauseSubscription(duration));
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
isProcessing: ${isProcessing},
error: ${error}
    ''';
  }
}
