// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'udp_blocked_suggestion_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UdpBlockedSuggestionStore on _UdpBlockedSuggestionStore, Store {
  Computed<bool>? _$shouldRunCheckComputed;

  @override
  bool get shouldRunCheck => (_$shouldRunCheckComputed ??= Computed<bool>(
    () => super.shouldRunCheck,
    name: '_UdpBlockedSuggestionStore.shouldRunCheck',
  )).value;
  Computed<bool>? _$isOpenVpnAvailableComputed;

  @override
  bool get isOpenVpnAvailable => (_$isOpenVpnAvailableComputed ??= Computed<bool>(
    () => super.isOpenVpnAvailable,
    name: '_UdpBlockedSuggestionStore.isOpenVpnAvailable',
  )).value;

  late final _$suggestionEpochAtom = Atom(
    name: '_UdpBlockedSuggestionStore.suggestionEpoch',
    context: context,
  );

  @override
  int get suggestionEpoch {
    _$suggestionEpochAtom.reportRead();
    return super.suggestionEpoch;
  }

  @override
  set suggestionEpoch(int value) {
    _$suggestionEpochAtom.reportWrite(value, super.suggestionEpoch, () {
      super.suggestionEpoch = value;
    });
  }

  late final _$_UdpBlockedSuggestionStoreActionController = ActionController(
    name: '_UdpBlockedSuggestionStore',
    context: context,
  );

  @override
  void onUdpBlocked(String error) {
    final _$actionInfo = _$_UdpBlockedSuggestionStoreActionController.startAction(
      name: '_UdpBlockedSuggestionStore.onUdpBlocked',
    );
    try {
      return super.onUdpBlocked(error);
    } finally {
      _$_UdpBlockedSuggestionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
suggestionEpoch: ${suggestionEpoch},
shouldRunCheck: ${shouldRunCheck},
isOpenVpnAvailable: ${isOpenVpnAvailable}
    ''';
  }
}
