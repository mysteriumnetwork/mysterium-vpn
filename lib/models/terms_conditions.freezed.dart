// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_conditions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermsAndConditions {

 String get content; String get version;
/// Create a copy of TermsAndConditions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsAndConditionsCopyWith<TermsAndConditions> get copyWith => _$TermsAndConditionsCopyWithImpl<TermsAndConditions>(this as TermsAndConditions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsAndConditions&&(identical(other.content, content) || other.content == content)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,content,version);

@override
String toString() {
  return 'TermsAndConditions(content: $content, version: $version)';
}


}

/// @nodoc
abstract mixin class $TermsAndConditionsCopyWith<$Res>  {
  factory $TermsAndConditionsCopyWith(TermsAndConditions value, $Res Function(TermsAndConditions) _then) = _$TermsAndConditionsCopyWithImpl;
@useResult
$Res call({
 String content, String version
});




}
/// @nodoc
class _$TermsAndConditionsCopyWithImpl<$Res>
    implements $TermsAndConditionsCopyWith<$Res> {
  _$TermsAndConditionsCopyWithImpl(this._self, this._then);

  final TermsAndConditions _self;
  final $Res Function(TermsAndConditions) _then;

/// Create a copy of TermsAndConditions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? version = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TermsAndConditions].
extension TermsAndConditionsPatterns on TermsAndConditions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermsAndConditions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermsAndConditions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermsAndConditions value)  $default,){
final _that = this;
switch (_that) {
case _TermsAndConditions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermsAndConditions value)?  $default,){
final _that = this;
switch (_that) {
case _TermsAndConditions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermsAndConditions() when $default != null:
return $default(_that.content,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String version)  $default,) {final _that = this;
switch (_that) {
case _TermsAndConditions():
return $default(_that.content,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String version)?  $default,) {final _that = this;
switch (_that) {
case _TermsAndConditions() when $default != null:
return $default(_that.content,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _TermsAndConditions implements TermsAndConditions {
  const _TermsAndConditions({required this.content, required this.version});
  

@override final  String content;
@override final  String version;

/// Create a copy of TermsAndConditions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermsAndConditionsCopyWith<_TermsAndConditions> get copyWith => __$TermsAndConditionsCopyWithImpl<_TermsAndConditions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermsAndConditions&&(identical(other.content, content) || other.content == content)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,content,version);

@override
String toString() {
  return 'TermsAndConditions(content: $content, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TermsAndConditionsCopyWith<$Res> implements $TermsAndConditionsCopyWith<$Res> {
  factory _$TermsAndConditionsCopyWith(_TermsAndConditions value, $Res Function(_TermsAndConditions) _then) = __$TermsAndConditionsCopyWithImpl;
@override @useResult
$Res call({
 String content, String version
});




}
/// @nodoc
class __$TermsAndConditionsCopyWithImpl<$Res>
    implements _$TermsAndConditionsCopyWith<$Res> {
  __$TermsAndConditionsCopyWithImpl(this._self, this._then);

  final _TermsAndConditions _self;
  final $Res Function(_TermsAndConditions) _then;

/// Create a copy of TermsAndConditions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? version = null,}) {
  return _then(_TermsAndConditions(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
