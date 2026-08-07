// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_ip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteIp {

 String get ip; String get countryCode; String get city; IPType get ipType; DateTime get savedAt;// Display name captured at save time; empty for entries persisted before
// the field existed (the country code is translated as a fallback).
 String get countryName;// Id of the location the user had picked when saving — the city id for a
// city-level connection, the country code for a country-level one. Empty
// for entries persisted before the field existed (treated as country).
 String get locationId;
/// Create a copy of FavoriteIp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteIpCopyWith<FavoriteIp> get copyWith => _$FavoriteIpCopyWithImpl<FavoriteIp>(this as FavoriteIp, _$identity);

  /// Serializes this FavoriteIp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteIp&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.ipType, ipType) || other.ipType == ipType)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.locationId, locationId) || other.locationId == locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ip,countryCode,city,ipType,savedAt,countryName,locationId);

@override
String toString() {
  return 'FavoriteIp(ip: $ip, countryCode: $countryCode, city: $city, ipType: $ipType, savedAt: $savedAt, countryName: $countryName, locationId: $locationId)';
}


}

/// @nodoc
abstract mixin class $FavoriteIpCopyWith<$Res>  {
  factory $FavoriteIpCopyWith(FavoriteIp value, $Res Function(FavoriteIp) _then) = _$FavoriteIpCopyWithImpl;
@useResult
$Res call({
 String ip, String countryCode, String city, IPType ipType, DateTime savedAt, String countryName, String locationId
});




}
/// @nodoc
class _$FavoriteIpCopyWithImpl<$Res>
    implements $FavoriteIpCopyWith<$Res> {
  _$FavoriteIpCopyWithImpl(this._self, this._then);

  final FavoriteIp _self;
  final $Res Function(FavoriteIp) _then;

/// Create a copy of FavoriteIp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ip = null,Object? countryCode = null,Object? city = null,Object? ipType = null,Object? savedAt = null,Object? countryName = null,Object? locationId = null,}) {
  return _then(_self.copyWith(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,ipType: null == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as IPType,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteIp].
extension FavoriteIpPatterns on FavoriteIp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteIp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteIp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteIp value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteIp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteIp value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteIp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ip,  String countryCode,  String city,  IPType ipType,  DateTime savedAt,  String countryName,  String locationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteIp() when $default != null:
return $default(_that.ip,_that.countryCode,_that.city,_that.ipType,_that.savedAt,_that.countryName,_that.locationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ip,  String countryCode,  String city,  IPType ipType,  DateTime savedAt,  String countryName,  String locationId)  $default,) {final _that = this;
switch (_that) {
case _FavoriteIp():
return $default(_that.ip,_that.countryCode,_that.city,_that.ipType,_that.savedAt,_that.countryName,_that.locationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ip,  String countryCode,  String city,  IPType ipType,  DateTime savedAt,  String countryName,  String locationId)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteIp() when $default != null:
return $default(_that.ip,_that.countryCode,_that.city,_that.ipType,_that.savedAt,_that.countryName,_that.locationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteIp implements FavoriteIp {
  const _FavoriteIp({required this.ip, required this.countryCode, required this.city, required this.ipType, required this.savedAt, this.countryName = '', this.locationId = ''});
  factory _FavoriteIp.fromJson(Map<String, dynamic> json) => _$FavoriteIpFromJson(json);

@override final  String ip;
@override final  String countryCode;
@override final  String city;
@override final  IPType ipType;
@override final  DateTime savedAt;
// Display name captured at save time; empty for entries persisted before
// the field existed (the country code is translated as a fallback).
@override@JsonKey() final  String countryName;
// Id of the location the user had picked when saving — the city id for a
// city-level connection, the country code for a country-level one. Empty
// for entries persisted before the field existed (treated as country).
@override@JsonKey() final  String locationId;

/// Create a copy of FavoriteIp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteIpCopyWith<_FavoriteIp> get copyWith => __$FavoriteIpCopyWithImpl<_FavoriteIp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteIpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteIp&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.ipType, ipType) || other.ipType == ipType)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.locationId, locationId) || other.locationId == locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ip,countryCode,city,ipType,savedAt,countryName,locationId);

@override
String toString() {
  return 'FavoriteIp(ip: $ip, countryCode: $countryCode, city: $city, ipType: $ipType, savedAt: $savedAt, countryName: $countryName, locationId: $locationId)';
}


}

/// @nodoc
abstract mixin class _$FavoriteIpCopyWith<$Res> implements $FavoriteIpCopyWith<$Res> {
  factory _$FavoriteIpCopyWith(_FavoriteIp value, $Res Function(_FavoriteIp) _then) = __$FavoriteIpCopyWithImpl;
@override @useResult
$Res call({
 String ip, String countryCode, String city, IPType ipType, DateTime savedAt, String countryName, String locationId
});




}
/// @nodoc
class __$FavoriteIpCopyWithImpl<$Res>
    implements _$FavoriteIpCopyWith<$Res> {
  __$FavoriteIpCopyWithImpl(this._self, this._then);

  final _FavoriteIp _self;
  final $Res Function(_FavoriteIp) _then;

/// Create a copy of FavoriteIp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ip = null,Object? countryCode = null,Object? city = null,Object? ipType = null,Object? savedAt = null,Object? countryName = null,Object? locationId = null,}) {
  return _then(_FavoriteIp(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,ipType: null == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as IPType,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
