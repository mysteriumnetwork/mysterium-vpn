// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RestStore on _RestStore, Store {
  late final _$emailCommunicationApprovalFutureAtom =
      Atom(name: '_RestStore.emailCommunicationApprovalFuture', context: context);

  @override
  ObservableFuture<Approval>? get emailCommunicationApprovalFuture {
    _$emailCommunicationApprovalFutureAtom.reportRead();
    return super.emailCommunicationApprovalFuture;
  }

  @override
  set emailCommunicationApprovalFuture(ObservableFuture<Approval>? value) {
    _$emailCommunicationApprovalFutureAtom
        .reportWrite(value, super.emailCommunicationApprovalFuture, () {
      super.emailCommunicationApprovalFuture = value;
    });
  }

  late final _$setEmailCommunicationApprovalFutureAtom =
      Atom(name: '_RestStore.setEmailCommunicationApprovalFuture', context: context);

  @override
  ObservableFuture<void> get setEmailCommunicationApprovalFuture {
    _$setEmailCommunicationApprovalFutureAtom.reportRead();
    return super.setEmailCommunicationApprovalFuture;
  }

  @override
  set setEmailCommunicationApprovalFuture(ObservableFuture<void> value) {
    _$setEmailCommunicationApprovalFutureAtom
        .reportWrite(value, super.setEmailCommunicationApprovalFuture, () {
      super.setEmailCommunicationApprovalFuture = value;
    });
  }

  late final _$notificationsApprovalFutureAtom =
      Atom(name: '_RestStore.notificationsApprovalFuture', context: context);

  @override
  ObservableFuture<Approval>? get notificationsApprovalFuture {
    _$notificationsApprovalFutureAtom.reportRead();
    return super.notificationsApprovalFuture;
  }

  @override
  set notificationsApprovalFuture(ObservableFuture<Approval>? value) {
    _$notificationsApprovalFutureAtom.reportWrite(value, super.notificationsApprovalFuture, () {
      super.notificationsApprovalFuture = value;
    });
  }

  late final _$setNotificationsApprovalFutureAtom =
      Atom(name: '_RestStore.setNotificationsApprovalFuture', context: context);

  @override
  ObservableFuture<void> get setNotificationsApprovalFuture {
    _$setNotificationsApprovalFutureAtom.reportRead();
    return super.setNotificationsApprovalFuture;
  }

  @override
  set setNotificationsApprovalFuture(ObservableFuture<void> value) {
    _$setNotificationsApprovalFutureAtom.reportWrite(value, super.setNotificationsApprovalFuture,
        () {
      super.setNotificationsApprovalFuture = value;
    });
  }

  late final _$_emailCommunicationApprovalAtom =
      Atom(name: '_RestStore._emailCommunicationApproval', context: context);

  Approval get emailCommunicationApproval {
    _$_emailCommunicationApprovalAtom.reportRead();
    return super._emailCommunicationApproval;
  }

  @override
  Approval get _emailCommunicationApproval => emailCommunicationApproval;

  @override
  set _emailCommunicationApproval(Approval value) {
    _$_emailCommunicationApprovalAtom.reportWrite(value, super._emailCommunicationApproval, () {
      super._emailCommunicationApproval = value;
    });
  }

  late final _$_notificationsApprovalAtom =
      Atom(name: '_RestStore._notificationsApproval', context: context);

  Approval get notificationsApproval {
    _$_notificationsApprovalAtom.reportRead();
    return super._notificationsApproval;
  }

  @override
  Approval get _notificationsApproval => notificationsApproval;

  @override
  set _notificationsApproval(Approval value) {
    _$_notificationsApprovalAtom.reportWrite(value, super._notificationsApproval, () {
      super._notificationsApproval = value;
    });
  }

  late final _$checkEmailCommunicationApprovalAsyncAction =
      AsyncAction('_RestStore.checkEmailCommunicationApproval', context: context);

  @override
  Future<void> checkEmailCommunicationApproval() {
    return _$checkEmailCommunicationApprovalAsyncAction
        .run(() => super.checkEmailCommunicationApproval());
  }

  late final _$checkNotificationsApprovalAsyncAction =
      AsyncAction('_RestStore.checkNotificationsApproval', context: context);

  @override
  Future<void> checkNotificationsApproval() {
    return _$checkNotificationsApprovalAsyncAction.run(() => super.checkNotificationsApproval());
  }

  late final _$setEmailCommunicationApprovalAsyncAction =
      AsyncAction('_RestStore.setEmailCommunicationApproval', context: context);

  @override
  Future<void> setEmailCommunicationApproval({required bool status}) {
    return _$setEmailCommunicationApprovalAsyncAction
        .run(() => super.setEmailCommunicationApproval(status: status));
  }

  late final _$setNotificationsApprovalAsyncAction =
      AsyncAction('_RestStore.setNotificationsApproval', context: context);

  @override
  Future<void> setNotificationsApproval({required bool status}) {
    return _$setNotificationsApprovalAsyncAction
        .run(() => super.setNotificationsApproval(status: status));
  }

  @override
  String toString() {
    return '''
emailCommunicationApprovalFuture: ${emailCommunicationApprovalFuture},
setEmailCommunicationApprovalFuture: ${setEmailCommunicationApprovalFuture},
notificationsApprovalFuture: ${notificationsApprovalFuture},
setNotificationsApprovalFuture: ${setNotificationsApprovalFuture}
    ''';
  }
}
