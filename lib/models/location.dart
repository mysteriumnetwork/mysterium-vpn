import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends _Location with _$Location {
  Location({
    required super.countryCode,
  });

  factory Location.fromJson(Map<String, Object?> json) => _$LocationFromJson(json);
}

abstract class _Location with Store {
  _Location({required this.countryCode});

  final String countryCode;

  @computed
  String get countryName => countryCode.tr();
}
