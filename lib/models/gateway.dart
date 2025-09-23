// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gateway.freezed.dart';
part 'gateway.g.dart';

@freezed
abstract class Gateway with _$Gateway {
  factory Gateway({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'enabled') required bool enabled,
  }) = _Gateway;

  factory Gateway.fromJson(Map<String, dynamic> json) => _$GatewayFromJson(json);
}
