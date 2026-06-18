// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_refresh_exhaustion_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IpRefreshExhaustionStore on _IpRefreshExhaustionStore, Store {
  late final _$exhaustionNoticeAtom = Atom(
    name: '_IpRefreshExhaustionStore.exhaustionNotice',
    context: context,
  );

  @override
  VPNLocation? get exhaustionNotice {
    _$exhaustionNoticeAtom.reportRead();
    return super.exhaustionNotice;
  }

  @override
  set exhaustionNotice(VPNLocation? value) {
    _$exhaustionNoticeAtom.reportWrite(value, super.exhaustionNotice, () {
      super.exhaustionNotice = value;
    });
  }

  late final _$_IpRefreshExhaustionStoreActionController = ActionController(
    name: '_IpRefreshExhaustionStore',
    context: context,
  );

  @override
  void onConnected(VPNLocation location) {
    final _$actionInfo = _$_IpRefreshExhaustionStoreActionController.startAction(
      name: '_IpRefreshExhaustionStore.onConnected',
    );
    try {
      return super.onConnected(location);
    } finally {
      _$_IpRefreshExhaustionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onDisconnected() {
    final _$actionInfo = _$_IpRefreshExhaustionStoreActionController.startAction(
      name: '_IpRefreshExhaustionStore.onDisconnected',
    );
    try {
      return super.onDisconnected();
    } finally {
      _$_IpRefreshExhaustionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void registerRefresh(int poolCount) {
    final _$actionInfo = _$_IpRefreshExhaustionStoreActionController.startAction(
      name: '_IpRefreshExhaustionStore.registerRefresh',
    );
    try {
      return super.registerRefresh(poolCount);
    } finally {
      _$_IpRefreshExhaustionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNotice() {
    final _$actionInfo = _$_IpRefreshExhaustionStoreActionController.startAction(
      name: '_IpRefreshExhaustionStore.clearNotice',
    );
    try {
      return super.clearNotice();
    } finally {
      _$_IpRefreshExhaustionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
exhaustionNotice: ${exhaustionNotice}
    ''';
  }
}
