// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_query_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsQueryStore on _LocationsQueryStore, Store {
  Computed<String>? _$searchTrimmedComputed;

  @override
  String get searchTrimmed => (_$searchTrimmedComputed ??=
          Computed<String>(() => super.searchTrimmed, name: '_LocationsQueryStore.searchTrimmed'))
      .value;

  late final _$_searchAtom = Atom(name: '_LocationsQueryStore._search', context: context);

  String get search {
    _$_searchAtom.reportRead();
    return super._search;
  }

  @override
  String get _search => search;

  bool __searchIsInitialized = false;

  @override
  set _search(String value) {
    _$_searchAtom.reportWrite(value, __searchIsInitialized ? super._search : null, () {
      super._search = value;
      __searchIsInitialized = true;
    });
  }

  late final _$_ipTypeAtom = Atom(name: '_LocationsQueryStore._ipType', context: context);

  IPType get ipType {
    _$_ipTypeAtom.reportRead();
    return super._ipType;
  }

  @override
  IPType get _ipType => ipType;

  bool __ipTypeIsInitialized = false;

  @override
  set _ipType(IPType value) {
    _$_ipTypeAtom.reportWrite(value, __ipTypeIsInitialized ? super._ipType : null, () {
      super._ipType = value;
      __ipTypeIsInitialized = true;
    });
  }

  late final _$setIPTypeAsyncAction =
      AsyncAction('_LocationsQueryStore.setIPType', context: context);

  @override
  Future<void> setIPType(IPType value) {
    return _$setIPTypeAsyncAction.run(() => super.setIPType(value));
  }

  late final _$_LocationsQueryStoreActionController =
      ActionController(name: '_LocationsQueryStore', context: context);

  @override
  void setSearch(String value, {Duration debounce = const Duration(milliseconds: 500)}) {
    final _$actionInfo =
        _$_LocationsQueryStoreActionController.startAction(name: '_LocationsQueryStore.setSearch');
    try {
      return super.setSearch(value, debounce: debounce);
    } finally {
      _$_LocationsQueryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchTrimmed: ${searchTrimmed}
    ''';
  }
}
