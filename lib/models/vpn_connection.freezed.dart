// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VpnConnection {

 String get connectionIP; VPNLocation get location; String? get sessionId; String? get hash;
/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VpnConnectionCopyWith<VpnConnection> get copyWith => _$VpnConnectionCopyWithImpl<VpnConnection>(this as VpnConnection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VpnConnection&&(identical(other.connectionIP, connectionIP) || other.connectionIP == connectionIP)&&(identical(other.location, location) || other.location == location)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.hash, hash) || other.hash == hash));
}


@override
int get hashCode => Object.hash(runtimeType,connectionIP,location,sessionId,hash);

@override
String toString() {
  return 'VpnConnection(connectionIP: $connectionIP, location: $location, sessionId: $sessionId, hash: $hash)';
}


}

/// @nodoc
abstract mixin class $VpnConnectionCopyWith<$Res>  {
  factory $VpnConnectionCopyWith(VpnConnection value, $Res Function(VpnConnection) _then) = _$VpnConnectionCopyWithImpl;
@useResult
$Res call({
 String connectionIP, VPNLocation location, String? sessionId, String? hash
});


$VPNLocationCopyWith<$Res> get location;

}
/// @nodoc
class _$VpnConnectionCopyWithImpl<$Res>
    implements $VpnConnectionCopyWith<$Res> {
  _$VpnConnectionCopyWithImpl(this._self, this._then);

  final VpnConnection _self;
  final $Res Function(VpnConnection) _then;

/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectionIP = null,Object? location = null,Object? sessionId = freezed,Object? hash = freezed,}) {
  return _then(_self.copyWith(
connectionIP: null == connectionIP ? _self.connectionIP : connectionIP // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as VPNLocation,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,hash: freezed == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VPNLocationCopyWith<$Res> get location {
  
  return $VPNLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [VpnConnection].
extension VpnConnectionPatterns on VpnConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VpnConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VpnConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VpnConnection value)  $default,){
final _that = this;
switch (_that) {
case _VpnConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VpnConnection value)?  $default,){
final _that = this;
switch (_that) {
case _VpnConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String connectionIP,  VPNLocation location,  String? sessionId,  String? hash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VpnConnection() when $default != null:
return $default(_that.connectionIP,_that.location,_that.sessionId,_that.hash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String connectionIP,  VPNLocation location,  String? sessionId,  String? hash)  $default,) {final _that = this;
switch (_that) {
case _VpnConnection():
return $default(_that.connectionIP,_that.location,_that.sessionId,_that.hash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String connectionIP,  VPNLocation location,  String? sessionId,  String? hash)?  $default,) {final _that = this;
switch (_that) {
case _VpnConnection() when $default != null:
return $default(_that.connectionIP,_that.location,_that.sessionId,_that.hash);case _:
  return null;

}
}

}

/// @nodoc


class _VpnConnection extends VpnConnection {
  const _VpnConnection({required this.connectionIP, required this.location, this.sessionId, this.hash}): super._();
  

@override final  String connectionIP;
@override final  VPNLocation location;
@override final  String? sessionId;
@override final  String? hash;

/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VpnConnectionCopyWith<_VpnConnection> get copyWith => __$VpnConnectionCopyWithImpl<_VpnConnection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VpnConnection&&(identical(other.connectionIP, connectionIP) || other.connectionIP == connectionIP)&&(identical(other.location, location) || other.location == location)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.hash, hash) || other.hash == hash));
}


@override
int get hashCode => Object.hash(runtimeType,connectionIP,location,sessionId,hash);

@override
String toString() {
  return 'VpnConnection(connectionIP: $connectionIP, location: $location, sessionId: $sessionId, hash: $hash)';
}


}

/// @nodoc
abstract mixin class _$VpnConnectionCopyWith<$Res> implements $VpnConnectionCopyWith<$Res> {
  factory _$VpnConnectionCopyWith(_VpnConnection value, $Res Function(_VpnConnection) _then) = __$VpnConnectionCopyWithImpl;
@override @useResult
$Res call({
 String connectionIP, VPNLocation location, String? sessionId, String? hash
});


@override $VPNLocationCopyWith<$Res> get location;

}
/// @nodoc
class __$VpnConnectionCopyWithImpl<$Res>
    implements _$VpnConnectionCopyWith<$Res> {
  __$VpnConnectionCopyWithImpl(this._self, this._then);

  final _VpnConnection _self;
  final $Res Function(_VpnConnection) _then;

/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionIP = null,Object? location = null,Object? sessionId = freezed,Object? hash = freezed,}) {
  return _then(_VpnConnection(
connectionIP: null == connectionIP ? _self.connectionIP : connectionIP // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as VPNLocation,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,hash: freezed == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of VpnConnection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VPNLocationCopyWith<$Res> get location {
  
  return $VPNLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
