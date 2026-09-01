// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifier_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotifierRegistration {

 String get externalUserId; String get token; NotifierPlatform get platform; int get contractVersion; bool get pending;
/// Create a copy of NotifierRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotifierRegistrationCopyWith<NotifierRegistration> get copyWith => _$NotifierRegistrationCopyWithImpl<NotifierRegistration>(this as NotifierRegistration, _$identity);

  /// Serializes this NotifierRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotifierRegistration&&(identical(other.externalUserId, externalUserId) || other.externalUserId == externalUserId)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalUserId,token,platform,contractVersion,pending);

@override
String toString() {
  return 'NotifierRegistration(externalUserId: $externalUserId, token: $token, platform: $platform, contractVersion: $contractVersion, pending: $pending)';
}


}

/// @nodoc
abstract mixin class $NotifierRegistrationCopyWith<$Res>  {
  factory $NotifierRegistrationCopyWith(NotifierRegistration value, $Res Function(NotifierRegistration) _then) = _$NotifierRegistrationCopyWithImpl;
@useResult
$Res call({
 String externalUserId, String token, NotifierPlatform platform, int contractVersion, bool pending
});




}
/// @nodoc
class _$NotifierRegistrationCopyWithImpl<$Res>
    implements $NotifierRegistrationCopyWith<$Res> {
  _$NotifierRegistrationCopyWithImpl(this._self, this._then);

  final NotifierRegistration _self;
  final $Res Function(NotifierRegistration) _then;

/// Create a copy of NotifierRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? externalUserId = null,Object? token = null,Object? platform = null,Object? contractVersion = null,Object? pending = null,}) {
  return _then(_self.copyWith(
externalUserId: null == externalUserId ? _self.externalUserId : externalUserId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotifierPlatform,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotifierRegistration].
extension NotifierRegistrationPatterns on NotifierRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotifierRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotifierRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotifierRegistration value)  $default,){
final _that = this;
switch (_that) {
case _NotifierRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotifierRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _NotifierRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String externalUserId,  String token,  NotifierPlatform platform,  int contractVersion,  bool pending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotifierRegistration() when $default != null:
return $default(_that.externalUserId,_that.token,_that.platform,_that.contractVersion,_that.pending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String externalUserId,  String token,  NotifierPlatform platform,  int contractVersion,  bool pending)  $default,) {final _that = this;
switch (_that) {
case _NotifierRegistration():
return $default(_that.externalUserId,_that.token,_that.platform,_that.contractVersion,_that.pending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String externalUserId,  String token,  NotifierPlatform platform,  int contractVersion,  bool pending)?  $default,) {final _that = this;
switch (_that) {
case _NotifierRegistration() when $default != null:
return $default(_that.externalUserId,_that.token,_that.platform,_that.contractVersion,_that.pending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotifierRegistration implements NotifierRegistration {
  const _NotifierRegistration({required this.externalUserId, required this.token, required this.platform, required this.contractVersion, this.pending = false});
  factory _NotifierRegistration.fromJson(Map<String, dynamic> json) => _$NotifierRegistrationFromJson(json);

@override final  String externalUserId;
@override final  String token;
@override final  NotifierPlatform platform;
@override final  int contractVersion;
@override@JsonKey() final  bool pending;

/// Create a copy of NotifierRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotifierRegistrationCopyWith<_NotifierRegistration> get copyWith => __$NotifierRegistrationCopyWithImpl<_NotifierRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotifierRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotifierRegistration&&(identical(other.externalUserId, externalUserId) || other.externalUserId == externalUserId)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.pending, pending) || other.pending == pending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,externalUserId,token,platform,contractVersion,pending);

@override
String toString() {
  return 'NotifierRegistration(externalUserId: $externalUserId, token: $token, platform: $platform, contractVersion: $contractVersion, pending: $pending)';
}


}

/// @nodoc
abstract mixin class _$NotifierRegistrationCopyWith<$Res> implements $NotifierRegistrationCopyWith<$Res> {
  factory _$NotifierRegistrationCopyWith(_NotifierRegistration value, $Res Function(_NotifierRegistration) _then) = __$NotifierRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String externalUserId, String token, NotifierPlatform platform, int contractVersion, bool pending
});




}
/// @nodoc
class __$NotifierRegistrationCopyWithImpl<$Res>
    implements _$NotifierRegistrationCopyWith<$Res> {
  __$NotifierRegistrationCopyWithImpl(this._self, this._then);

  final _NotifierRegistration _self;
  final $Res Function(_NotifierRegistration) _then;

/// Create a copy of NotifierRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? externalUserId = null,Object? token = null,Object? platform = null,Object? contractVersion = null,Object? pending = null,}) {
  return _then(_NotifierRegistration(
externalUserId: null == externalUserId ? _self.externalUserId : externalUserId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotifierPlatform,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
