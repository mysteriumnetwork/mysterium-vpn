import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/env.dart';

enum AnalyticsUserPropName {
  pnPermissionStatus,
  deviceId,
  deviceModel,
  devicePlatform,
  deviceName,
  countryUser,
  planId,
  validTo,
  userStatus,
  marketingConsent,
  email,
  protocol;

  String get formattedName => name.toSnakeCase;
}

@immutable
class AnalyticsUserProperty {
  AnalyticsUserProperty._({required this.rawName, required this.value}) : setAt = DateTime.now() {
    if (Env.flavor.isDev && rawName.length > 24) {
      debugPrint(
        'Warning: AnalyticsUserProperty name exceeds 24 characters: "$rawName" (${rawName.length} chars)',
      );
    }
    if (Env.flavor.isDev && value.length > 36) {
      debugPrint(
        'Warning: AnalyticsUserProperty value exceeds 36 characters: "$value" (${value.length} chars)',
      );
    }
  }

  /// Factory constructor that creates an AnalyticsUserProperty from an enum
  factory AnalyticsUserProperty.fromEnum({
    required AnalyticsUserPropName name,
    required String value,
  }) => AnalyticsUserProperty._(rawName: name.formattedName, value: value);

  /// Factory constructor that creates an AnalyticsUserProperty from a string name
  factory AnalyticsUserProperty.fromString({required String name, required String value}) =>
      AnalyticsUserProperty._(rawName: name, value: value);

  final String rawName;
  final String value;
  final DateTime setAt;

  String get name24chars => rawName.truncate(24);

  String get value36chars => value.truncate(36);

  @override
  String toString() => 'AnalyticsUserProperty(name: $rawName, value: $value, setAt: $setAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AnalyticsUserProperty && other.rawName == rawName && other.value == value;
  }

  @override
  int get hashCode => rawName.hashCode ^ value.hashCode;
}
