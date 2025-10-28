import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

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
  email;

  String get formattedName => name.toSnakeCase;
}

class AnalyticsUserProperty {
  AnalyticsUserProperty._({
    required this.rawName,
    required this.value,
  }) : setAt = DateTime.now() {
    if (rawName.length > 24) {
      debugPrint(
        'Warning: AnalyticsUserProperty name exceeds 24 characters: "$rawName" (${rawName.length} chars)',
      );
    }
    if (value.length > 36) {
      debugPrint(
        'Warning: AnalyticsUserProperty value exceeds 36 characters: "$value" (${value.length} chars)',
      );
    }
  }

  /// Factory constructor that creates an AnalyticsUserProperty from an enum
  factory AnalyticsUserProperty.fromEnum({
    required AnalyticsUserPropName name,
    required String value,
  }) =>
      AnalyticsUserProperty._(
        rawName: name.formattedName,
        value: value,
      );

  /// Factory constructor that creates an AnalyticsUserProperty from a string name
  factory AnalyticsUserProperty.fromString({
    required String name,
    required String value,
  }) =>
      AnalyticsUserProperty._(
        rawName: name,
        value: value,
      );

  final String rawName;
  final String value;
  final DateTime setAt;

  String get name24chars => rawName.length > 24 ? rawName.substring(0, 24) : rawName;

  String get value36chars => value.length > 36 ? value.substring(0, 36) : value;
}
