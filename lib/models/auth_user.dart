// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  factory AuthUser({
    @JsonKey(name: 'sub') required String userId,
    @JsonKey(name: 'username') required String username,
  }) = _AuthData;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
