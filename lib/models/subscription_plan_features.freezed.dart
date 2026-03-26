// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_plan_features.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionPlanFeatures {

 String get name; Set<String> get planIds; Set<String> get previewFeatures; Map<String, dynamic> get detailedFeatures;
/// Create a copy of SubscriptionPlanFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionPlanFeaturesCopyWith<SubscriptionPlanFeatures> get copyWith => _$SubscriptionPlanFeaturesCopyWithImpl<SubscriptionPlanFeatures>(this as SubscriptionPlanFeatures, _$identity);

  /// Serializes this SubscriptionPlanFeatures to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionPlanFeatures&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.planIds, planIds)&&const DeepCollectionEquality().equals(other.previewFeatures, previewFeatures)&&const DeepCollectionEquality().equals(other.detailedFeatures, detailedFeatures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(planIds),const DeepCollectionEquality().hash(previewFeatures),const DeepCollectionEquality().hash(detailedFeatures));

@override
String toString() {
  return 'SubscriptionPlanFeatures(name: $name, planIds: $planIds, previewFeatures: $previewFeatures, detailedFeatures: $detailedFeatures)';
}


}

/// @nodoc
abstract mixin class $SubscriptionPlanFeaturesCopyWith<$Res>  {
  factory $SubscriptionPlanFeaturesCopyWith(SubscriptionPlanFeatures value, $Res Function(SubscriptionPlanFeatures) _then) = _$SubscriptionPlanFeaturesCopyWithImpl;
@useResult
$Res call({
 String name, Set<String> planIds, Set<String> previewFeatures, Map<String, dynamic> detailedFeatures
});




}
/// @nodoc
class _$SubscriptionPlanFeaturesCopyWithImpl<$Res>
    implements $SubscriptionPlanFeaturesCopyWith<$Res> {
  _$SubscriptionPlanFeaturesCopyWithImpl(this._self, this._then);

  final SubscriptionPlanFeatures _self;
  final $Res Function(SubscriptionPlanFeatures) _then;

/// Create a copy of SubscriptionPlanFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? planIds = null,Object? previewFeatures = null,Object? detailedFeatures = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,planIds: null == planIds ? _self.planIds : planIds // ignore: cast_nullable_to_non_nullable
as Set<String>,previewFeatures: null == previewFeatures ? _self.previewFeatures : previewFeatures // ignore: cast_nullable_to_non_nullable
as Set<String>,detailedFeatures: null == detailedFeatures ? _self.detailedFeatures : detailedFeatures // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionPlanFeatures].
extension SubscriptionPlanFeaturesPatterns on SubscriptionPlanFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionPlanFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionPlanFeatures value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionPlanFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Set<String> planIds,  Set<String> previewFeatures,  Map<String, dynamic> detailedFeatures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures() when $default != null:
return $default(_that.name,_that.planIds,_that.previewFeatures,_that.detailedFeatures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Set<String> planIds,  Set<String> previewFeatures,  Map<String, dynamic> detailedFeatures)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures():
return $default(_that.name,_that.planIds,_that.previewFeatures,_that.detailedFeatures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Set<String> planIds,  Set<String> previewFeatures,  Map<String, dynamic> detailedFeatures)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlanFeatures() when $default != null:
return $default(_that.name,_that.planIds,_that.previewFeatures,_that.detailedFeatures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionPlanFeatures extends SubscriptionPlanFeatures {
   _SubscriptionPlanFeatures({required this.name, required final  Set<String> planIds, required final  Set<String> previewFeatures, required final  Map<String, dynamic> detailedFeatures}): _planIds = planIds,_previewFeatures = previewFeatures,_detailedFeatures = detailedFeatures,super._();
  factory _SubscriptionPlanFeatures.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFeaturesFromJson(json);

@override final  String name;
 final  Set<String> _planIds;
@override Set<String> get planIds {
  if (_planIds is EqualUnmodifiableSetView) return _planIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_planIds);
}

 final  Set<String> _previewFeatures;
@override Set<String> get previewFeatures {
  if (_previewFeatures is EqualUnmodifiableSetView) return _previewFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_previewFeatures);
}

 final  Map<String, dynamic> _detailedFeatures;
@override Map<String, dynamic> get detailedFeatures {
  if (_detailedFeatures is EqualUnmodifiableMapView) return _detailedFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_detailedFeatures);
}


/// Create a copy of SubscriptionPlanFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionPlanFeaturesCopyWith<_SubscriptionPlanFeatures> get copyWith => __$SubscriptionPlanFeaturesCopyWithImpl<_SubscriptionPlanFeatures>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionPlanFeaturesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionPlanFeatures&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._planIds, _planIds)&&const DeepCollectionEquality().equals(other._previewFeatures, _previewFeatures)&&const DeepCollectionEquality().equals(other._detailedFeatures, _detailedFeatures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_planIds),const DeepCollectionEquality().hash(_previewFeatures),const DeepCollectionEquality().hash(_detailedFeatures));

@override
String toString() {
  return 'SubscriptionPlanFeatures(name: $name, planIds: $planIds, previewFeatures: $previewFeatures, detailedFeatures: $detailedFeatures)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionPlanFeaturesCopyWith<$Res> implements $SubscriptionPlanFeaturesCopyWith<$Res> {
  factory _$SubscriptionPlanFeaturesCopyWith(_SubscriptionPlanFeatures value, $Res Function(_SubscriptionPlanFeatures) _then) = __$SubscriptionPlanFeaturesCopyWithImpl;
@override @useResult
$Res call({
 String name, Set<String> planIds, Set<String> previewFeatures, Map<String, dynamic> detailedFeatures
});




}
/// @nodoc
class __$SubscriptionPlanFeaturesCopyWithImpl<$Res>
    implements _$SubscriptionPlanFeaturesCopyWith<$Res> {
  __$SubscriptionPlanFeaturesCopyWithImpl(this._self, this._then);

  final _SubscriptionPlanFeatures _self;
  final $Res Function(_SubscriptionPlanFeatures) _then;

/// Create a copy of SubscriptionPlanFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? planIds = null,Object? previewFeatures = null,Object? detailedFeatures = null,}) {
  return _then(_SubscriptionPlanFeatures(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,planIds: null == planIds ? _self._planIds : planIds // ignore: cast_nullable_to_non_nullable
as Set<String>,previewFeatures: null == previewFeatures ? _self._previewFeatures : previewFeatures // ignore: cast_nullable_to_non_nullable
as Set<String>,detailedFeatures: null == detailedFeatures ? _self._detailedFeatures : detailedFeatures // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
