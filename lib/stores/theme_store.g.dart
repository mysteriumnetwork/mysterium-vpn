// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeStore on _ThemeStore, Store {
  Computed<ThemeData>? _$currentThemeComputed;

  @override
  ThemeData get currentTheme => (_$currentThemeComputed ??=
          Computed<ThemeData>(() => super.currentTheme, name: '_ThemeStore.currentTheme'))
      .value;

  late final _$themeTypeAtom = Atom(name: '_ThemeStore.themeType', context: context);

  @override
  ThemeType get themeType {
    _$themeTypeAtom.reportRead();
    return super.themeType;
  }

  @override
  set themeType(ThemeType value) {
    _$themeTypeAtom.reportWrite(value, super.themeType, () {
      super.themeType = value;
    });
  }

  late final _$setThemeTypeAsyncAction = AsyncAction('_ThemeStore.setThemeType', context: context);

  @override
  Future<void> setThemeType(ThemeType type) {
    return _$setThemeTypeAsyncAction.run(() => super.setThemeType(type));
  }

  late final _$switchThemeAsyncAction = AsyncAction('_ThemeStore.switchTheme', context: context);

  @override
  Future<void> switchTheme() {
    return _$switchThemeAsyncAction.run(() => super.switchTheme());
  }

  @override
  String toString() {
    return '''
themeType: ${themeType},
currentTheme: ${currentTheme}
    ''';
  }
}
