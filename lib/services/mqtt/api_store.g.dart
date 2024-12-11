// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ApiStore on _ApiStore, Store {
  late final _$_healthcheckAtom = Atom(name: '_ApiStore._healthcheck', context: context);

  HealthcheckResponse? get healthcheck {
    _$_healthcheckAtom.reportRead();
    return super._healthcheck;
  }

  @override
  HealthcheckResponse? get _healthcheck => healthcheck;

  @override
  set _healthcheck(HealthcheckResponse? value) {
    _$_healthcheckAtom.reportWrite(value, super._healthcheck, () {
      super._healthcheck = value;
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
  String toString() {
    return '''

    ''';
  }
}
