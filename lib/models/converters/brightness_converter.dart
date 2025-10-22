import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

class BrightnessConverter extends JsonConverter<Brightness, String> {
  const BrightnessConverter();

  @override
  Brightness fromJson(String json) => Brightness.values.firstWhere((it) => it.name == json);

  @override
  String toJson(Brightness object) => object.name;
}
