// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'haptics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HapticsStore on _HapticsStore, Store {
  late final _$enabledAtom = Atom(name: '_HapticsStore.enabled', context: context);

  @override
  bool get enabled {
    _$enabledAtom.reportRead();
    return super.enabled;
  }

  @override
  set enabled(bool value) {
    _$enabledAtom.reportWrite(value, super.enabled, () {
      super.enabled = value;
    });
  }

  late final _$setEnabledAsyncAction = AsyncAction('_HapticsStore.setEnabled', context: context);

  @override
  Future<void> setEnabled({required bool value}) {
    return _$setEnabledAsyncAction.run(() => super.setEnabled(value: value));
  }

  @override
  String toString() {
    return '''
enabled: ${enabled}
    ''';
  }
}
