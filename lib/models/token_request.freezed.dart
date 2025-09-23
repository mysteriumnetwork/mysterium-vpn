// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenRequest {
  @JsonKey(name: 'grant_type', toJson: grantTypeToJson)
  GrantType get grantType;
  @JsonKey(name: 'client_id')
  String get clientId;
  @JsonKey(name: 'refresh_token')
  String? get refreshToken;
  @JsonKey(name: 'code_verifier')
  String? get codeVerifier;
  String? get code;
  @JsonKey(name: 'google_id_token')
  String? get googleIdToken;
  @JsonKey(name: 'id_token', includeToJson: false)
  String? get idToken;
  @JsonKey(name: 'authorization', toJson: authorizationToJson)
  String? get authorization;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TokenRequestCopyWith<TokenRequest> get copyWith =>
      _$TokenRequestCopyWithImpl<TokenRequest>(this as TokenRequest, _$identity);

  /// Serializes this TokenRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TokenRequest &&
            (identical(other.grantType, grantType) || other.grantType == grantType) &&
            (identical(other.clientId, clientId) || other.clientId == clientId) &&
            (identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken) &&
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
  int get hashCode => Object.hash(runtimeType, grantType, clientId, refreshToken, codeVerifier,
      code, googleIdToken, idToken, authorization);

  @override
  String toString() {
    return 'TokenRequest(grantType: $grantType, clientId: $clientId, refreshToken: $refreshToken, codeVerifier: $codeVerifier, code: $code, googleIdToken: $googleIdToken, idToken: $idToken, authorization: $authorization)';
  }
}

/// @nodoc
abstract mixin class $TokenRequestCopyWith<$Res> {
  factory $TokenRequestCopyWith(TokenRequest value, $Res Function(TokenRequest) _then) =
      _$TokenRequestCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'code_verifier') String? codeVerifier,
      String? code,
      @JsonKey(name: 'google_id_token') String? googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization});
}

/// @nodoc
class _$TokenRequestCopyWithImpl<$Res> implements $TokenRequestCopyWith<$Res> {
  _$TokenRequestCopyWithImpl(this._self, this._then);

