// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_testing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ABTestingStore on ABTestingStoreBase, Store {
  Computed<Map<String, dynamic>>? _$configComputed;

  @override
  Map<String, dynamic> get config => (_$configComputed ??=
          Computed<Map<String, dynamic>>(() => super.config, name: 'ABTestingStoreBase.config'))
      .value;
  Computed<String>? _$subscriptionFlowVariantComputed;

  @override
  String get subscriptionFlowVariant =>
      (_$subscriptionFlowVariantComputed ??= Computed<String>(() => super.subscriptionFlowVariant,
              name: 'ABTestingStoreBase.subscriptionFlowVariant'))
          .value;
  Computed<String>? _$tunnelConsentTypeComputed;

  @override
  String get tunnelConsentType =>
      (_$tunnelConsentTypeComputed ??= Computed<String>(() => super.tunnelConsentType,
              name: 'ABTestingStoreBase.tunnelConsentType'))
          .value;
  Computed<String>? _$bannerDisplayVariantComputed;

  @override
  String get bannerDisplayVariant =>
      (_$bannerDisplayVariantComputed ??= Computed<String>(() => super.bannerDisplayVariant,
              name: 'ABTestingStoreBase.bannerDisplayVariant'))
          .value;

  late final _$configFutureAtom = Atom(name: 'ABTestingStoreBase.configFuture', context: context);

  @override
  ObservableFuture<Map<String, dynamic>> get configFuture {
    _$configFutureAtom.reportRead();
    return super.configFuture;
  }

  bool _configFutureIsInitialized = false;

  @override
  set configFuture(ObservableFuture<Map<String, dynamic>> value) {
    _$configFutureAtom.reportWrite(value, _configFutureIsInitialized ? super.configFuture : null,
        () {
      super.configFuture = value;
      _configFutureIsInitialized = true;
    });
  }

  late final _$_initAsyncAction = AsyncAction('ABTestingStoreBase._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  @override
  String toString() {
    return '''
configFuture: ${configFuture},
config: ${config},
subscriptionFlowVariant: ${subscriptionFlowVariant},
tunnelConsentType: ${tunnelConsentType},
bannerDisplayVariant: ${bannerDisplayVariant}
    ''';
  }
}
