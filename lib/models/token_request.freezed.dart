// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TokenRequest _$TokenRequestFromJson(Map<String, dynamic> json) {
  return _TokenRequest.fromJson(json);
}

/// @nodoc
mixin _$TokenRequest {
  @JsonKey(name: 'grant_type', toJson: grantTypeToJson)
  GrantType get grantType => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_id')
  String get clientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_verifier')
  String? get codeVerifier => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'google_id_token')
  String? get googleIdToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_token', includeToJson: false)
  String? get idToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorization', toJson: authorizationToJson)
  String? get authorization => throw _privateConstructorUsedError;

  /// Serializes this TokenRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenRequestCopyWith<TokenRequest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenRequestCopyWith<$Res> {
  factory $TokenRequestCopyWith(TokenRequest value, $Res Function(TokenRequest) then) =
      _$TokenRequestCopyWithImpl<$Res, TokenRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'code_verifier') String? codeVerifier,
      String? code,
      @JsonKey(name: 'google_id_token') String? googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization});
}

/// @nodoc
class _$TokenRequestCopyWithImpl<$Res, $Val extends TokenRequest>
    implements $TokenRequestCopyWith<$Res> {
  _$TokenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantType = null,
    Object? clientId = null,
    Object? codeVerifier = freezed,
    Object? code = freezed,
    Object? googleIdToken = freezed,
    Object? idToken = freezed,
    Object? authorization = freezed,
  }) {
    return _then(_value.copyWith(
      grantType: null == grantType
          ? _value.grantType
          : grantType // ignore: cast_nullable_to_non_nullable
              as GrantType,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      codeVerifier: freezed == codeVerifier
          ? _value.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      googleIdToken: freezed == googleIdToken
          ? _value.googleIdToken
          : googleIdToken // ignore: cast_nullable_to_non_nullable
              as String?,
      idToken: freezed == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      authorization: freezed == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenRequestImplCopyWith<$Res> implements $TokenRequestCopyWith<$Res> {
  factory _$$TokenRequestImplCopyWith(
          _$TokenRequestImpl value, $Res Function(_$TokenRequestImpl) then) =
      __$$TokenRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'code_verifier') String? codeVerifier,
      String? code,
      @JsonKey(name: 'google_id_token') String? googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization});
}

/// @nodoc
class __$$TokenRequestImplCopyWithImpl<$Res>
    extends _$TokenRequestCopyWithImpl<$Res, _$TokenRequestImpl>
    implements _$$TokenRequestImplCopyWith<$Res> {
  __$$TokenRequestImplCopyWithImpl(
      _$TokenRequestImpl _value, $Res Function(_$TokenRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantType = null,
    Object? clientId = null,
    Object? codeVerifier = freezed,
    Object? code = freezed,
    Object? googleIdToken = freezed,
    Object? idToken = freezed,
    Object? authorization = freezed,
  }) {
    return _then(_$TokenRequestImpl(
      grantType: null == grantType
          ? _value.grantType
          : grantType // ignore: cast_nullable_to_non_nullable
              as GrantType,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      codeVerifier: freezed == codeVerifier
          ? _value.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      googleIdToken: freezed == googleIdToken
          ? _value.googleIdToken
          : googleIdToken // ignore: cast_nullable_to_non_nullable
              as String?,
      idToken: freezed == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      authorization: freezed == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenRequestImpl implements _TokenRequest {
  _$TokenRequestImpl(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) required this.grantType,
      @JsonKey(name: 'client_id') this.clientId = 'app',
      @JsonKey(name: 'code_verifier') this.codeVerifier,
      this.code,
      @JsonKey(name: 'google_id_token') this.googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) this.idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) this.authorization});

  factory _$TokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenRequestImplFromJson(json);

  @override
  @JsonKey(name: 'grant_type', toJson: grantTypeToJson)
  final GrantType grantType;
  @override
  @JsonKey(name: 'client_id')
  final String clientId;
  @override
  @JsonKey(name: 'code_verifier')
  final String? codeVerifier;
  @override
  final String? code;
  @override
  @JsonKey(name: 'google_id_token')
  final String? googleIdToken;
  @override
  @JsonKey(name: 'id_token', includeToJson: false)
  final String? idToken;
  @override
  @JsonKey(name: 'authorization', toJson: authorizationToJson)
  final String? authorization;

  @override
  String toString() {
    return 'TokenRequest(grantType: $grantType, clientId: $clientId, codeVerifier: $codeVerifier, code: $code, googleIdToken: $googleIdToken, idToken: $idToken, authorization: $authorization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenRequestImpl &&
            (identical(other.grantType, grantType) || other.grantType == grantType) &&
            (identical(other.clientId, clientId) || other.clientId == clientId) &&
            (identical(other.codeVerifier, codeVerifier) || other.codeVerifier == codeVerifier) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.googleIdToken, googleIdToken) ||
                other.googleIdToken == googleIdToken) &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.authorization, authorization) ||
                other.authorization == authorization));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grantType, clientId, codeVerifier, code, googleIdToken, idToken, authorization);

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenRequestImplCopyWith<_$TokenRequestImpl> get copyWith =>
      __$$TokenRequestImplCopyWithImpl<_$TokenRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenRequestImplToJson(
      this,
    );
  }
}

abstract class _TokenRequest implements TokenRequest {
  factory _TokenRequest(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) required final GrantType grantType,
      @JsonKey(name: 'client_id') final String clientId,
      @JsonKey(name: 'code_verifier') final String? codeVerifier,
      final String? code,
      @JsonKey(name: 'google_id_token') final String? googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) final String? idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson)
      final String? authorization}) = _$TokenRequestImpl;

  factory _TokenRequest.fromJson(Map<String, dynamic> json) = _$TokenRequestImpl.fromJson;

  @override
  @JsonKey(name: 'grant_type', toJson: grantTypeToJson)
  GrantType get grantType;
  @override
  @JsonKey(name: 'client_id')
  String get clientId;
  @override
  @JsonKey(name: 'code_verifier')
  String? get codeVerifier;
  @override
  String? get code;
  @override
  @JsonKey(name: 'google_id_token')
  String? get googleIdToken;
  @override
  @JsonKey(name: 'id_token', includeToJson: false)
  String? get idToken;
  @override
  @JsonKey(name: 'authorization', toJson: authorizationToJson)
  String? get authorization;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenRequestImplCopyWith<_$TokenRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
