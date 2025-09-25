// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_ip_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RefreshIPStore on _RefreshIPStore, Store {
  Computed<bool>? _$refreshIPConnectionComputed;

  @override
  bool get refreshIPConnection =>
      (_$refreshIPConnectionComputed ??= Computed<bool>(() => super.refreshIPConnection,
              name: '_RefreshIPStore.refreshIPConnection'))
          .value;

  late final _$refreshIPFutureAtom =
      Atom(name: '_RefreshIPStore.refreshIPFuture', context: context);

  @override
  ObservableFuture<bool> get refreshIPFuture {
    _$refreshIPFutureAtom.reportRead();
    return super.refreshIPFuture;
  }

  @override
  set refreshIPFuture(ObservableFuture<bool> value) {
    _$refreshIPFutureAtom.reportWrite(value, super.refreshIPFuture, () {
      super.refreshIPFuture = value;
    });
  }

  late final _$_getAndSetRefreshIPConnectionAsyncAction =
      AsyncAction('_RefreshIPStore._getAndSetRefreshIPConnection', context: context);

  @override
  Future<bool> _getAndSetRefreshIPConnection() {
    return _$_getAndSetRefreshIPConnectionAsyncAction
        .run(() => super._getAndSetRefreshIPConnection());
  }

  late final _$toggleRefreshIPWhenConnectingAsyncAction =
      AsyncAction('_RefreshIPStore.toggleRefreshIPWhenConnecting', context: context);

  @override
  Future<void> toggleRefreshIPWhenConnecting() {
    return _$toggleRefreshIPWhenConnectingAsyncAction
        .run(() => super.toggleRefreshIPWhenConnecting());
  }

  late final _$_RefreshIPStoreActionController =
      ActionController(name: '_RefreshIPStore', context: context);

  @override
  Future<bool> getRefreshIPConnection() {
    final _$actionInfo = _$_RefreshIPStoreActionController.startAction(
        name: '_RefreshIPStore.getRefreshIPConnection');
    try {
      return super.getRefreshIPConnection();
    } finally {
      _$_RefreshIPStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
refreshIPFuture: ${refreshIPFuture},
refreshIPConnection: ${refreshIPConnection}
    ''';
  }
}
