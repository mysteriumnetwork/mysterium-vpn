// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_response.freezed.dart';
part 'token_response.g.dart';

@freezed
abstract class TokenResponse with _$TokenResponse {
  factory TokenResponse({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);
}
