// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tooltip_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TooltipContent implements DiagnosticableTreeMixin {

 String get title; String get description; VoidCallback get onActionPressed; String get actionLabel;
/// Create a copy of TooltipContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooltipContentCopyWith<TooltipContent> get copyWith => _$TooltipContentCopyWithImpl<TooltipContent>(this as TooltipContent, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TooltipContent'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('onActionPressed', onActionPressed))..add(DiagnosticsProperty('actionLabel', actionLabel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooltipContent&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.onActionPressed, onActionPressed) || other.onActionPressed == onActionPressed)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,onActionPressed,actionLabel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TooltipContent(title: $title, description: $description, onActionPressed: $onActionPressed, actionLabel: $actionLabel)';
}


}

/// @nodoc
abstract mixin class $TooltipContentCopyWith<$Res>  {
  factory $TooltipContentCopyWith(TooltipContent value, $Res Function(TooltipContent) _then) = _$TooltipContentCopyWithImpl;
@useResult
$Res call({
 String title, String description, VoidCallback onActionPressed, String actionLabel
});




}
/// @nodoc
class _$TooltipContentCopyWithImpl<$Res>
    implements $TooltipContentCopyWith<$Res> {
  _$TooltipContentCopyWithImpl(this._self, this._then);

  final TooltipContent _self;
  final $Res Function(TooltipContent) _then;

/// Create a copy of TooltipContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? onActionPressed = null,Object? actionLabel = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,onActionPressed: null == onActionPressed ? _self.onActionPressed : onActionPressed // ignore: cast_nullable_to_non_nullable
as VoidCallback,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TooltipContent].
extension TooltipContentPatterns on TooltipContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TooltipContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TooltipContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TooltipContent value)  $default,){
final _that = this;
switch (_that) {
case _TooltipContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TooltipContent value)?  $default,){
final _that = this;
switch (_that) {
case _TooltipContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  VoidCallback onActionPressed,  String actionLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TooltipContent() when $default != null:
return $default(_that.title,_that.description,_that.onActionPressed,_that.actionLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  VoidCallback onActionPressed,  String actionLabel)  $default,) {final _that = this;
switch (_that) {
case _TooltipContent():
return $default(_that.title,_that.description,_that.onActionPressed,_that.actionLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  VoidCallback onActionPressed,  String actionLabel)?  $default,) {final _that = this;
switch (_that) {
case _TooltipContent() when $default != null:
return $default(_that.title,_that.description,_that.onActionPressed,_that.actionLabel);case _:
  return null;

}
}

}

/// @nodoc


class _TooltipContent with DiagnosticableTreeMixin implements TooltipContent {
   _TooltipContent({required this.title, required this.description, required this.onActionPressed, this.actionLabel = LocaleKeys.continueBtn});
  

@override final  String title;
@override final  String description;
@override final  VoidCallback onActionPressed;
@override@JsonKey() final  String actionLabel;

/// Create a copy of TooltipContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TooltipContentCopyWith<_TooltipContent> get copyWith => __$TooltipContentCopyWithImpl<_TooltipContent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TooltipContent'))
    ..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('onActionPressed', onActionPressed))..add(DiagnosticsProperty('actionLabel', actionLabel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TooltipContent&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.onActionPressed, onActionPressed) || other.onActionPressed == onActionPressed)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,onActionPressed,actionLabel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TooltipContent(title: $title, description: $description, onActionPressed: $onActionPressed, actionLabel: $actionLabel)';
}


}

/// @nodoc
abstract mixin class _$TooltipContentCopyWith<$Res> implements $TooltipContentCopyWith<$Res> {
  factory _$TooltipContentCopyWith(_TooltipContent value, $Res Function(_TooltipContent) _then) = __$TooltipContentCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, VoidCallback onActionPressed, String actionLabel
});




}
/// @nodoc
class __$TooltipContentCopyWithImpl<$Res>
    implements _$TooltipContentCopyWith<$Res> {
  __$TooltipContentCopyWithImpl(this._self, this._then);

  final _TooltipContent _self;
  final $Res Function(_TooltipContent) _then;

/// Create a copy of TooltipContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? onActionPressed = null,Object? actionLabel = null,}) {
  return _then(_TooltipContent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,onActionPressed: null == onActionPressed ? _self.onActionPressed : onActionPressed // ignore: cast_nullable_to_non_nullable
as VoidCallback,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