  final TokenRequest _self;
  final $Res Function(TokenRequest) _then;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantType = null,
    Object? clientId = null,
    Object? refreshToken = freezed,
    Object? codeVerifier = freezed,
    Object? code = freezed,
    Object? googleIdToken = freezed,
    Object? idToken = freezed,
    Object? authorization = freezed,
  }) {
    return _then(_self.copyWith(
      grantType: null == grantType
          ? _self.grantType
          : grantType // ignore: cast_nullable_to_non_nullable
              as GrantType,
      clientId: null == clientId
          ? _self.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      codeVerifier: freezed == codeVerifier
          ? _self.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      googleIdToken: freezed == googleIdToken
          ? _self.googleIdToken
          : googleIdToken // ignore: cast_nullable_to_non_nullable
              as String?,
      idToken: freezed == idToken
          ? _self.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      authorization: freezed == authorization
          ? _self.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TokenRequest].
extension TokenRequestPatterns on TokenRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TokenRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokenRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TokenRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TokenRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
            @JsonKey(name: 'client_id') String clientId,
            @JsonKey(name: 'refresh_token') String? refreshToken,
            @JsonKey(name: 'code_verifier') String? codeVerifier,
            String? code,
            @JsonKey(name: 'google_id_token') String? googleIdToken,
            @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
            @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokenRequest() when $default != null:
        return $default(_that.grantType, _that.clientId, _that.refreshToken, _that.codeVerifier,
            _that.code, _that.googleIdToken, _that.idToken, _that.authorization);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
            @JsonKey(name: 'client_id') String clientId,
            @JsonKey(name: 'refresh_token') String? refreshToken,
            @JsonKey(name: 'code_verifier') String? codeVerifier,
            String? code,
            @JsonKey(name: 'google_id_token') String? googleIdToken,
            @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
            @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenRequest():
        return $default(_that.grantType, _that.clientId, _that.refreshToken, _that.codeVerifier,
            _that.code, _that.googleIdToken, _that.idToken, _that.authorization);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
            @JsonKey(name: 'client_id') String clientId,
            @JsonKey(name: 'refresh_token') String? refreshToken,
            @JsonKey(name: 'code_verifier') String? codeVerifier,
            String? code,
            @JsonKey(name: 'google_id_token') String? googleIdToken,
            @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
            @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenRequest() when $default != null:
        return $default(_that.grantType, _that.clientId, _that.refreshToken, _that.codeVerifier,
            _that.code, _that.googleIdToken, _that.idToken, _that.authorization);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TokenRequest implements TokenRequest {
  _TokenRequest(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) required this.grantType,
      @JsonKey(name: 'client_id') this.clientId = 'app',
      @JsonKey(name: 'refresh_token') this.refreshToken,
      @JsonKey(name: 'code_verifier') this.codeVerifier,
      this.code,
      @JsonKey(name: 'google_id_token') this.googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) this.idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) this.authorization});
  factory _TokenRequest.fromJson(Map<String, dynamic> json) => _$TokenRequestFromJson(json);

  @override
  @JsonKey(name: 'grant_type', toJson: grantTypeToJson)
  final GrantType grantType;
  @override
  @JsonKey(name: 'client_id')
  final String clientId;
  @override
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
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

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TokenRequestCopyWith<_TokenRequest> get copyWith =>
      __$TokenRequestCopyWithImpl<_TokenRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TokenRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TokenRequest &&
            (identical(other.grantType, grantType) || other.grantType == grantType) &&
            (identical(other.clientId, clientId) || other.clientId == clientId) &&
            (identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken) &&
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
  int get hashCode => Object.hash(runtimeType, grantType, clientId, refreshToken, codeVerifier,
      code, googleIdToken, idToken, authorization);

  @override
  String toString() {
    return 'TokenRequest(grantType: $grantType, clientId: $clientId, refreshToken: $refreshToken, codeVerifier: $codeVerifier, code: $code, googleIdToken: $googleIdToken, idToken: $idToken, authorization: $authorization)';
  }
}

/// @nodoc
abstract mixin class _$TokenRequestCopyWith<$Res> implements $TokenRequestCopyWith<$Res> {
  factory _$TokenRequestCopyWith(_TokenRequest value, $Res Function(_TokenRequest) _then) =
      __$TokenRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'grant_type', toJson: grantTypeToJson) GrantType grantType,
      @JsonKey(name: 'client_id') String clientId,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'code_verifier') String? codeVerifier,
      String? code,
      @JsonKey(name: 'google_id_token') String? googleIdToken,
      @JsonKey(name: 'id_token', includeToJson: false) String? idToken,
      @JsonKey(name: 'authorization', toJson: authorizationToJson) String? authorization});
}

/// @nodoc
class __$TokenRequestCopyWithImpl<$Res> implements _$TokenRequestCopyWith<$Res> {
  __$TokenRequestCopyWithImpl(this._self, this._then);

  final _TokenRequest _self;
  final $Res Function(_TokenRequest) _then;

  /// Create a copy of TokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? grantType = null,
    Object? clientId = null,
    Object? refreshToken = freezed,
    Object? codeVerifier = freezed,
    Object? code = freezed,
    Object? googleIdToken = freezed,
    Object? idToken = freezed,
    Object? authorization = freezed,
  }) {
    return _then(_TokenRequest(
      grantType: null == grantType
          ? _self.grantType
          : grantType // ignore: cast_nullable_to_non_nullable
              as GrantType,
      clientId: null == clientId
          ? _self.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      codeVerifier: freezed == codeVerifier
          ? _self.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      googleIdToken: freezed == googleIdToken
          ? _self.googleIdToken
          : googleIdToken // ignore: cast_nullable_to_non_nullable
              as String?,
      idToken: freezed == idToken
          ? _self.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String?,
      authorization: freezed == authorization
          ? _self.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
