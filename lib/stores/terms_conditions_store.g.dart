// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_conditions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TermsConditionsStore on _TermsConditionsStore, Store {
  late final _$_failureAtom = Atom(name: '_TermsConditionsStore._failure', context: context);

  TermsConditionsFailureType? get failure {
    _$_failureAtom.reportRead();
    return super._failure;
  }

  @override
  TermsConditionsFailureType? get _failure => failure;

  @override
  set _failure(TermsConditionsFailureType? value) {
    _$_failureAtom.reportWrite(value, super._failure, () {
      super._failure = value;
    });
  }

  late final _$_isLoadingAtom = Atom(name: '_TermsConditionsStore._isLoading', context: context);

  bool get isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  bool get _isLoading => isLoading;

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_isAcceptingAtom = Atom(
    name: '_TermsConditionsStore._isAccepting',
    context: context,
  );

  bool get isAccepting {
    _$_isAcceptingAtom.reportRead();
    return super._isAccepting;
  }

  @override
  bool get _isAccepting => isAccepting;

  @override
  set _isAccepting(bool value) {
    _$_isAcceptingAtom.reportWrite(value, super._isAccepting, () {
      super._isAccepting = value;
    });
  }

  late final _$_latestTermsConditionsAtom = Atom(
    name: '_TermsConditionsStore._latestTermsConditions',
    context: context,
  );

  TermsAndConditions? get latestTermsConditions {
    _$_latestTermsConditionsAtom.reportRead();
    return super._latestTermsConditions;
  }

  @override
  TermsAndConditions? get _latestTermsConditions => latestTermsConditions;

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

  bool get requiresTermsConditionsApproval {
    _$_requiresTermsConditionsApprovalAtom.reportRead();
    return super._requiresTermsConditionsApproval;
  }

  @override
  bool get _requiresTermsConditionsApproval => requiresTermsConditionsApproval;

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

    ''';
  }
}
