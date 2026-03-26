// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushNotification {

 String? get id; String? get title; String? get body; String? get launchUrl; Map<String, dynamic>? get additionalData; Map<String, dynamic>? get rawPayload; String? get category;
/// Create a copy of PushNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushNotificationCopyWith<PushNotification> get copyWith => _$PushNotificationCopyWithImpl<PushNotification>(this as PushNotification, _$identity);

  /// Serializes this PushNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.launchUrl, launchUrl) || other.launchUrl == launchUrl)&&const DeepCollectionEquality().equals(other.additionalData, additionalData)&&const DeepCollectionEquality().equals(other.rawPayload, rawPayload)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,launchUrl,const DeepCollectionEquality().hash(additionalData),const DeepCollectionEquality().hash(rawPayload),category);

@override
String toString() {
  return 'PushNotification(id: $id, title: $title, body: $body, launchUrl: $launchUrl, additionalData: $additionalData, rawPayload: $rawPayload, category: $category)';
}


}

/// @nodoc
abstract mixin class $PushNotificationCopyWith<$Res>  {
  factory $PushNotificationCopyWith(PushNotification value, $Res Function(PushNotification) _then) = _$PushNotificationCopyWithImpl;
@useResult
$Res call({
 String? id, String? title, String? body, String? launchUrl, Map<String, dynamic>? additionalData, Map<String, dynamic>? rawPayload, String? category
});




}
/// @nodoc
class _$PushNotificationCopyWithImpl<$Res>
    implements $PushNotificationCopyWith<$Res> {
  _$PushNotificationCopyWithImpl(this._self, this._then);

  final PushNotification _self;
  final $Res Function(PushNotification) _then;

/// Create a copy of PushNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? launchUrl = freezed,Object? additionalData = freezed,Object? rawPayload = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,launchUrl: freezed == launchUrl ? _self.launchUrl : launchUrl // ignore: cast_nullable_to_non_nullable
as String?,additionalData: freezed == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rawPayload: freezed == rawPayload ? _self.rawPayload : rawPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushNotification].
extension PushNotificationPatterns on PushNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushNotification value)  $default,){
final _that = this;
switch (_that) {
case _PushNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushNotification value)?  $default,){
final _that = this;
switch (_that) {
case _PushNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? title,  String? body,  String? launchUrl,  Map<String, dynamic>? additionalData,  Map<String, dynamic>? rawPayload,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.launchUrl,_that.additionalData,_that.rawPayload,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? title,  String? body,  String? launchUrl,  Map<String, dynamic>? additionalData,  Map<String, dynamic>? rawPayload,  String? category)  $default,) {final _that = this;
switch (_that) {
case _PushNotification():
return $default(_that.id,_that.title,_that.body,_that.launchUrl,_that.additionalData,_that.rawPayload,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? title,  String? body,  String? launchUrl,  Map<String, dynamic>? additionalData,  Map<String, dynamic>? rawPayload,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _PushNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.launchUrl,_that.additionalData,_that.rawPayload,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushNotification implements PushNotification {
   _PushNotification({required this.id, required this.title, required this.body, required this.launchUrl, required final  Map<String, dynamic>? additionalData, required final  Map<String, dynamic>? rawPayload, required this.category}): _additionalData = additionalData,_rawPayload = rawPayload;
  factory _PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);

@override final  String? id;
@override final  String? title;
@override final  String? body;
@override final  String? launchUrl;
 final  Map<String, dynamic>? _additionalData;
@override Map<String, dynamic>? get additionalData {
  final value = _additionalData;
  if (value == null) return null;
  if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _rawPayload;
@override Map<String, dynamic>? get rawPayload {
  final value = _rawPayload;
  if (value == null) return null;
  if (_rawPayload is EqualUnmodifiableMapView) return _rawPayload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? category;

/// Create a copy of PushNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushNotificationCopyWith<_PushNotification> get copyWith => __$PushNotificationCopyWithImpl<_PushNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.launchUrl, launchUrl) || other.launchUrl == launchUrl)&&const DeepCollectionEquality().equals(other._additionalData, _additionalData)&&const DeepCollectionEquality().equals(other._rawPayload, _rawPayload)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,launchUrl,const DeepCollectionEquality().hash(_additionalData),const DeepCollectionEquality().hash(_rawPayload),category);

@override
String toString() {
  return 'PushNotification(id: $id, title: $title, body: $body, launchUrl: $launchUrl, additionalData: $additionalData, rawPayload: $rawPayload, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PushNotificationCopyWith<$Res> implements $PushNotificationCopyWith<$Res> {
  factory _$PushNotificationCopyWith(_PushNotification value, $Res Function(_PushNotification) _then) = __$PushNotificationCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? title, String? body, String? launchUrl, Map<String, dynamic>? additionalData, Map<String, dynamic>? rawPayload, String? category
});




}
/// @nodoc
class __$PushNotificationCopyWithImpl<$Res>
    implements _$PushNotificationCopyWith<$Res> {
  __$PushNotificationCopyWithImpl(this._self, this._then);

  final _PushNotification _self;
  final $Res Function(_PushNotification) _then;

/// Create a copy of PushNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? launchUrl = freezed,Object? additionalData = freezed,Object? rawPayload = freezed,Object? category = freezed,}) {
  return _then(_PushNotification(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,launchUrl: freezed == launchUrl ? _self.launchUrl : launchUrl // ignore: cast_nullable_to_non_nullable
as String?,additionalData: freezed == additionalData ? _self._additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,rawPayload: freezed == rawPayload ? _self._rawPayload : rawPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
