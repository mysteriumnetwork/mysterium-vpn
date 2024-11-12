// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_testing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ABTestingStore on ABTestingStoreBase, Store {
  Computed<String>? _$subscriptionFlowVariantComputed;

  @override
  String get subscriptionFlowVariant =>
      (_$subscriptionFlowVariantComputed ??= Computed<String>(() => super.subscriptionFlowVariant,
              name: 'ABTestingStoreBase.subscriptionFlowVariant'))
          .value;

  late final _$configAtom = Atom(name: 'ABTestingStoreBase.config', context: context);

  @override
  ObservableMap<String, dynamic> get config {
    _$configAtom.reportRead();
    return super.config;
  }

  @override
  set config(ObservableMap<String, dynamic> value) {
    _$configAtom.reportWrite(value, super.config, () {
      super.config = value;
    });
  }

  late final _$setDefaultUserAsyncAction =
      AsyncAction('ABTestingStoreBase.setDefaultUser', context: context);

  @override
  Future<void> setDefaultUser({required String email, required String userId}) {
    return _$setDefaultUserAsyncAction
        .run(() => super.setDefaultUser(email: email, userId: userId));
  }

  late final _$getAllABTestingValuesAsyncAction =
      AsyncAction('ABTestingStoreBase.getAllABTestingValues', context: context);

  @override
  Future<void> getAllABTestingValues() {
    return _$getAllABTestingValuesAsyncAction.run(() => super.getAllABTestingValues());
  }

  late final _$refreshABTestingValuesAsyncAction =
      AsyncAction('ABTestingStoreBase.refreshABTestingValues', context: context);

  @override
  Future<void> refreshABTestingValues() {
    return _$refreshABTestingValuesAsyncAction.run(() => super.refreshABTestingValues());
  }

  @override
  String toString() {
    return '''
config: ${config},
subscriptionFlowVariant: ${subscriptionFlowVariant}
    ''';
  }
}
