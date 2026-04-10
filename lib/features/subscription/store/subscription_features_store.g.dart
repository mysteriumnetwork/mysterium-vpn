// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_features_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionFeaturesStore on _SubscriptionFeaturesStore, Store {
  Computed<SubscriptionConfigResponsePlansInnerMetadata?>? _$metadataComputed;

  @override
  SubscriptionConfigResponsePlansInnerMetadata? get metadata =>
      (_$metadataComputed ??=
              Computed<SubscriptionConfigResponsePlansInnerMetadata?>(
                () => super.metadata,
                name: '_SubscriptionFeaturesStore.metadata',
              ))
          .value;
  Computed<bool>? _$residentialIPsAllowedComputed;

  @override
  bool get residentialIPsAllowed =>
      (_$residentialIPsAllowedComputed ??= Computed<bool>(
        () => super.residentialIPsAllowed,
        name: '_SubscriptionFeaturesStore.residentialIPsAllowed',
      )).value;
  Computed<bool>? _$malwareBlockingAllowedComputed;

  @override
  bool get malwareBlockingAllowed =>
      (_$malwareBlockingAllowedComputed ??= Computed<bool>(
        () => super.malwareBlockingAllowed,
        name: '_SubscriptionFeaturesStore.malwareBlockingAllowed',
      )).value;

  @override
  String toString() {
    return '''
metadata: ${metadata},
residentialIPsAllowed: ${residentialIPsAllowed},
malwareBlockingAllowed: ${malwareBlockingAllowed}
    ''';
  }
}
