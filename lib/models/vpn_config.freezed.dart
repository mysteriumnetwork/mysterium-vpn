// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VpnConfig {

 String get id; String get config;// either wgConfig or ovpnConfig
 String get hash; String? get exitIp; bool? get limitExceeded; String? get ipType; String? get country; String? get city; String? get type;
/// Create a copy of VpnConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VpnConfigCopyWith<VpnConfig> get copyWith => _$VpnConfigCopyWithImpl<VpnConfig>(this as VpnConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VpnConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.config, config) || other.config == config)&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.exitIp, exitIp) || other.exitIp == exitIp)&&(identical(other.limitExceeded, limitExceeded) || other.limitExceeded == limitExceeded)&&(identical(other.ipType, ipType) || other.ipType == ipType)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,config,hash,exitIp,limitExceeded,ipType,country,city,type);

@override
String toString() {
  return 'VpnConfig(id: $id, config: $config, hash: $hash, exitIp: $exitIp, limitExceeded: $limitExceeded, ipType: $ipType, country: $country, city: $city, type: $type)';
}


}

/// @nodoc
abstract mixin class $VpnConfigCopyWith<$Res>  {
  factory $VpnConfigCopyWith(VpnConfig value, $Res Function(VpnConfig) _then) = _$VpnConfigCopyWithImpl;
@useResult
$Res call({
 String id, String config, String hash, String? exitIp, bool? limitExceeded, String? ipType, String? country, String? city, String? type
});




}
/// @nodoc
class _$VpnConfigCopyWithImpl<$Res>
    implements $VpnConfigCopyWith<$Res> {
  _$VpnConfigCopyWithImpl(this._self, this._then);

  final VpnConfig _self;
  final $Res Function(VpnConfig) _then;

/// Create a copy of VpnConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? config = null,Object? hash = null,Object? exitIp = freezed,Object? limitExceeded = freezed,Object? ipType = freezed,Object? country = freezed,Object? city = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as String,hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,exitIp: freezed == exitIp ? _self.exitIp : exitIp // ignore: cast_nullable_to_non_nullable
as String?,limitExceeded: freezed == limitExceeded ? _self.limitExceeded : limitExceeded // ignore: cast_nullable_to_non_nullable
as bool?,ipType: freezed == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VpnConfig].
extension VpnConfigPatterns on VpnConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VpnConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VpnConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VpnConfig value)  $default,){
final _that = this;
switch (_that) {
case _VpnConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VpnConfig value)?  $default,){
final _that = this;
switch (_that) {
case _VpnConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String config,  String hash,  String? exitIp,  bool? limitExceeded,  String? ipType,  String? country,  String? city,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VpnConfig() when $default != null:
return $default(_that.id,_that.config,_that.hash,_that.exitIp,_that.limitExceeded,_that.ipType,_that.country,_that.city,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String config,  String hash,  String? exitIp,  bool? limitExceeded,  String? ipType,  String? country,  String? city,  String? type)  $default,) {final _that = this;
switch (_that) {
case _VpnConfig():
return $default(_that.id,_that.config,_that.hash,_that.exitIp,_that.limitExceeded,_that.ipType,_that.country,_that.city,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String config,  String hash,  String? exitIp,  bool? limitExceeded,  String? ipType,  String? country,  String? city,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _VpnConfig() when $default != null:
return $default(_that.id,_that.config,_that.hash,_that.exitIp,_that.limitExceeded,_that.ipType,_that.country,_that.city,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _VpnConfig implements VpnConfig {
  const _VpnConfig({required this.id, required this.config, required this.hash, this.exitIp, this.limitExceeded, this.ipType, this.country, this.city, this.type});
  

@override final  String id;
@override final  String config;
// either wgConfig or ovpnConfig
@override final  String hash;
@override final  String? exitIp;
@override final  bool? limitExceeded;
@override final  String? ipType;
@override final  String? country;
@override final  String? city;
@override final  String? type;

/// Create a copy of VpnConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VpnConfigCopyWith<_VpnConfig> get copyWith => __$VpnConfigCopyWithImpl<_VpnConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VpnConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.config, config) || other.config == config)&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.exitIp, exitIp) || other.exitIp == exitIp)&&(identical(other.limitExceeded, limitExceeded) || other.limitExceeded == limitExceeded)&&(identical(other.ipType, ipType) || other.ipType == ipType)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,config,hash,exitIp,limitExceeded,ipType,country,city,type);

@override
String toString() {
  return 'VpnConfig(id: $id, config: $config, hash: $hash, exitIp: $exitIp, limitExceeded: $limitExceeded, ipType: $ipType, country: $country, city: $city, type: $type)';
}


}

/// @nodoc
abstract mixin class _$VpnConfigCopyWith<$Res> implements $VpnConfigCopyWith<$Res> {
  factory _$VpnConfigCopyWith(_VpnConfig value, $Res Function(_VpnConfig) _then) = __$VpnConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String config, String hash, String? exitIp, bool? limitExceeded, String? ipType, String? country, String? city, String? type
});




}
/// @nodoc
class __$VpnConfigCopyWithImpl<$Res>
    implements _$VpnConfigCopyWith<$Res> {
  __$VpnConfigCopyWithImpl(this._self, this._then);

  final _VpnConfig _self;
  final $Res Function(_VpnConfig) _then;

/// Create a copy of VpnConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? config = null,Object? hash = null,Object? exitIp = freezed,Object? limitExceeded = freezed,Object? ipType = freezed,Object? country = freezed,Object? city = freezed,Object? type = freezed,}) {
  return _then(_VpnConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as String,hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,exitIp: freezed == exitIp ? _self.exitIp : exitIp // ignore: cast_nullable_to_non_nullable
as String?,limitExceeded: freezed == limitExceeded ? _self.limitExceeded : limitExceeded // ignore: cast_nullable_to_non_nullable
as bool?,ipType: freezed == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
