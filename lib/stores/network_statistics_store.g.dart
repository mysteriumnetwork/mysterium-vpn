// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_statistics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NetworkStatisticsStore on _NetworkStatisticsStore, Store {
  Computed<DateTime?>? _$latestHandshakeComputed;

  @override
  DateTime? get latestHandshake => (_$latestHandshakeComputed ??= Computed<DateTime?>(
    () => super.latestHandshake,
    name: '_NetworkStatisticsStore.latestHandshake',
  )).value;
  Computed<int>? _$totalDownloadComputed;

  @override
  int get totalDownload => (_$totalDownloadComputed ??= Computed<int>(
    () => super.totalDownload,
    name: '_NetworkStatisticsStore.totalDownload',
  )).value;
  Computed<int>? _$totalUploadComputed;

  @override
  int get totalUpload => (_$totalUploadComputed ??= Computed<int>(
    () => super.totalUpload,
    name: '_NetworkStatisticsStore.totalUpload',
  )).value;
  Computed<double>? _$totalDownloadInMBComputed;

  @override
  double get totalDownloadInMB => (_$totalDownloadInMBComputed ??= Computed<double>(
    () => super.totalDownloadInMB,
    name: '_NetworkStatisticsStore.totalDownloadInMB',
  )).value;
  Computed<double>? _$totalUploadInMBComputed;

  @override
  double get totalUploadInMB => (_$totalUploadInMBComputed ??= Computed<double>(
    () => super.totalUploadInMB,
    name: '_NetworkStatisticsStore.totalUploadInMB',
  )).value;

  late final _$downloadSpeedAtom = Atom(
    name: '_NetworkStatisticsStore.downloadSpeed',
    context: context,
  );

  @override
  double get downloadSpeed {
    _$downloadSpeedAtom.reportRead();
    return super.downloadSpeed;
  }

  @override
  set downloadSpeed(double value) {
    _$downloadSpeedAtom.reportWrite(value, super.downloadSpeed, () {
      super.downloadSpeed = value;
    });
  }

  late final _$uploadSpeedAtom = Atom(
    name: '_NetworkStatisticsStore.uploadSpeed',
    context: context,
  );

  @override
  double get uploadSpeed {
    _$uploadSpeedAtom.reportRead();
    return super.uploadSpeed;
  }

  @override
  set uploadSpeed(double value) {
    _$uploadSpeedAtom.reportWrite(value, super.uploadSpeed, () {
      super.uploadSpeed = value;
    });
  }

  late final _$_tunnelStatisticsAtom = Atom(
    name: '_NetworkStatisticsStore._tunnelStatistics',
    context: context,
  );

  TunnelStatistics? get tunnelStatistics {
    _$_tunnelStatisticsAtom.reportRead();
    return super._tunnelStatistics;
  }

  @override
  TunnelStatistics? get _tunnelStatistics => tunnelStatistics;

  @override
  set _tunnelStatistics(TunnelStatistics? value) {
    _$_tunnelStatisticsAtom.reportWrite(value, super._tunnelStatistics, () {
      super._tunnelStatistics = value;
    });
  }

  late final _$_getTunnelStatisticsAsyncAction = AsyncAction(
    '_NetworkStatisticsStore._getTunnelStatistics',
    context: context,
  );

  @override
  Future<void> _getTunnelStatistics() {
    return _$_getTunnelStatisticsAsyncAction.run(() => super._getTunnelStatistics());
  }

  @override
  String toString() {
    return '''
downloadSpeed: ${downloadSpeed},
uploadSpeed: ${uploadSpeed},
latestHandshake: ${latestHandshake},
totalDownload: ${totalDownload},
totalUpload: ${totalUpload},
totalDownloadInMB: ${totalDownloadInMB},
totalUploadInMB: ${totalUploadInMB}
    ''';
  }
}
