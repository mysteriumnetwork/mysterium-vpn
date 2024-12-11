// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ApiStore on _ApiStore, Store {
  late final _$_lastHealthcheckAtom = Atom(name: '_ApiStore._lastHealthcheck', context: context);

  HealthcheckResponse? get lastHealthcheck {
    _$_lastHealthcheckAtom.reportRead();
    return super._lastHealthcheck;
  }

  @override
  HealthcheckResponse? get _lastHealthcheck => lastHealthcheck;

  @override
  set _lastHealthcheck(HealthcheckResponse? value) {
    _$_lastHealthcheckAtom.reportWrite(value, super._lastHealthcheck, () {
      super._lastHealthcheck = value;
    });
  }

  late final _$_ApiStoreActionController = ActionController(name: '_ApiStore', context: context);

  @override
  void initStore() {
    final _$actionInfo = _$_ApiStoreActionController.startAction(name: '_ApiStore.initStore');
    try {
      return super.initStore();
    } finally {
      _$_ApiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$_ApiStoreActionController.startAction(name: '_ApiStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_ApiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
