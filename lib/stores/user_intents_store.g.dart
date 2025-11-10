// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_intents_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserIntentsStore on _UserIntentsStore, Store {
  Computed<Set<UserIntent>>? _$userIntentsComputed;

  @override
  Set<UserIntent> get userIntents => (_$userIntentsComputed ??=
          Computed<Set<UserIntent>>(() => super.userIntents, name: '_UserIntentsStore.userIntents'))
      .value;
  Computed<Set<UserIntent>>? _$intentsComputed;

  @override
  Set<UserIntent> get intents => (_$intentsComputed ??=
          Computed<Set<UserIntent>>(() => super.intents, name: '_UserIntentsStore.intents'))
      .value;

  late final _$userIntentAtom = Atom(name: '_UserIntentsStore.userIntent', context: context);

  @override
  UserIntent? get userIntent {
    _$userIntentAtom.reportRead();
    return super.userIntent;
  }

  @override
  set userIntent(UserIntent? value) {
    _$userIntentAtom.reportWrite(value, super.userIntent, () {
      super.userIntent = value;
    });
  }

  late final _$_apiIntentsFutureAtom =
      Atom(name: '_UserIntentsStore._apiIntentsFuture', context: context);

  ObservableFuture<Set<UserIntent>> get apiIntentsFuture {
    _$_apiIntentsFutureAtom.reportRead();
    return super._apiIntentsFuture;
  }

  @override
  ObservableFuture<Set<UserIntent>> get _apiIntentsFuture => apiIntentsFuture;

  bool __apiIntentsFutureIsInitialized = false;

  @override
  set _apiIntentsFuture(ObservableFuture<Set<UserIntent>> value) {
    _$_apiIntentsFutureAtom
        .reportWrite(value, __apiIntentsFutureIsInitialized ? super._apiIntentsFuture : null, () {
      super._apiIntentsFuture = value;
      __apiIntentsFutureIsInitialized = true;
    });
  }

  late final _$_localIntentsFutureAtom =
      Atom(name: '_UserIntentsStore._localIntentsFuture', context: context);

  ObservableFuture<Set<UserIntent>> get localIntentsFuture {
    _$_localIntentsFutureAtom.reportRead();
    return super._localIntentsFuture;
  }

  @override
  ObservableFuture<Set<UserIntent>> get _localIntentsFuture => localIntentsFuture;

  bool __localIntentsFutureIsInitialized = false;

  @override
  set _localIntentsFuture(ObservableFuture<Set<UserIntent>> value) {
    _$_localIntentsFutureAtom.reportWrite(
        value, __localIntentsFutureIsInitialized ? super._localIntentsFuture : null, () {
      super._localIntentsFuture = value;
      __localIntentsFutureIsInitialized = true;
    });
  }

  late final _$_intentsFutureAtom =
      Atom(name: '_UserIntentsStore._intentsFuture', context: context);

  ObservableFuture<Set<UserIntent>> get intentsFuture {
    _$_intentsFutureAtom.reportRead();
    return super._intentsFuture;
  }

  @override
  ObservableFuture<Set<UserIntent>> get _intentsFuture => intentsFuture;

  bool __intentsFutureIsInitialized = false;

  @override
  set _intentsFuture(ObservableFuture<Set<UserIntent>> value) {
    _$_intentsFutureAtom
        .reportWrite(value, __intentsFutureIsInitialized ? super._intentsFuture : null, () {
      super._intentsFuture = value;
      __intentsFutureIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
userIntent: ${userIntent},
userIntents: ${userIntents},
intents: ${intents}
    ''';
  }
}
