// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MqttStore on _MqttStore, Store {
  late final _$lastHealthcheckAtom = Atom(name: '_MqttStore.lastHealthcheck', context: context);

  @override
  HealthcheckMessage? get lastHealthcheck {
    _$lastHealthcheckAtom.reportRead();
    return super.lastHealthcheck;
  }

  @override
  set lastHealthcheck(HealthcheckMessage? value) {
    _$lastHealthcheckAtom.reportWrite(value, super.lastHealthcheck, () {
      super.lastHealthcheck = value;
    });
  }

  @override
  String toString() {
    return '''
lastHealthcheck: ${lastHealthcheck}
    ''';
  }
}
