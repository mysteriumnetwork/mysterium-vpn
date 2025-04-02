import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/enums/ip_type.dart';

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

  late final Set<VPNLocation> allLocations = {...locations, ...topLocations};
  late final bool isEmpty = allLocations.isEmpty;
}

@freezed
class VPNLocation with _$VPNLocation {
  const factory VPNLocation({
    @Default('') String code,
    @Default(IPType.residential) IPType ipType,
  }) = _VPNLocation;

  const VPNLocation._();

  factory VPNLocation.fromJson(Map<String, dynamic> json) => _$VPNLocationFromJson(json);
}
