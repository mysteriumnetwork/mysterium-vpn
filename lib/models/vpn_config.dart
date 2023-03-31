import 'package:freezed_annotation/freezed_annotation.dart';

part 'vpn_config.freezed.dart';
part 'vpn_config.g.dart';

@freezed
class VpnConfig with _$VpnConfig {
  const factory VpnConfig({
    @JsonKey(name: 'wg_config') required String config,
  }) = _VpnConfig;

  factory VpnConfig.fromJson(Map<String, Object?> json) => _$VpnConfigFromJson(json);
}

@freezed
class VpnConfigInput with _$VpnConfigInput {
  const factory VpnConfigInput({
    @JsonKey(name: 'public_key') required String publicKey,
    String? country,
    @JsonKey(name: 'ip_type') String? ipType,
  }) = _VpnConfigInput;

  factory VpnConfigInput.fromJson(Map<String, Object?> json) => _$VpnConfigInputFromJson(json);
}
