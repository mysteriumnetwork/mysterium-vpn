// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) {
  return _AuthData.fromJson(json);
}

/// @nodoc
mixin _$AuthUser {
  @JsonKey(name: 'sub')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserCopyWith<AuthUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call({@JsonKey(name: 'sub') String userId, @JsonKey(name: 'username') String username});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthDataImplCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$$AuthDataImplCopyWith(_$AuthDataImpl value, $Res Function(_$AuthDataImpl) then) =
      __$$AuthDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'sub') String userId, @JsonKey(name: 'username') String username});
}

/// @nodoc
class __$$AuthDataImplCopyWithImpl<$Res> extends _$AuthUserCopyWithImpl<$Res, _$AuthDataImpl>
    implements _$$AuthDataImplCopyWith<$Res> {
  __$$AuthDataImplCopyWithImpl(_$AuthDataImpl _value, $Res Function(_$AuthDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
  }) {
    return _then(_$AuthDataImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthDataImpl implements _AuthData {
  _$AuthDataImpl(
      {@JsonKey(name: 'sub') required this.userId,
      @JsonKey(name: 'username') required this.username});

  factory _$AuthDataImpl.fromJson(Map<String, dynamic> json) => _$$AuthDataImplFromJson(json);

  @override
  @JsonKey(name: 'sub')
  final String userId;
  @override
  @JsonKey(name: 'username')
  final String username;

  @override
  String toString() {
    return 'AuthUser(userId: $userId, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDataImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) || other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, username);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDataImplCopyWith<_$AuthDataImpl> get copyWith =>
      __$$AuthDataImplCopyWithImpl<_$AuthDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthDataImplToJson(
      this,
    );
  }
}

abstract class _AuthData implements AuthUser {
  factory _AuthData(
      {@JsonKey(name: 'sub') required final String userId,
      @JsonKey(name: 'username') required final String username}) = _$AuthDataImpl;

  factory _AuthData.fromJson(Map<String, dynamic> json) = _$AuthDataImpl.fromJson;

  @override
  @JsonKey(name: 'sub')
  String get userId;
  @override
  @JsonKey(name: 'username')
  String get username;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthDataImplCopyWith<_$AuthDataImpl> get copyWith => throw _privateConstructorUsedError;
}
