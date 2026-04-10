// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';

part 'token_request.freezed.dart';

part 'token_request.g.dart';

@freezed
abstract class TokenRequest with _$TokenRequest {
  factory TokenRequest({
    @JsonKey(name: 'grant_type', toJson: grantTypeToJson) required GrantType grantType,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'client_id') @Default('app') String clientId,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'code_verifier') String? codeVerifier,
    String? code,
    @JsonKey(name: 'google_id_token') String? googleIdToken,
    @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
    @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization,
  }) = _TokenRequest;

  factory TokenRequest.fromJson(Map<String, dynamic> json) => _$TokenRequestFromJson(json);
}

String grantTypeToJson(GrantType grantType) => grantType.value;

Map<String, String?>? authorizationToJson(String? authorization) {
  if (authorization == null) {
    return null;
  }
  return {'id_token': authorization};
}
