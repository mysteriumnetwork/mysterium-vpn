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
      (_$subscriptionFlowVariantComputed ??= Computed<String>(
        () => super.subscriptionFlowVariant,
        name: 'ABTestingStoreBase.subscriptionFlowVariant',
      )).value;
  Computed<String>? _$tunnelConsentTypeComputed;

  @override
  String get tunnelConsentType =>
      (_$tunnelConsentTypeComputed ??= Computed<String>(
        () => super.tunnelConsentType,
        name: 'ABTestingStoreBase.tunnelConsentType',
      )).value;

  @override
  String toString() {
    return '''
subscriptionFlowVariant: ${subscriptionFlowVariant},
tunnelConsentType: ${tunnelConsentType}
    ''';
  }
}
