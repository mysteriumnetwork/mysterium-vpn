// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_checkout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionCheckoutStore on _SubscriptionCheckoutStore, Store {
  late final _$isLoadingAtom = Atom(name: '_SubscriptionCheckoutStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$outcomeAtom = Atom(name: '_SubscriptionCheckoutStore.outcome', context: context);

  @override
  CheckoutOutcome? get outcome {
    _$outcomeAtom.reportRead();
    return super.outcome;
  }

  @override
  set outcome(CheckoutOutcome? value) {
    _$outcomeAtom.reportWrite(value, super.outcome, () {
      super.outcome = value;
    });
  }

  late final _$errorAtom = Atom(name: '_SubscriptionCheckoutStore.error', context: context);

  @override
  Object? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Object? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$subscribeAsyncAction = AsyncAction(
    '_SubscriptionCheckoutStore.subscribe',
    context: context,
  );

  @override
  Future<void> subscribe(String id) {
    return _$subscribeAsyncAction.run(() => super.subscribe(id));
  }

  late final _$_SubscriptionCheckoutStoreActionController = ActionController(
    name: '_SubscriptionCheckoutStore',
    context: context,
  );

  @override
  void _onStatusChanged(SubscriptionStatus? status) {
    final _$actionInfo = _$_SubscriptionCheckoutStoreActionController.startAction(
      name: '_SubscriptionCheckoutStore._onStatusChanged',
    );
    try {
      return super._onStatusChanged(status);
    } finally {
      _$_SubscriptionCheckoutStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOutcome() {
    final _$actionInfo = _$_SubscriptionCheckoutStoreActionController.startAction(
      name: '_SubscriptionCheckoutStore.clearOutcome',
    );
    try {
      return super.clearOutcome();
    } finally {
      _$_SubscriptionCheckoutStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
outcome: ${outcome},
error: ${error}
    ''';
  }
}
