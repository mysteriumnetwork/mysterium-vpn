import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/ip_type.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

part 'location.freezed.dart';

part 'location.g.dart';

@freezed
class VPNLocations with _$VPNLocations {
  factory VPNLocations({
    @Default([]) List<VPNLocation> locations,
    @Default([]) List<VPNLocation> topLocations,
  }) = _VPNLocations;

  VPNLocations._();

  factory VPNLocations.fromJson(Map<String, dynamic> json) => _$VPNLocationsFromJson(json);

  factory VPNLocations.fromLegacyJson(Map<String, dynamic> json) {
    final locations = (json['locations'] as List<dynamic>?)
            ?.map((e) => VPNLocation.fromLegacyJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final topLocations = (json['topLocations'] as List<dynamic>?)
            ?.map((e) => VPNLocation.fromLegacyJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return VPNLocations(locations: locations, topLocations: topLocations);
  }

  late final Set<VPNLocation> allLocations = {...locations, ...topLocations};
  late final bool isEmpty = allLocations.isEmpty;
}

@freezed
class VPNLocation with _$VPNLocation {
  const factory VPNLocation({
    required String id,
    required IPType ipType,
    required Map<String, String> translations,
    VPNLocation? parent,
  }) = _VPNLocation;

  const VPNLocation._();

  factory VPNLocation.fromJson(Map<String, dynamic> json) => _$VPNLocationFromJson(json);

  factory VPNLocation.fromLegacyJson(Map<String, dynamic> json) {
    final code = json['code'] as String;
    final ipType = IPType.fromName(json['ipType'] as String);
    return VPNLocation.fromCode(code, ipType);
  }

  factory VPNLocation.fromCode(String code, [IPType ipType = IPType.residential]) {
    List<Locale> locales;
    try {
      final localization = EasyLocalization.of(rootContext)!;
      locales = localization.supportedLocales;
    } catch (e) {
      locales = kSupportedLocales;
    }
    final translations = {
      for (final locale in locales) locale.languageCode.toLowerCase(): code.tr(),
    };
    return VPNLocation(
      id: code,
      ipType: ipType,
      translations: translations,
    );
  }
}
