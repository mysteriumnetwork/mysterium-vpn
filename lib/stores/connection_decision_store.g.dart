// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_decision_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConnectionDecisionStore on _ConnectionDecisionStore, Store {
  Computed<VPNLocation?>? _$potentialLocationComputed;

  @override
  VPNLocation? get potentialLocation =>
      (_$potentialLocationComputed ??= Computed<VPNLocation?>(() => super.potentialLocation,
              name: '_ConnectionDecisionStore.potentialLocation'))
          .value;

  @override
  String toString() {
    return '''
potentialLocation: ${potentialLocation}
    ''';
  }
}
