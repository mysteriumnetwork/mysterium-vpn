// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extra_duration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtraDuration {

 int get amount; ExtraDurationUnit get unit;
/// Create a copy of ExtraDuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtraDurationCopyWith<ExtraDuration> get copyWith => _$ExtraDurationCopyWithImpl<ExtraDuration>(this as ExtraDuration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtraDuration&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,amount,unit);

@override
String toString() {
  return 'ExtraDuration(amount: $amount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $ExtraDurationCopyWith<$Res>  {
  factory $ExtraDurationCopyWith(ExtraDuration value, $Res Function(ExtraDuration) _then) = _$ExtraDurationCopyWithImpl;
@useResult
$Res call({
 int amount, ExtraDurationUnit unit
});




}
/// @nodoc
class _$ExtraDurationCopyWithImpl<$Res>
    implements $ExtraDurationCopyWith<$Res> {
  _$ExtraDurationCopyWithImpl(this._self, this._then);

  final ExtraDuration _self;
  final $Res Function(ExtraDuration) _then;

/// Create a copy of ExtraDuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? unit = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ExtraDurationUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtraDuration].
extension ExtraDurationPatterns on ExtraDuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtraDuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtraDuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtraDuration value)  $default,){
final _that = this;
switch (_that) {
case _ExtraDuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtraDuration value)?  $default,){
final _that = this;
switch (_that) {
case _ExtraDuration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  ExtraDurationUnit unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtraDuration() when $default != null:
return $default(_that.amount,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  ExtraDurationUnit unit)  $default,) {final _that = this;
switch (_that) {
case _ExtraDuration():
return $default(_that.amount,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  ExtraDurationUnit unit)?  $default,) {final _that = this;
switch (_that) {
case _ExtraDuration() when $default != null:
return $default(_that.amount,_that.unit);case _:
  return null;

}
}

}

/// @nodoc


class _ExtraDuration implements ExtraDuration {
   _ExtraDuration({required this.amount, required this.unit});
  

@override final  int amount;
@override final  ExtraDurationUnit unit;

/// Create a copy of ExtraDuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtraDurationCopyWith<_ExtraDuration> get copyWith => __$ExtraDurationCopyWithImpl<_ExtraDuration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtraDuration&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,amount,unit);

@override
String toString() {
  return 'ExtraDuration(amount: $amount, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$ExtraDurationCopyWith<$Res> implements $ExtraDurationCopyWith<$Res> {
  factory _$ExtraDurationCopyWith(_ExtraDuration value, $Res Function(_ExtraDuration) _then) = __$ExtraDurationCopyWithImpl;
@override @useResult
$Res call({
 int amount, ExtraDurationUnit unit
});




}
/// @nodoc
class __$ExtraDurationCopyWithImpl<$Res>
    implements _$ExtraDurationCopyWith<$Res> {
  __$ExtraDurationCopyWithImpl(this._self, this._then);

  final _ExtraDuration _self;
  final $Res Function(_ExtraDuration) _then;

/// Create a copy of ExtraDuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? unit = null,}) {
  return _then(_ExtraDuration(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ExtraDurationUnit,
  ));
}


}

// dart format on
