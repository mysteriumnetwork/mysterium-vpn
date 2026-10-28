// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tunnel_health_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TunnelHealthStore on _TunnelHealthStore, Store {
  Computed<bool>? _$canRefreshIpComputed;

  @override
  bool get canRefreshIp => (_$canRefreshIpComputed ??= Computed<bool>(
    () => super.canRefreshIp,
    name: '_TunnelHealthStore.canRefreshIp',
  )).value;

  late final _$degradationEpochAtom = Atom(
    name: '_TunnelHealthStore.degradationEpoch',
    context: context,
  );

  @override
  int get degradationEpoch {
    _$degradationEpochAtom.reportRead();
    return super.degradationEpoch;
  }

  @override
  set degradationEpoch(int value) {
    _$degradationEpochAtom.reportWrite(value, super.degradationEpoch, () {
      super.degradationEpoch = value;
    });
  }

  late final _$noNetworkEpochAtom = Atom(
    name: '_TunnelHealthStore.noNetworkEpoch',
    context: context,
  );

  @override
  int get noNetworkEpoch {
    _$noNetworkEpochAtom.reportRead();
    return super.noNetworkEpoch;
  }

  @override
  set noNetworkEpoch(int value) {
    _$noNetworkEpochAtom.reportWrite(value, super.noNetworkEpoch, () {
      super.noNetworkEpoch = value;
    });
  }

  late final _$_TunnelHealthStoreActionController = ActionController(
    name: '_TunnelHealthStore',
    context: context,
  );

  @override
  void _onNoNetwork({required bool controlReachable}) {
    final _$actionInfo = _$_TunnelHealthStoreActionController.startAction(
      name: '_TunnelHealthStore._onNoNetwork',
    );
    try {
      return super._onNoNetwork(controlReachable: controlReachable);
    } finally {
      _$_TunnelHealthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onDegraded(
    ({
      DateTime? handshake,
      int? rxDelta,
      TunnelHealthSample sample,
      int? txDelta,
      TunnelHealthVerdict verdict,
    })
    evaluation,
  ) {
    final _$actionInfo = _$_TunnelHealthStoreActionController.startAction(
      name: '_TunnelHealthStore._onDegraded',
    );
    try {
      return super._onDegraded(evaluation);
    } finally {
      _$_TunnelHealthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
degradationEpoch: ${degradationEpoch},
noNetworkEpoch: ${noNetworkEpoch},
canRefreshIp: ${canRefreshIp}
    ''';
  }
}
