// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_prompt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReviewPromptStore on _ReviewPromptStore, Store {
  late final _$pendingPromptAtom = Atom(name: '_ReviewPromptStore.pendingPrompt', context: context);

  @override
  bool get pendingPrompt {
    _$pendingPromptAtom.reportRead();
    return super.pendingPrompt;
  }

  @override
  set pendingPrompt(bool value) {
    _$pendingPromptAtom.reportWrite(value, super.pendingPrompt, () {
      super.pendingPrompt = value;
    });
  }

  late final _$recordSuccessfulSessionAsyncAction = AsyncAction(
    '_ReviewPromptStore.recordSuccessfulSession',
    context: context,
  );

  @override
  Future<void> recordSuccessfulSession() {
    return _$recordSuccessfulSessionAsyncAction.run(() => super.recordSuccessfulSession());
  }

  late final _$recordSessionOutcomeAsyncAction = AsyncAction(
    '_ReviewPromptStore.recordSessionOutcome',
    context: context,
  );

  @override
  Future<void> recordSessionOutcome({required bool success}) {
    return _$recordSessionOutcomeAsyncAction.run(
      () => super.recordSessionOutcome(success: success),
    );
  }

  late final _$evaluateAsyncAction = AsyncAction('_ReviewPromptStore.evaluate', context: context);

  @override
  Future<void> evaluate() {
    return _$evaluateAsyncAction.run(() => super.evaluate());
  }

  late final _$onSuppressedByActiveFlowAsyncAction = AsyncAction(
    '_ReviewPromptStore.onSuppressedByActiveFlow',
    context: context,
  );

  @override
  Future<void> onSuppressedByActiveFlow() {
    return _$onSuppressedByActiveFlowAsyncAction.run(() => super.onSuppressedByActiveFlow());
  }

  late final _$onShownAsyncAction = AsyncAction('_ReviewPromptStore.onShown', context: context);

  @override
  Future<void> onShown() {
    return _$onShownAsyncAction.run(() => super.onShown());
  }

  late final _$onSatisfactionNoAsyncAction = AsyncAction(
    '_ReviewPromptStore.onSatisfactionNo',
    context: context,
  );

  @override
  Future<void> onSatisfactionNo() {
    return _$onSatisfactionNoAsyncAction.run(() => super.onSatisfactionNo());
  }

  late final _$onLeaveReviewAsyncAction = AsyncAction(
    '_ReviewPromptStore.onLeaveReview',
    context: context,
  );

  @override
  Future<void> onLeaveReview() {
    return _$onLeaveReviewAsyncAction.run(() => super.onLeaveReview());
  }

  late final _$onDismissAsyncAction = AsyncAction('_ReviewPromptStore.onDismiss', context: context);

  @override
  Future<void> onDismiss() {
    return _$onDismissAsyncAction.run(() => super.onDismiss());
  }

  late final _$resetStateAsyncAction = AsyncAction(
    '_ReviewPromptStore.resetState',
    context: context,
  );

  @override
  Future<void> resetState() {
    return _$resetStateAsyncAction.run(() => super.resetState());
  }

  late final _$_ReviewPromptStoreActionController = ActionController(
    name: '_ReviewPromptStore',
    context: context,
  );

  @override
  Future<void> onSatisfactionYes() {
    final _$actionInfo = _$_ReviewPromptStoreActionController.startAction(
      name: '_ReviewPromptStore.onSatisfactionYes',
    );
    try {
      return super.onSatisfactionYes();
    } finally {
      _$_ReviewPromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pendingPrompt: ${pendingPrompt}
    ''';
  }
}
