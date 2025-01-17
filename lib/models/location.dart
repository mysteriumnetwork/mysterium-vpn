import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/enums/ip_type.dart';

part 'location.freezed.dart';

part 'location.g.dart';

@Freezed(fromJson: false, toJson: false)
class VPNLocations with _$VPNLocations {
  const factory VPNLocations({
    @Default([]) List<VPNLocation> allLocations,
    @Default([]) List<VPNLocation> topLocations,
    @Default([]) List<VPNLocation> dcLocations,
  }) = _VPNLocations;

  const VPNLocations._();

  VPNLocations withDCCountries(List<String> countryCode) => copyWith(
        dcLocations: {...allLocations, ...topLocations}
            .where((it) => countryCode.contains(it.code))
            .map((it) => VPNLocation(code: it.code, ipType: IPType.datacenter))
            .toList(),
      );
}

@freezed
class VPNLocation with _$VPNLocation {
  const factory VPNLocation({
    required String code,
    @Default(IPType.residential) IPType ipType,
  }) = _VPNLocation;

  const VPNLocation._();

  factory VPNLocation.fromJson(Map<String, dynamic> json) => _$VPNLocationFromJson(json);
}
