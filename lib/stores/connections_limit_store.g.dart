// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_limit_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConnectionsLimitStore on _ConnectionsLimitStore, Store {
  late final _$connectionLimitReachedAtom = Atom(
    name: '_ConnectionsLimitStore.connectionLimitReached',
    context: context,
  );

  @override
  bool get connectionLimitReached {
    _$connectionLimitReachedAtom.reportRead();
    return super.connectionLimitReached;
  }

  @override
  set connectionLimitReached(bool value) {
    _$connectionLimitReachedAtom.reportWrite(
      value,
      super.connectionLimitReached,
      () {
        super.connectionLimitReached = value;
      },
    );
  }

  @override
  String toString() {
    return '''
connectionLimitReached: ${connectionLimitReached}
    ''';
  }
}
