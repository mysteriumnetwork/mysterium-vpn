// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeviceInfoStore on _DeviceInfoStore, Store {
  Computed<Map<String, dynamic>?>? _$deviceInfoComputed;

  @override
  Map<String, dynamic>? get deviceInfo =>
      (_$deviceInfoComputed ??= Computed<Map<String, dynamic>?>(() => super.deviceInfo,
              name: '_DeviceInfoStore.deviceInfo'))
          .value;
  Computed<String>? _$deviceIdComputed;

  @override
  String get deviceId => (_$deviceIdComputed ??=
          Computed<String>(() => super.deviceId, name: '_DeviceInfoStore.deviceId'))
      .value;
  Computed<String>? _$deviceNameComputed;

  @override
  String get deviceName => (_$deviceNameComputed ??=
          Computed<String>(() => super.deviceName, name: '_DeviceInfoStore.deviceName'))
      .value;
  Computed<String>? _$deviceModelComputed;

  @override
  String get deviceModel => (_$deviceModelComputed ??=
          Computed<String>(() => super.deviceModel, name: '_DeviceInfoStore.deviceModel'))
      .value;

  late final _$deviceInfoFutureAtom =
      Atom(name: '_DeviceInfoStore.deviceInfoFuture', context: context);

  @override
  ObservableFuture<Map<String, dynamic>> get deviceInfoFuture {
    _$deviceInfoFutureAtom.reportRead();
    return super.deviceInfoFuture;
  }

  bool _deviceInfoFutureIsInitialized = false;

  @override
  set deviceInfoFuture(ObservableFuture<Map<String, dynamic>> value) {
    _$deviceInfoFutureAtom
        .reportWrite(value, _deviceInfoFutureIsInitialized ? super.deviceInfoFuture : null, () {
      super.deviceInfoFuture = value;
      _deviceInfoFutureIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
deviceInfoFuture: ${deviceInfoFuture},
deviceInfo: ${deviceInfo},
deviceId: ${deviceId},
deviceName: ${deviceName},
deviceModel: ${deviceModel}
    ''';
  }
}
