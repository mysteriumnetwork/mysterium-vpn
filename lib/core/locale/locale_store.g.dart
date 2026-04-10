// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocaleStore on _LocaleStore, Store {
  late final _$_currentLocaleAtom = Atom(
    name: '_LocaleStore._currentLocale',
    context: context,
  );

  Locale get currentLocale {
    _$_currentLocaleAtom.reportRead();
    return super._currentLocale;
  }

  @override
  Locale get _currentLocale => currentLocale;

  @override
  set _currentLocale(Locale value) {
    _$_currentLocaleAtom.reportWrite(value, super._currentLocale, () {
      super._currentLocale = value;
    });
  }

  late final _$setLocaleAsyncAction = AsyncAction(
    '_LocaleStore.setLocale',
    context: context,
  );

  @override
  Future<void> setLocale(Locale locale) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(locale));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
