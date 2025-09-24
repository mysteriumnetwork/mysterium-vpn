// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DNSStore on _DNSStore, Store {
  Computed<String?>? _$dnsAddressComputed;

  @override
  String? get dnsAddress => (_$dnsAddressComputed ??=
          Computed<String?>(() => super.dnsAddress, name: '_DNSStore.dnsAddress'))
      .value;

  late final _$_malwareBlockerContentAtom =
      Atom(name: '_DNSStore._malwareBlockerContent', context: context);

  bool get malwareBlockerContent {
    _$_malwareBlockerContentAtom.reportRead();
    return super._malwareBlockerContent;
  }

  @override
  bool get _malwareBlockerContent => malwareBlockerContent;

  @override
  set _malwareBlockerContent(bool value) {
    _$_malwareBlockerContentAtom.reportWrite(value, super._malwareBlockerContent, () {
      super._malwareBlockerContent = value;
    });
  }

  late final _$_notSafeContentBlockerAtom =
      Atom(name: '_DNSStore._notSafeContentBlocker', context: context);

  bool get notSafeContentBlocker {
    _$_notSafeContentBlockerAtom.reportRead();
    return super._notSafeContentBlocker;
  }

  @override
  bool get _notSafeContentBlocker => notSafeContentBlocker;

  @override
  set _notSafeContentBlocker(bool value) {
    _$_notSafeContentBlockerAtom.reportWrite(value, super._notSafeContentBlocker, () {
      super._notSafeContentBlocker = value;
    });
  }

  late final _$malwareBlockerFutureAtom =
      Atom(name: '_DNSStore.malwareBlockerFuture', context: context);

  @override
  ObservableFuture<bool> get malwareBlockerFuture {
    _$malwareBlockerFutureAtom.reportRead();
    return super.malwareBlockerFuture;
  }

  bool _malwareBlockerFutureIsInitialized = false;

  @override
  set malwareBlockerFuture(ObservableFuture<bool> value) {
    _$malwareBlockerFutureAtom.reportWrite(
        value, _malwareBlockerFutureIsInitialized ? super.malwareBlockerFuture : null, () {
      super.malwareBlockerFuture = value;
      _malwareBlockerFutureIsInitialized = true;
    });
  }

  late final _$notSafeContentBlockerFutureAtom =
      Atom(name: '_DNSStore.notSafeContentBlockerFuture', context: context);

  @override
  ObservableFuture<bool> get notSafeContentBlockerFuture {
    _$notSafeContentBlockerFutureAtom.reportRead();
    return super.notSafeContentBlockerFuture;
  }

  bool _notSafeContentBlockerFutureIsInitialized = false;

  @override
  set notSafeContentBlockerFuture(ObservableFuture<bool> value) {
    _$notSafeContentBlockerFutureAtom.reportWrite(
        value, _notSafeContentBlockerFutureIsInitialized ? super.notSafeContentBlockerFuture : null,
        () {
      super.notSafeContentBlockerFuture = value;
      _notSafeContentBlockerFutureIsInitialized = true;
    });
  }

  late final _$_getAndSetMalwareBlockerContentAsyncAction =
      AsyncAction('_DNSStore._getAndSetMalwareBlockerContent', context: context);

  @override
  Future<bool> _getAndSetMalwareBlockerContent() {
    return _$_getAndSetMalwareBlockerContentAsyncAction
        .run(() => super._getAndSetMalwareBlockerContent());
  }

  late final _$_getAndSetNotSafeContentBlockerAsyncAction =
      AsyncAction('_DNSStore._getAndSetNotSafeContentBlocker', context: context);

  @override
  Future<bool> _getAndSetNotSafeContentBlocker() {
    return _$_getAndSetNotSafeContentBlockerAsyncAction
        .run(() => super._getAndSetNotSafeContentBlocker());
  }

  late final _$toggleMalwareBlockerAsyncAction =
      AsyncAction('_DNSStore.toggleMalwareBlocker', context: context);

  @override
  Future<void> toggleMalwareBlocker() {
    return _$toggleMalwareBlockerAsyncAction.run(() => super.toggleMalwareBlocker());
  }

  late final _$toggleNotSafeContentBlockerAsyncAction =
      AsyncAction('_DNSStore.toggleNotSafeContentBlocker', context: context);

  @override
  Future<void> toggleNotSafeContentBlocker() {
    return _$toggleNotSafeContentBlockerAsyncAction.run(() => super.toggleNotSafeContentBlocker());
  }

  late final _$_DNSStoreActionController = ActionController(name: '_DNSStore', context: context);

  @override
  Future<bool> getMalwareBlockerContent() {
    final _$actionInfo =
        _$_DNSStoreActionController.startAction(name: '_DNSStore.getMalwareBlockerContent');
    try {
      return super.getMalwareBlockerContent();
    } finally {
      _$_DNSStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> getNotSafeContentBlocker() {
    final _$actionInfo =
        _$_DNSStoreActionController.startAction(name: '_DNSStore.getNotSafeContentBlocker');
    try {
      return super.getNotSafeContentBlocker();
    } finally {
      _$_DNSStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
malwareBlockerFuture: ${malwareBlockerFuture},
notSafeContentBlockerFuture: ${notSafeContentBlockerFuture},
dnsAddress: ${dnsAddress}
    ''';
  }
}
