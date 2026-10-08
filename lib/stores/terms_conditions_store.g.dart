// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_conditions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TermsConditionsStore on _TermsConditionsStore, Store {
  Computed<TermsConditionsFailureType?>? _$failureComputed;

  @override
  TermsConditionsFailureType? get failure =>
      (_$failureComputed ??= Computed<TermsConditionsFailureType?>(
        () => super.failure,
        name: '_TermsConditionsStore.failure',
      )).value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_TermsConditionsStore.isLoading',
  )).value;
  Computed<TermsAndConditions?>? _$latestTermsConditionsComputed;

  @override
  TermsAndConditions? get latestTermsConditions =>
      (_$latestTermsConditionsComputed ??= Computed<TermsAndConditions?>(
        () => super.latestTermsConditions,
        name: '_TermsConditionsStore.latestTermsConditions',
      )).value;
  Computed<bool>? _$requiresTermsConditionsApprovalComputed;

  @override
  bool get requiresTermsConditionsApproval =>
      (_$requiresTermsConditionsApprovalComputed ??= Computed<bool>(
        () => super.requiresTermsConditionsApproval,
        name: '_TermsConditionsStore.requiresTermsConditionsApproval',
      )).value;

  late final _$_failureAtom = Atom(name: '_TermsConditionsStore._failure', context: context);

  @override
  TermsConditionsFailureType? get _failure {
    _$_failureAtom.reportRead();
    return super._failure;
  }

  @override
  set _failure(TermsConditionsFailureType? value) {
    _$_failureAtom.reportWrite(value, super._failure, () {
      super._failure = value;
    });
  }

  late final _$_isLoadingAtom = Atom(name: '_TermsConditionsStore._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_latestTermsConditionsAtom = Atom(
    name: '_TermsConditionsStore._latestTermsConditions',
    context: context,
  );

  @override
  TermsAndConditions? get _latestTermsConditions {
    _$_latestTermsConditionsAtom.reportRead();
    return super._latestTermsConditions;
  }

  @override
  set _latestTermsConditions(TermsAndConditions? value) {
    _$_latestTermsConditionsAtom.reportWrite(value, super._latestTermsConditions, () {
      super._latestTermsConditions = value;
    });
  }

  late final _$_requiresTermsConditionsApprovalAtom = Atom(
    name: '_TermsConditionsStore._requiresTermsConditionsApproval',
    context: context,
  );

  @override
  bool get _requiresTermsConditionsApproval {
    _$_requiresTermsConditionsApprovalAtom.reportRead();
    return super._requiresTermsConditionsApproval;
  }

  @override
  set _requiresTermsConditionsApproval(bool value) {
    _$_requiresTermsConditionsApprovalAtom.reportWrite(
      value,
      super._requiresTermsConditionsApproval,
      () {
        super._requiresTermsConditionsApproval = value;
      },
    );
  }

  late final _$checkForUpdatedTermsConditionsAsyncAction = AsyncAction(
    '_TermsConditionsStore.checkForUpdatedTermsConditions',
    context: context,
  );

  @override
  Future<void> checkForUpdatedTermsConditions() {
    return _$checkForUpdatedTermsConditionsAsyncAction.run(
      () => super.checkForUpdatedTermsConditions(),
    );
  }

  late final _$acceptTermsConditionsAsyncAction = AsyncAction(
    '_TermsConditionsStore.acceptTermsConditions',
    context: context,
  );

  @override
  Future<void> acceptTermsConditions() {
    return _$acceptTermsConditionsAsyncAction.run(() => super.acceptTermsConditions());
  }

  @override
  String toString() {
    return '''
failure: ${failure},
isLoading: ${isLoading},
latestTermsConditions: ${latestTermsConditions},
requiresTermsConditionsApproval: ${requiresTermsConditionsApproval}
    ''';
  }
}
