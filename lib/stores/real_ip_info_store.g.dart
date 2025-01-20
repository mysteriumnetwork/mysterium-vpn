// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_ip_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RealIPInfoStore on _RealIPInfoStore, Store {
  Computed<IPInfo?>? _$infoComputed;

  @override
  IPInfo? get info =>
      (_$infoComputed ??= Computed<IPInfo?>(() => super.info, name: '_RealIPInfoStore.info')).value;

  late final _$infoFutureAtom = Atom(name: '_RealIPInfoStore.infoFuture', context: context);

  @override
  ObservableFuture<IPInfo?> get infoFuture {
    _$infoFutureAtom.reportRead();
    return super.infoFuture;
  }

  bool _infoFutureIsInitialized = false;

  @override
  set infoFuture(ObservableFuture<IPInfo?> value) {
    _$infoFutureAtom.reportWrite(value, _infoFutureIsInitialized ? super.infoFuture : null, () {
      super.infoFuture = value;
      _infoFutureIsInitialized = true;
    });
  }

  late final _$refreshAsyncAction = AsyncAction('_RealIPInfoStore.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
infoFuture: ${infoFuture},
info: ${info}
    ''';
  }
}
