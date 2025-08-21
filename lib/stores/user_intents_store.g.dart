// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_intents_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserIntentsStore on _UserIntentsStore, Store {
  Computed<Set<UserIntent>>? _$intentsComputed;

  @override
  Set<UserIntent> get intents => (_$intentsComputed ??=
          Computed<Set<UserIntent>>(() => super.intents, name: '_UserIntentsStore.intents'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_UserIntentsStore.isLoading'))
      .value;

  late final _$_apiIntentsStreamAtom =
      Atom(name: '_UserIntentsStore._apiIntentsStream', context: context);

  ObservableStream<Set<UserIntent>> get apiIntentsStream {
    _$_apiIntentsStreamAtom.reportRead();
    return super._apiIntentsStream;
  }

  @override
  ObservableStream<Set<UserIntent>> get _apiIntentsStream => apiIntentsStream;

  bool __apiIntentsStreamIsInitialized = false;

  @override
  set _apiIntentsStream(ObservableStream<Set<UserIntent>> value) {
    _$_apiIntentsStreamAtom
        .reportWrite(value, __apiIntentsStreamIsInitialized ? super._apiIntentsStream : null, () {
      super._apiIntentsStream = value;
      __apiIntentsStreamIsInitialized = true;
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

  @override
  String toString() {
    return '''
intents: ${intents},
isLoading: ${isLoading}
    ''';
  }
}
