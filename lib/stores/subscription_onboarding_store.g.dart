// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_onboarding_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionOnboardingStore on _SubscriptionOnboardingStore, Store {
  Computed<bool>? _$startTourComputed;

  @override
  bool get startTour => (_$startTourComputed ??= Computed<bool>(
    () => super.startTour,
    name: '_SubscriptionOnboardingStore.startTour',
  )).value;

  late final _$_startTourAtom = Atom(
    name: '_SubscriptionOnboardingStore._startTour',
    context: context,
  );

  @override
  bool get _startTour {
    _$_startTourAtom.reportRead();
    return super._startTour;
  }

  @override
  set _startTour(bool value) {
    _$_startTourAtom.reportWrite(value, super._startTour, () {
      super._startTour = value;
    });
  }

  late final _$_SubscriptionOnboardingStoreActionController = ActionController(
    name: '_SubscriptionOnboardingStore',
    context: context,
  );

  @override
  void showSubscriptionOnboarding() {
    final _$actionInfo = _$_SubscriptionOnboardingStoreActionController.startAction(
      name: '_SubscriptionOnboardingStore.showSubscriptionOnboarding',
    );
    try {
      return super.showSubscriptionOnboarding();
    } finally {
      _$_SubscriptionOnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void didShowSubscriptionOnboarding() {
    final _$actionInfo = _$_SubscriptionOnboardingStoreActionController.startAction(
      name: '_SubscriptionOnboardingStore.didShowSubscriptionOnboarding',
    );
    try {
      return super.didShowSubscriptionOnboarding();
    } finally {
      _$_SubscriptionOnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
startTour: ${startTour}
    ''';
  }
}
