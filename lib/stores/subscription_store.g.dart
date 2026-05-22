// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionStore on _SubscriptionStore, Store {
  Computed<bool?>? _$isSubscribedComputed;

  @override
  bool? get isSubscribed => (_$isSubscribedComputed ??= Computed<bool?>(
    () => super.isSubscribed,
    name: '_SubscriptionStore.isSubscribed',
  )).value;
  Computed<bool>? _$isSubscriptionLoadingComputed;

  @override
  bool get isSubscriptionLoading => (_$isSubscriptionLoadingComputed ??= Computed<bool>(
    () => super.isSubscriptionLoading,
    name: '_SubscriptionStore.isSubscriptionLoading',
  )).value;
  Computed<StoreState>? _$storeStateComputed;

  @override
  StoreState get storeState => (_$storeStateComputed ??= Computed<StoreState>(
    () => super.storeState,
    name: '_SubscriptionStore.storeState',
  )).value;
  Computed<api.SubscriptionConfigResponsePlansInnerMetadata?>? _$planMetadataComputed;

  @override
  api.SubscriptionConfigResponsePlansInnerMetadata? get planMetadata =>
      (_$planMetadataComputed ??= Computed<api.SubscriptionConfigResponsePlansInnerMetadata?>(
        () => super.planMetadata,
        name: '_SubscriptionStore.planMetadata',
      )).value;
  Computed<bool>? _$residentialIPsAllowedComputed;

  @override
  bool get residentialIPsAllowed => (_$residentialIPsAllowedComputed ??= Computed<bool>(
    () => super.residentialIPsAllowed,
    name: '_SubscriptionStore.residentialIPsAllowed',
  )).value;
  Computed<bool>? _$useWebFlowComputed;

  @override
  bool get useWebFlow => (_$useWebFlowComputed ??= Computed<bool>(
    () => super.useWebFlow,
    name: '_SubscriptionStore.useWebFlow',
  )).value;
  Computed<bool>? _$isOnMaxPlanComputed;

  @override
  bool get isOnMaxPlan => (_$isOnMaxPlanComputed ??= Computed<bool>(
    () => super.isOnMaxPlan,
    name: '_SubscriptionStore.isOnMaxPlan',
  )).value;
  Computed<bool>? _$malwareBlockingAllowedComputed;

  @override
  bool get malwareBlockingAllowed => (_$malwareBlockingAllowedComputed ??= Computed<bool>(
    () => super.malwareBlockingAllowed,
    name: '_SubscriptionStore.malwareBlockingAllowed',
  )).value;
  Computed<bool>? _$canRedeemCodeComputed;

  @override
  bool get canRedeemCode => (_$canRedeemCodeComputed ??= Computed<bool>(
    () => super.canRedeemCode,
    name: '_SubscriptionStore.canRedeemCode',
  )).value;

  late final _$_subscriptionFutureAtom = Atom(
    name: '_SubscriptionStore._subscriptionFuture',
    context: context,
  );

  ObservableFuture<Subscription> get subscriptionFuture {
    _$_subscriptionFutureAtom.reportRead();
    return super._subscriptionFuture;
  }

  @override
  ObservableFuture<Subscription> get _subscriptionFuture => subscriptionFuture;

  bool __subscriptionFutureIsInitialized = false;

  @override
  set _subscriptionFuture(ObservableFuture<Subscription> value) {
    _$_subscriptionFutureAtom.reportWrite(
      value,
      __subscriptionFutureIsInitialized ? super._subscriptionFuture : null,
      () {
        super._subscriptionFuture = value;
        __subscriptionFutureIsInitialized = true;
      },
    );
  }

  late final _$_otherSubscriberEmailFutureAtom = Atom(
    name: '_SubscriptionStore._otherSubscriberEmailFuture',
    context: context,
  );

  ObservableFuture<String?> get otherSubscriberEmailFuture {
    _$_otherSubscriberEmailFutureAtom.reportRead();
    return super._otherSubscriberEmailFuture;
  }

  @override
  ObservableFuture<String?> get _otherSubscriberEmailFuture => otherSubscriberEmailFuture;

  bool __otherSubscriberEmailFutureIsInitialized = false;

  @override
  set _otherSubscriberEmailFuture(ObservableFuture<String?> value) {
    _$_otherSubscriberEmailFutureAtom.reportWrite(
      value,
      __otherSubscriberEmailFutureIsInitialized ? super._otherSubscriberEmailFuture : null,
      () {
        super._otherSubscriberEmailFuture = value;
        __otherSubscriberEmailFutureIsInitialized = true;
      },
    );
  }

  late final _$_fetchSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionStore._fetchSubscription',
    context: context,
  );

  @override
  Future<Subscription> _fetchSubscription() {
    return _$_fetchSubscriptionAsyncAction.run(() => super._fetchSubscription());
  }

  late final _$refreshSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionStore.refreshSubscription',
    context: context,
  );

  @override
  Future<Subscription> refreshSubscription({bool force = false}) {
    return _$refreshSubscriptionAsyncAction.run(() => super.refreshSubscription(force: force));
  }

  late final _$refreshSubscriptionConfigAsyncAction = AsyncAction(
    '_SubscriptionStore.refreshSubscriptionConfig',
    context: context,
  );

  @override
  Future<api.SubscriptionConfigResponse?> refreshSubscriptionConfig() {
    return _$refreshSubscriptionConfigAsyncAction.run(() => super.refreshSubscriptionConfig());
  }

  late final _$refreshOtherSubscriberAsyncAction = AsyncAction(
    '_SubscriptionStore.refreshOtherSubscriber',
    context: context,
  );

  @override
  Future<String?> refreshOtherSubscriber() {
    return _$refreshOtherSubscriberAsyncAction.run(() => super.refreshOtherSubscriber());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    '_SubscriptionStore.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$_SubscriptionStoreActionController = ActionController(
    name: '_SubscriptionStore',
    context: context,
  );

  @override
  void mockSubscriptionFailureStatus() {
    final _$actionInfo = _$_SubscriptionStoreActionController.startAction(
      name: '_SubscriptionStore.mockSubscriptionFailureStatus',
    );
    try {
      return super.mockSubscriptionFailureStatus();
    } finally {
      _$_SubscriptionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSubscribed: ${isSubscribed},
isSubscriptionLoading: ${isSubscriptionLoading},
storeState: ${storeState},
planMetadata: ${planMetadata},
residentialIPsAllowed: ${residentialIPsAllowed},
useWebFlow: ${useWebFlow},
isOnMaxPlan: ${isOnMaxPlan},
malwareBlockingAllowed: ${malwareBlockingAllowed},
canRedeemCode: ${canRedeemCode}
    ''';
  }
}
