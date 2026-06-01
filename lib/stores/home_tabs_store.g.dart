// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tabs_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeTabsStore on _HomeTabsStore, Store {
  late final _$selectedAtom = Atom(
    name: '_HomeTabsStore.selected',
    context: context,
  );

  @override
  HomeTab get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(HomeTab value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  late final _$pendingLocationsSearchFocusAtom = Atom(
    name: '_HomeTabsStore.pendingLocationsSearchFocus',
    context: context,
  );

  @override
  bool get pendingLocationsSearchFocus {
    _$pendingLocationsSearchFocusAtom.reportRead();
    return super.pendingLocationsSearchFocus;
  }

  @override
  set pendingLocationsSearchFocus(bool value) {
    _$pendingLocationsSearchFocusAtom.reportWrite(
      value,
      super.pendingLocationsSearchFocus,
      () {
        super.pendingLocationsSearchFocus = value;
      },
    );
  }

  late final _$settingsSubPageAtom = Atom(
    name: '_HomeTabsStore.settingsSubPage',
    context: context,
  );

  @override
  SettingCategory? get settingsSubPage {
    _$settingsSubPageAtom.reportRead();
    return super.settingsSubPage;
  }

  @override
  set settingsSubPage(SettingCategory? value) {
    _$settingsSubPageAtom.reportWrite(value, super.settingsSubPage, () {
      super.settingsSubPage = value;
    });
  }

  late final _$_HomeTabsStoreActionController = ActionController(
    name: '_HomeTabsStore',
    context: context,
  );

  @override
  bool trySelect(HomeTab tab) {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore.trySelect',
    );
    try {
      return super.trySelect(tab);
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _resetSessionState() {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore._resetSessionState',
    );
    try {
      return super._resetSessionState();
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLocationsSearch() {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore.openLocationsSearch',
    );
    try {
      return super.openLocationsSearch();
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void consumePendingLocationsSearchFocus() {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore.consumePendingLocationsSearchFocus',
    );
    try {
      return super.consumePendingLocationsSearchFocus();
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openSettingsSubPage(SettingCategory category) {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore.openSettingsSubPage',
    );
    try {
      return super.openSettingsSubPage(category);
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeSettingsSubPage() {
    final _$actionInfo = _$_HomeTabsStoreActionController.startAction(
      name: '_HomeTabsStore.closeSettingsSubPage',
    );
    try {
      return super.closeSettingsSubPage();
    } finally {
      _$_HomeTabsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selected: ${selected},
pendingLocationsSearchFocus: ${pendingLocationsSearchFocus},
settingsSubPage: ${settingsSubPage}
    ''';
  }
}
