// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionConfigStore on _SubscriptionConfigStore, Store {
  late final _$_futureAtom = Atom(name: '_SubscriptionConfigStore._future', context: context);

  ObservableFuture<SubscriptionConfigResponse?> get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<SubscriptionConfigResponse?> get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(ObservableFuture<SubscriptionConfigResponse?> value) {
    _$_futureAtom.reportWrite(value, __futureIsInitialized ? super._future : null, () {
      super._future = value;
      __futureIsInitialized = true;
    });
  }

  late final _$_subscriptionPlanFutureAtom = Atom(
    name: '_SubscriptionConfigStore._subscriptionPlanFuture',
    context: context,
  );

  ObservableFuture<GetPlanResponse> get subscriptionPlanFuture {
    _$_subscriptionPlanFutureAtom.reportRead();
    return super._subscriptionPlanFuture;
  }

  @override
  ObservableFuture<GetPlanResponse> get _subscriptionPlanFuture => subscriptionPlanFuture;

  bool __subscriptionPlanFutureIsInitialized = false;

  @override
  set _subscriptionPlanFuture(ObservableFuture<GetPlanResponse> value) {
    _$_subscriptionPlanFutureAtom.reportWrite(
      value,
      __subscriptionPlanFutureIsInitialized ? super._subscriptionPlanFuture : null,
      () {
        super._subscriptionPlanFuture = value;
        __subscriptionPlanFutureIsInitialized = true;
      },
    );
  }

  late final _$_fetchedPlanIdAtom = Atom(
    name: '_SubscriptionConfigStore._fetchedPlanId',
    context: context,
  );

  String? get fetchedPlanId {
    _$_fetchedPlanIdAtom.reportRead();
    return super._fetchedPlanId;
  }

  @override
  String? get _fetchedPlanId => fetchedPlanId;

  @override
  set _fetchedPlanId(String? value) {
    _$_fetchedPlanIdAtom.reportWrite(value, super._fetchedPlanId, () {
      super._fetchedPlanId = value;
    });
  }

  late final _$refreshConfigAsyncAction = AsyncAction(
    '_SubscriptionConfigStore.refreshConfig',
    context: context,
  );

  @override
  Future<SubscriptionConfigResponse?> refreshConfig() {
    return _$refreshConfigAsyncAction.run(() => super.refreshConfig());
  }

  late final _$_SubscriptionConfigStoreActionController = ActionController(
    name: '_SubscriptionConfigStore',
    context: context,
  );

  @override
  void refreshPlan(String planId) {
    final _$actionInfo = _$_SubscriptionConfigStoreActionController.startAction(
      name: '_SubscriptionConfigStore.refreshPlan',
    );
    try {
      return super.refreshPlan(planId);
    } finally {
      _$_SubscriptionConfigStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
