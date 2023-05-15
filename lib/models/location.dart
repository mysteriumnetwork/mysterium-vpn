import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';

part 'location.g.dart';

class VPNLocations {
  VPNLocations({
    required this.allLocations,
    required this.topLocations,
  });

  final List<Location> allLocations;
  final List<Location> topLocations;
}

class Location extends _Location with _$Location {
  Location({
    required super.countryCode,
  });
}

abstract class _Location with Store {
  _Location({required this.countryCode});

  final String countryCode;

  @computed
  String get countryName => countryCode.tr();
}
