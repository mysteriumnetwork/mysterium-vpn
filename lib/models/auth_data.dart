// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_data.freezed.dart';
part 'auth_data.g.dart';

@freezed
class AuthData with _$AuthData {
  factory AuthData({
    @JsonKey(name: 'auth_token') required String authToken,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'user_id') required String userId,
  }) = _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) => _$AuthDataFromJson(json);
}
