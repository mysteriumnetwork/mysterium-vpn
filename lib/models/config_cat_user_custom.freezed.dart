// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_cat_user_custom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfigCatUserCustom {

 String get platform; String get version; String? get city; String? get subscriptionSource; String? get subscriptionPlan; String? get expirationDate; String? get subscriptionDuration; String? get recurring;
/// Create a copy of ConfigCatUserCustom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigCatUserCustomCopyWith<ConfigCatUserCustom> get copyWith => _$ConfigCatUserCustomCopyWithImpl<ConfigCatUserCustom>(this as ConfigCatUserCustom, _$identity);

  /// Serializes this ConfigCatUserCustom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigCatUserCustom&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.version, version) || other.version == version)&&(identical(other.city, city) || other.city == city)&&(identical(other.subscriptionSource, subscriptionSource) || other.subscriptionSource == subscriptionSource)&&(identical(other.subscriptionPlan, subscriptionPlan) || other.subscriptionPlan == subscriptionPlan)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.subscriptionDuration, subscriptionDuration) || other.subscriptionDuration == subscriptionDuration)&&(identical(other.recurring, recurring) || other.recurring == recurring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,version,city,subscriptionSource,subscriptionPlan,expirationDate,subscriptionDuration,recurring);

@override
String toString() {
  return 'ConfigCatUserCustom(platform: $platform, version: $version, city: $city, subscriptionSource: $subscriptionSource, subscriptionPlan: $subscriptionPlan, expirationDate: $expirationDate, subscriptionDuration: $subscriptionDuration, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class $ConfigCatUserCustomCopyWith<$Res>  {
  factory $ConfigCatUserCustomCopyWith(ConfigCatUserCustom value, $Res Function(ConfigCatUserCustom) _then) = _$ConfigCatUserCustomCopyWithImpl;
@useResult
$Res call({
 String platform, String version, String? city, String? subscriptionSource, String? subscriptionPlan, String? expirationDate, String? subscriptionDuration, String? recurring
});




}
/// @nodoc
class _$ConfigCatUserCustomCopyWithImpl<$Res>
    implements $ConfigCatUserCustomCopyWith<$Res> {
  _$ConfigCatUserCustomCopyWithImpl(this._self, this._then);

  final ConfigCatUserCustom _self;
  final $Res Function(ConfigCatUserCustom) _then;

/// Create a copy of ConfigCatUserCustom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = null,Object? version = null,Object? city = freezed,Object? subscriptionSource = freezed,Object? subscriptionPlan = freezed,Object? expirationDate = freezed,Object? subscriptionDuration = freezed,Object? recurring = freezed,}) {
  return _then(_self.copyWith(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,subscriptionSource: freezed == subscriptionSource ? _self.subscriptionSource : subscriptionSource // ignore: cast_nullable_to_non_nullable
as String?,subscriptionPlan: freezed == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as String?,subscriptionDuration: freezed == subscriptionDuration ? _self.subscriptionDuration : subscriptionDuration // ignore: cast_nullable_to_non_nullable
as String?,recurring: freezed == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfigCatUserCustom].
extension ConfigCatUserCustomPatterns on ConfigCatUserCustom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfigCatUserCustom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfigCatUserCustom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfigCatUserCustom value)  $default,){
final _that = this;
switch (_that) {
case _ConfigCatUserCustom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfigCatUserCustom value)?  $default,){
final _that = this;
switch (_that) {
case _ConfigCatUserCustom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String platform,  String version,  String? city,  String? subscriptionSource,  String? subscriptionPlan,  String? expirationDate,  String? subscriptionDuration,  String? recurring)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfigCatUserCustom() when $default != null:
return $default(_that.platform,_that.version,_that.city,_that.subscriptionSource,_that.subscriptionPlan,_that.expirationDate,_that.subscriptionDuration,_that.recurring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String platform,  String version,  String? city,  String? subscriptionSource,  String? subscriptionPlan,  String? expirationDate,  String? subscriptionDuration,  String? recurring)  $default,) {final _that = this;
switch (_that) {
case _ConfigCatUserCustom():
return $default(_that.platform,_that.version,_that.city,_that.subscriptionSource,_that.subscriptionPlan,_that.expirationDate,_that.subscriptionDuration,_that.recurring);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String platform,  String version,  String? city,  String? subscriptionSource,  String? subscriptionPlan,  String? expirationDate,  String? subscriptionDuration,  String? recurring)?  $default,) {final _that = this;
switch (_that) {
case _ConfigCatUserCustom() when $default != null:
return $default(_that.platform,_that.version,_that.city,_that.subscriptionSource,_that.subscriptionPlan,_that.expirationDate,_that.subscriptionDuration,_that.recurring);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfigCatUserCustom extends ConfigCatUserCustom {
  const _ConfigCatUserCustom({required this.platform, required this.version, required this.city, required this.subscriptionSource, required this.subscriptionPlan, required this.expirationDate, required this.subscriptionDuration, required this.recurring}): super._();
  factory _ConfigCatUserCustom.fromJson(Map<String, dynamic> json) => _$ConfigCatUserCustomFromJson(json);

@override final  String platform;
@override final  String version;
@override final  String? city;
@override final  String? subscriptionSource;
@override final  String? subscriptionPlan;
@override final  String? expirationDate;
@override final  String? subscriptionDuration;
@override final  String? recurring;

/// Create a copy of ConfigCatUserCustom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigCatUserCustomCopyWith<_ConfigCatUserCustom> get copyWith => __$ConfigCatUserCustomCopyWithImpl<_ConfigCatUserCustom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigCatUserCustomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigCatUserCustom&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.version, version) || other.version == version)&&(identical(other.city, city) || other.city == city)&&(identical(other.subscriptionSource, subscriptionSource) || other.subscriptionSource == subscriptionSource)&&(identical(other.subscriptionPlan, subscriptionPlan) || other.subscriptionPlan == subscriptionPlan)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.subscriptionDuration, subscriptionDuration) || other.subscriptionDuration == subscriptionDuration)&&(identical(other.recurring, recurring) || other.recurring == recurring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,version,city,subscriptionSource,subscriptionPlan,expirationDate,subscriptionDuration,recurring);

@override
String toString() {
  return 'ConfigCatUserCustom(platform: $platform, version: $version, city: $city, subscriptionSource: $subscriptionSource, subscriptionPlan: $subscriptionPlan, expirationDate: $expirationDate, subscriptionDuration: $subscriptionDuration, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class _$ConfigCatUserCustomCopyWith<$Res> implements $ConfigCatUserCustomCopyWith<$Res> {
  factory _$ConfigCatUserCustomCopyWith(_ConfigCatUserCustom value, $Res Function(_ConfigCatUserCustom) _then) = __$ConfigCatUserCustomCopyWithImpl;
@override @useResult
$Res call({
 String platform, String version, String? city, String? subscriptionSource, String? subscriptionPlan, String? expirationDate, String? subscriptionDuration, String? recurring
});




}
/// @nodoc
class __$ConfigCatUserCustomCopyWithImpl<$Res>
    implements _$ConfigCatUserCustomCopyWith<$Res> {
  __$ConfigCatUserCustomCopyWithImpl(this._self, this._then);

  final _ConfigCatUserCustom _self;
  final $Res Function(_ConfigCatUserCustom) _then;

/// Create a copy of ConfigCatUserCustom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = null,Object? version = null,Object? city = freezed,Object? subscriptionSource = freezed,Object? subscriptionPlan = freezed,Object? expirationDate = freezed,Object? subscriptionDuration = freezed,Object? recurring = freezed,}) {
  return _then(_ConfigCatUserCustom(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,subscriptionSource: freezed == subscriptionSource ? _self.subscriptionSource : subscriptionSource // ignore: cast_nullable_to_non_nullable
as String?,subscriptionPlan: freezed == subscriptionPlan ? _self.subscriptionPlan : subscriptionPlan // ignore: cast_nullable_to_non_nullable
as String?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as String?,subscriptionDuration: freezed == subscriptionDuration ? _self.subscriptionDuration : subscriptionDuration // ignore: cast_nullable_to_non_nullable
as String?,recurring: freezed == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
