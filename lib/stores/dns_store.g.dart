// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DNSStore on _DNSStore, Store {
  Computed<bool>? _$malwareContentBlockerComputed;

  @override
  bool get malwareContentBlocker => (_$malwareContentBlockerComputed ??= Computed<bool>(
    () => super.malwareContentBlocker,
    name: '_DNSStore.malwareContentBlocker',
  )).value;
  Computed<bool>? _$notSafeContentBlockerComputed;

  @override
  bool get notSafeContentBlocker => (_$notSafeContentBlockerComputed ??= Computed<bool>(
    () => super.notSafeContentBlocker,
    name: '_DNSStore.notSafeContentBlocker',
  )).value;
  Computed<BlockerType>? _$blockerTypeComputed;

  @override
  BlockerType get blockerType => (_$blockerTypeComputed ??= Computed<BlockerType>(
    () => super.blockerType,
    name: '_DNSStore.blockerType',
  )).value;
  Computed<bool>? _$hideNotSafeContentBlockerComputed;

  @override
  bool get hideNotSafeContentBlocker => (_$hideNotSafeContentBlockerComputed ??= Computed<bool>(
    () => super.hideNotSafeContentBlocker,
    name: '_DNSStore.hideNotSafeContentBlocker',
  )).value;
  Computed<bool>? _$hideMalwareContentBlockerComputed;

  @override
  bool get hideMalwareContentBlocker => (_$hideMalwareContentBlockerComputed ??= Computed<bool>(
    () => super.hideMalwareContentBlocker,
    name: '_DNSStore.hideMalwareContentBlocker',
  )).value;
  Computed<String>? _$dnsAddressComputed;

  @override
  String get dnsAddress => (_$dnsAddressComputed ??= Computed<String>(
    () => super.dnsAddress,
    name: '_DNSStore.dnsAddress',
  )).value;

  late final _$malwareContentBlockerFutureAtom = Atom(
    name: '_DNSStore.malwareContentBlockerFuture',
    context: context,
  );

  @override
  ObservableFuture<bool> get malwareContentBlockerFuture {
    _$malwareContentBlockerFutureAtom.reportRead();
    return super.malwareContentBlockerFuture;
  }

  @override
  set malwareContentBlockerFuture(ObservableFuture<bool> value) {
    _$malwareContentBlockerFutureAtom.reportWrite(value, super.malwareContentBlockerFuture, () {
      super.malwareContentBlockerFuture = value;
    });
  }

  late final _$notSafeContentBlockerFutureAtom = Atom(
    name: '_DNSStore.notSafeContentBlockerFuture',
    context: context,
  );

  @override
  ObservableFuture<bool> get notSafeContentBlockerFuture {
    _$notSafeContentBlockerFutureAtom.reportRead();
    return super.notSafeContentBlockerFuture;
  }

  @override
  set notSafeContentBlockerFuture(ObservableFuture<bool> value) {
    _$notSafeContentBlockerFutureAtom.reportWrite(value, super.notSafeContentBlockerFuture, () {
      super.notSafeContentBlockerFuture = value;
    });
  }

  late final _$_getAndSetMalwareBlockerContentAsyncAction = AsyncAction(
    '_DNSStore._getAndSetMalwareBlockerContent',
    context: context,
  );

  @override
  Future<bool> _getAndSetMalwareBlockerContent() {
    return _$_getAndSetMalwareBlockerContentAsyncAction.run(
      () => super._getAndSetMalwareBlockerContent(),
    );
  }

  late final _$_getAndSetNotSafeContentBlockerAsyncAction = AsyncAction(
    '_DNSStore._getAndSetNotSafeContentBlocker',
    context: context,
  );

  @override
  Future<bool> _getAndSetNotSafeContentBlocker() {
    return _$_getAndSetNotSafeContentBlockerAsyncAction.run(
      () => super._getAndSetNotSafeContentBlocker(),
    );
  }

  late final _$toggleMalwareBlockerAsyncAction = AsyncAction(
    '_DNSStore.toggleMalwareBlocker',
    context: context,
  );

  @override
  Future<void> toggleMalwareBlocker() {
    return _$toggleMalwareBlockerAsyncAction.run(() => super.toggleMalwareBlocker());
  }

  late final _$toggleNotSafeContentBlockerAsyncAction = AsyncAction(
    '_DNSStore.toggleNotSafeContentBlocker',
    context: context,
  );

  @override
  Future<void> toggleNotSafeContentBlocker() {
    return _$toggleNotSafeContentBlockerAsyncAction.run(() => super.toggleNotSafeContentBlocker());
  }

  late final _$_DNSStoreActionController = ActionController(name: '_DNSStore', context: context);

  @override
  Future<bool> getMalwareContentBlocker() {
    final _$actionInfo = _$_DNSStoreActionController.startAction(
      name: '_DNSStore.getMalwareContentBlocker',
    );
    try {
      return super.getMalwareContentBlocker();
    } finally {
      _$_DNSStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> getNotSafeContentBlocker() {
    final _$actionInfo = _$_DNSStoreActionController.startAction(
      name: '_DNSStore.getNotSafeContentBlocker',
    );
    try {
      return super.getNotSafeContentBlocker();
    } finally {
      _$_DNSStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
malwareContentBlockerFuture: ${malwareContentBlockerFuture},
notSafeContentBlockerFuture: ${notSafeContentBlockerFuture},
malwareContentBlocker: ${malwareContentBlocker},
notSafeContentBlocker: ${notSafeContentBlocker},
blockerType: ${blockerType},
hideNotSafeContentBlocker: ${hideNotSafeContentBlocker},
hideMalwareContentBlocker: ${hideMalwareContentBlocker},
dnsAddress: ${dnsAddress}
    ''';
  }
}
