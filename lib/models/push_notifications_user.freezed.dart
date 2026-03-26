// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notifications_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushNotificationsUser {

 String? get pushNotificationsId; String? get userId; Map<String, String>? get tags;
/// Create a copy of PushNotificationsUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushNotificationsUserCopyWith<PushNotificationsUser> get copyWith => _$PushNotificationsUserCopyWithImpl<PushNotificationsUser>(this as PushNotificationsUser, _$identity);

  /// Serializes this PushNotificationsUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushNotificationsUser&&(identical(other.pushNotificationsId, pushNotificationsId) || other.pushNotificationsId == pushNotificationsId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pushNotificationsId,userId,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'PushNotificationsUser(pushNotificationsId: $pushNotificationsId, userId: $userId, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $PushNotificationsUserCopyWith<$Res>  {
  factory $PushNotificationsUserCopyWith(PushNotificationsUser value, $Res Function(PushNotificationsUser) _then) = _$PushNotificationsUserCopyWithImpl;
@useResult
$Res call({
 String? pushNotificationsId, String? userId, Map<String, String>? tags
});




}
/// @nodoc
class _$PushNotificationsUserCopyWithImpl<$Res>
    implements $PushNotificationsUserCopyWith<$Res> {
  _$PushNotificationsUserCopyWithImpl(this._self, this._then);

  final PushNotificationsUser _self;
  final $Res Function(PushNotificationsUser) _then;

/// Create a copy of PushNotificationsUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pushNotificationsId = freezed,Object? userId = freezed,Object? tags = freezed,}) {
  return _then(_self.copyWith(
pushNotificationsId: freezed == pushNotificationsId ? _self.pushNotificationsId : pushNotificationsId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushNotificationsUser].
extension PushNotificationsUserPatterns on PushNotificationsUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushNotificationsUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushNotificationsUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushNotificationsUser value)  $default,){
final _that = this;
switch (_that) {
case _PushNotificationsUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushNotificationsUser value)?  $default,){
final _that = this;
switch (_that) {
case _PushNotificationsUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? pushNotificationsId,  String? userId,  Map<String, String>? tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushNotificationsUser() when $default != null:
return $default(_that.pushNotificationsId,_that.userId,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? pushNotificationsId,  String? userId,  Map<String, String>? tags)  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsUser():
return $default(_that.pushNotificationsId,_that.userId,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? pushNotificationsId,  String? userId,  Map<String, String>? tags)?  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsUser() when $default != null:
return $default(_that.pushNotificationsId,_that.userId,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushNotificationsUser implements PushNotificationsUser {
   _PushNotificationsUser({required this.pushNotificationsId, required this.userId, required final  Map<String, String>? tags}): _tags = tags;
  factory _PushNotificationsUser.fromJson(Map<String, dynamic> json) => _$PushNotificationsUserFromJson(json);

@override final  String? pushNotificationsId;
@override final  String? userId;
 final  Map<String, String>? _tags;
@override Map<String, String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableMapView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PushNotificationsUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushNotificationsUserCopyWith<_PushNotificationsUser> get copyWith => __$PushNotificationsUserCopyWithImpl<_PushNotificationsUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushNotificationsUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushNotificationsUser&&(identical(other.pushNotificationsId, pushNotificationsId) || other.pushNotificationsId == pushNotificationsId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pushNotificationsId,userId,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'PushNotificationsUser(pushNotificationsId: $pushNotificationsId, userId: $userId, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$PushNotificationsUserCopyWith<$Res> implements $PushNotificationsUserCopyWith<$Res> {
  factory _$PushNotificationsUserCopyWith(_PushNotificationsUser value, $Res Function(_PushNotificationsUser) _then) = __$PushNotificationsUserCopyWithImpl;
@override @useResult
$Res call({
 String? pushNotificationsId, String? userId, Map<String, String>? tags
});




}
/// @nodoc
class __$PushNotificationsUserCopyWithImpl<$Res>
    implements _$PushNotificationsUserCopyWith<$Res> {
  __$PushNotificationsUserCopyWithImpl(this._self, this._then);

  final _PushNotificationsUser _self;
  final $Res Function(_PushNotificationsUser) _then;

/// Create a copy of PushNotificationsUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pushNotificationsId = freezed,Object? userId = freezed,Object? tags = freezed,}) {
  return _then(_PushNotificationsUser(
pushNotificationsId: freezed == pushNotificationsId ? _self.pushNotificationsId : pushNotificationsId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
