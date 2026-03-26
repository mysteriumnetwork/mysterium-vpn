// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenResponse {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String? get refreshToken;
/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenResponseCopyWith<TokenResponse> get copyWith => _$TokenResponseCopyWithImpl<TokenResponse>(this as TokenResponse, _$identity);

  /// Serializes this TokenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,accessToken,refreshToken);

@override
String toString() {
  return 'TokenResponse(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $TokenResponseCopyWith<$Res>  {
  factory $TokenResponseCopyWith(TokenResponse value, $Res Function(TokenResponse) _then) = _$TokenResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String? refreshToken
});




}
/// @nodoc
class _$TokenResponseCopyWithImpl<$Res>
    implements $TokenResponseCopyWith<$Res> {
  _$TokenResponseCopyWithImpl(this._self, this._then);

  final TokenResponse _self;
  final $Res Function(TokenResponse) _then;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? accessToken = null,Object? refreshToken = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenResponse].
extension TokenResponsePatterns on TokenResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenResponse value)  $default,){
final _that = this;
switch (_that) {
case _TokenResponse():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that.userId,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)  $default,) {final _that = this;
switch (_that) {
case _TokenResponse():
return $default(_that.userId,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String? refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that.userId,_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenResponse implements TokenResponse {
   _TokenResponse({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') this.refreshToken});
  factory _TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String? refreshToken;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenResponseCopyWith<_TokenResponse> get copyWith => __$TokenResponseCopyWithImpl<_TokenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,accessToken,refreshToken);

@override
String toString() {
  return 'TokenResponse(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$TokenResponseCopyWith<$Res> implements $TokenResponseCopyWith<$Res> {
  factory _$TokenResponseCopyWith(_TokenResponse value, $Res Function(_TokenResponse) _then) = __$TokenResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String? refreshToken
});




}
/// @nodoc
class __$TokenResponseCopyWithImpl<$Res>
    implements _$TokenResponseCopyWith<$Res> {
  __$TokenResponseCopyWithImpl(this._self, this._then);

  final _TokenResponse _self;
  final $Res Function(_TokenResponse) _then;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? accessToken = null,Object? refreshToken = freezed,}) {
  return _then(_TokenResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
