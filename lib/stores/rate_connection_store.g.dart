// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_connection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RateConnectionStore on _RateConnectionStore, Store {
  Computed<bool>? _$isLikeModeComputed;

  @override
  bool get isLikeMode => (_$isLikeModeComputed ??=
          Computed<bool>(() => super.isLikeMode, name: '_RateConnectionStore.isLikeMode'))
      .value;
  Computed<bool>? _$isDislikeModeComputed;

  @override
  bool get isDislikeMode => (_$isDislikeModeComputed ??=
          Computed<bool>(() => super.isDislikeMode, name: '_RateConnectionStore.isDislikeMode'))
      .value;
  Computed<List<RateConnectionReason>>? _$selectedReasonsComputed;

  @override
  List<RateConnectionReason> get selectedReasons => (_$selectedReasonsComputed ??=
          Computed<List<RateConnectionReason>>(() => super.selectedReasons,
              name: '_RateConnectionStore.selectedReasons'))
      .value;
  Computed<List<RateConnectionReason>>? _$showReasonsComputed;

  @override
  List<RateConnectionReason> get showReasons =>
      (_$showReasonsComputed ??= Computed<List<RateConnectionReason>>(() => super.showReasons,
              name: '_RateConnectionStore.showReasons'))
          .value;

  late final _$feedbackAtom = Atom(name: '_RateConnectionStore.feedback', context: context);

  @override
  String get feedback {
    _$feedbackAtom.reportRead();
    return super.feedback;
  }

  @override
  set feedback(String value) {
    _$feedbackAtom.reportWrite(value, super.feedback, () {
      super.feedback = value;
    });
  }

  late final _$submitRateConnectionAsyncAction =
      AsyncAction('_RateConnectionStore.submitRateConnection', context: context);

  @override
  Future<void> submitRateConnection() {
    return _$submitRateConnectionAsyncAction.run(() => super.submitRateConnection());
  }

  late final _$_RateConnectionStoreActionController =
      ActionController(name: '_RateConnectionStore', context: context);

  @override
  void toggleRateConnectionReason(RateConnectionReason reason) {
    final _$actionInfo = _$_RateConnectionStoreActionController.startAction(
        name: '_RateConnectionStore.toggleRateConnectionReason');
    try {
      return super.toggleRateConnectionReason(reason);
    } finally {
      _$_RateConnectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancelRateConnection() {
    final _$actionInfo = _$_RateConnectionStoreActionController.startAction(
        name: '_RateConnectionStore.cancelRateConnection');
    try {
      return super.cancelRateConnection();
    } finally {
      _$_RateConnectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feedback: ${feedback},
isLikeMode: ${isLikeMode},
isDislikeMode: ${isDislikeMode},
selectedReasons: ${selectedReasons},
showReasons: ${showReasons}
    ''';
  }
}
