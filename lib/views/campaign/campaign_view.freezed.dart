// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
_Message _$MessageFromJson(
  Map<String, dynamic> json
) {
    return _MessageData.fromJson(
      json
    );
}

/// @nodoc
mixin _$Message {

@JsonKey(name: 'type') _MessageType get type;@JsonKey(name: 'requestId') String? get requestId;@JsonKey(name: 'payload') Map<String, dynamic>? get payload;
/// Create a copy of _Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this as _Message, _$identity);

  /// Serializes this _Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.type, type) || other.type == type)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,requestId,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return '_Message(type: $type, requestId: $requestId, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res>  {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'type') _MessageType type,@JsonKey(name: 'requestId') String? requestId,@JsonKey(name: 'payload') Map<String, dynamic>? payload
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of _Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? requestId = freezed,Object? payload = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as _MessageType,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [_Message].
extension _MessagePatterns on _Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageData value)  $default,){
final _that = this;
switch (_that) {
case _MessageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageData value)?  $default,){
final _that = this;
switch (_that) {
case _MessageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  _MessageType type, @JsonKey(name: 'requestId')  String? requestId, @JsonKey(name: 'payload')  Map<String, dynamic>? payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that.type,_that.requestId,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'type')  _MessageType type, @JsonKey(name: 'requestId')  String? requestId, @JsonKey(name: 'payload')  Map<String, dynamic>? payload)  $default,) {final _that = this;
switch (_that) {
case _MessageData():
return $default(_that.type,_that.requestId,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'type')  _MessageType type, @JsonKey(name: 'requestId')  String? requestId, @JsonKey(name: 'payload')  Map<String, dynamic>? payload)?  $default,) {final _that = this;
switch (_that) {
case _MessageData() when $default != null:
return $default(_that.type,_that.requestId,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageData implements _Message {
  const _MessageData({@JsonKey(name: 'type') required this.type, @JsonKey(name: 'requestId') this.requestId, @JsonKey(name: 'payload') final  Map<String, dynamic>? payload}): _payload = payload;
  factory _MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);

@override@JsonKey(name: 'type') final  _MessageType type;
@override@JsonKey(name: 'requestId') final  String? requestId;
 final  Map<String, dynamic>? _payload;
@override@JsonKey(name: 'payload') Map<String, dynamic>? get payload {
  final value = _payload;
  if (value == null) return null;
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of _Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDataCopyWith<_MessageData> get copyWith => __$MessageDataCopyWithImpl<_MessageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageData&&(identical(other.type, type) || other.type == type)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&const DeepCollectionEquality().equals(other._payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,requestId,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return '_Message(type: $type, requestId: $requestId, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$MessageDataCopyWith<$Res> implements _$MessageCopyWith<$Res> {
  factory _$MessageDataCopyWith(_MessageData value, $Res Function(_MessageData) _then) = __$MessageDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'type') _MessageType type,@JsonKey(name: 'requestId') String? requestId,@JsonKey(name: 'payload') Map<String, dynamic>? payload
});




}
/// @nodoc
class __$MessageDataCopyWithImpl<$Res>
    implements _$MessageDataCopyWith<$Res> {
  __$MessageDataCopyWithImpl(this._self, this._then);

  final _MessageData _self;
  final $Res Function(_MessageData) _then;

/// Create a copy of _Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? requestId = freezed,Object? payload = freezed,}) {
  return _then(_MessageData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as _MessageType,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

_OrderSummaryRequest _$OrderSummaryRequestFromJson(
  Map<String, dynamic> json
) {
    return _OrderSummaryRequestData.fromJson(
      json
    );
}

/// @nodoc
mixin _$OrderSummaryRequest {

@JsonKey(name: 'planId') String get planId;@JsonKey(name: 'country') String get country;@JsonKey(name: 'state') String? get state;@JsonKey(name: 'couponCode') String? get couponCode;
/// Create a copy of _OrderSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryRequestCopyWith<_OrderSummaryRequest> get copyWith => __$OrderSummaryRequestCopyWithImpl<_OrderSummaryRequest>(this as _OrderSummaryRequest, _$identity);

  /// Serializes this _OrderSummaryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummaryRequest&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,country,state,couponCode);

@override
String toString() {
  return '_OrderSummaryRequest(planId: $planId, country: $country, state: $state, couponCode: $couponCode)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryRequestCopyWith<$Res>  {
  factory _$OrderSummaryRequestCopyWith(_OrderSummaryRequest value, $Res Function(_OrderSummaryRequest) _then) = __$OrderSummaryRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'planId') String planId,@JsonKey(name: 'country') String country,@JsonKey(name: 'state') String? state,@JsonKey(name: 'couponCode') String? couponCode
});




}
/// @nodoc
class __$OrderSummaryRequestCopyWithImpl<$Res>
    implements _$OrderSummaryRequestCopyWith<$Res> {
  __$OrderSummaryRequestCopyWithImpl(this._self, this._then);

  final _OrderSummaryRequest _self;
  final $Res Function(_OrderSummaryRequest) _then;

/// Create a copy of _OrderSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planId = null,Object? country = null,Object? state = freezed,Object? couponCode = freezed,}) {
  return _then(_self.copyWith(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [_OrderSummaryRequest].
extension _OrderSummaryRequestPatterns on _OrderSummaryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSummaryRequestData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSummaryRequestData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSummaryRequestData value)  $default,){
final _that = this;
switch (_that) {
case _OrderSummaryRequestData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSummaryRequestData value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSummaryRequestData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'country')  String country, @JsonKey(name: 'state')  String? state, @JsonKey(name: 'couponCode')  String? couponCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSummaryRequestData() when $default != null:
return $default(_that.planId,_that.country,_that.state,_that.couponCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'country')  String country, @JsonKey(name: 'state')  String? state, @JsonKey(name: 'couponCode')  String? couponCode)  $default,) {final _that = this;
switch (_that) {
case _OrderSummaryRequestData():
return $default(_that.planId,_that.country,_that.state,_that.couponCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'country')  String country, @JsonKey(name: 'state')  String? state, @JsonKey(name: 'couponCode')  String? couponCode)?  $default,) {final _that = this;
switch (_that) {
case _OrderSummaryRequestData() when $default != null:
return $default(_that.planId,_that.country,_that.state,_that.couponCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSummaryRequestData implements _OrderSummaryRequest {
   _OrderSummaryRequestData({@JsonKey(name: 'planId') required this.planId, @JsonKey(name: 'country') required this.country, @JsonKey(name: 'state') required this.state, @JsonKey(name: 'couponCode') required this.couponCode});
  factory _OrderSummaryRequestData.fromJson(Map<String, dynamic> json) => _$OrderSummaryRequestDataFromJson(json);

@override@JsonKey(name: 'planId') final  String planId;
@override@JsonKey(name: 'country') final  String country;
@override@JsonKey(name: 'state') final  String? state;
@override@JsonKey(name: 'couponCode') final  String? couponCode;

/// Create a copy of _OrderSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryRequestDataCopyWith<_OrderSummaryRequestData> get copyWith => __$OrderSummaryRequestDataCopyWithImpl<_OrderSummaryRequestData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSummaryRequestDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummaryRequestData&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,country,state,couponCode);

@override
String toString() {
  return '_OrderSummaryRequest(planId: $planId, country: $country, state: $state, couponCode: $couponCode)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryRequestDataCopyWith<$Res> implements _$OrderSummaryRequestCopyWith<$Res> {
  factory _$OrderSummaryRequestDataCopyWith(_OrderSummaryRequestData value, $Res Function(_OrderSummaryRequestData) _then) = __$OrderSummaryRequestDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'planId') String planId,@JsonKey(name: 'country') String country,@JsonKey(name: 'state') String? state,@JsonKey(name: 'couponCode') String? couponCode
});




}
/// @nodoc
class __$OrderSummaryRequestDataCopyWithImpl<$Res>
    implements _$OrderSummaryRequestDataCopyWith<$Res> {
  __$OrderSummaryRequestDataCopyWithImpl(this._self, this._then);

  final _OrderSummaryRequestData _self;
  final $Res Function(_OrderSummaryRequestData) _then;

/// Create a copy of _OrderSummaryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planId = null,Object? country = null,Object? state = freezed,Object? couponCode = freezed,}) {
  return _then(_OrderSummaryRequestData(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

_OrderSummaryResponse _$OrderSummaryResponseFromJson(
  Map<String, dynamic> json
) {
    return _OrderSummaryResponseData.fromJson(
      json
    );
}

/// @nodoc
mixin _$OrderSummaryResponse {

@JsonKey(name: 'orderTotal') String get orderTotal;@JsonKey(name: 'couponError') String? get couponError;
/// Create a copy of _OrderSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryResponseCopyWith<_OrderSummaryResponse> get copyWith => __$OrderSummaryResponseCopyWithImpl<_OrderSummaryResponse>(this as _OrderSummaryResponse, _$identity);

  /// Serializes this _OrderSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummaryResponse&&(identical(other.orderTotal, orderTotal) || other.orderTotal == orderTotal)&&(identical(other.couponError, couponError) || other.couponError == couponError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderTotal,couponError);

@override
String toString() {
  return '_OrderSummaryResponse(orderTotal: $orderTotal, couponError: $couponError)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryResponseCopyWith<$Res>  {
  factory _$OrderSummaryResponseCopyWith(_OrderSummaryResponse value, $Res Function(_OrderSummaryResponse) _then) = __$OrderSummaryResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'orderTotal') String orderTotal,@JsonKey(name: 'couponError') String? couponError
});




}
/// @nodoc
class __$OrderSummaryResponseCopyWithImpl<$Res>
    implements _$OrderSummaryResponseCopyWith<$Res> {
  __$OrderSummaryResponseCopyWithImpl(this._self, this._then);

  final _OrderSummaryResponse _self;
  final $Res Function(_OrderSummaryResponse) _then;

/// Create a copy of _OrderSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderTotal = null,Object? couponError = freezed,}) {
  return _then(_self.copyWith(
orderTotal: null == orderTotal ? _self.orderTotal : orderTotal // ignore: cast_nullable_to_non_nullable
as String,couponError: freezed == couponError ? _self.couponError : couponError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [_OrderSummaryResponse].
extension _OrderSummaryResponsePatterns on _OrderSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSummaryResponseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSummaryResponseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSummaryResponseData value)  $default,){
final _that = this;
switch (_that) {
case _OrderSummaryResponseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSummaryResponseData value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSummaryResponseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'orderTotal')  String orderTotal, @JsonKey(name: 'couponError')  String? couponError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSummaryResponseData() when $default != null:
return $default(_that.orderTotal,_that.couponError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'orderTotal')  String orderTotal, @JsonKey(name: 'couponError')  String? couponError)  $default,) {final _that = this;
switch (_that) {
case _OrderSummaryResponseData():
return $default(_that.orderTotal,_that.couponError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'orderTotal')  String orderTotal, @JsonKey(name: 'couponError')  String? couponError)?  $default,) {final _that = this;
switch (_that) {
case _OrderSummaryResponseData() when $default != null:
return $default(_that.orderTotal,_that.couponError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderSummaryResponseData implements _OrderSummaryResponse {
   _OrderSummaryResponseData({@JsonKey(name: 'orderTotal') required this.orderTotal, @JsonKey(name: 'couponError') required this.couponError});
  factory _OrderSummaryResponseData.fromJson(Map<String, dynamic> json) => _$OrderSummaryResponseDataFromJson(json);

@override@JsonKey(name: 'orderTotal') final  String orderTotal;
@override@JsonKey(name: 'couponError') final  String? couponError;

/// Create a copy of _OrderSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryResponseDataCopyWith<_OrderSummaryResponseData> get copyWith => __$OrderSummaryResponseDataCopyWithImpl<_OrderSummaryResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderSummaryResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummaryResponseData&&(identical(other.orderTotal, orderTotal) || other.orderTotal == orderTotal)&&(identical(other.couponError, couponError) || other.couponError == couponError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderTotal,couponError);

@override
String toString() {
  return '_OrderSummaryResponse(orderTotal: $orderTotal, couponError: $couponError)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryResponseDataCopyWith<$Res> implements _$OrderSummaryResponseCopyWith<$Res> {
  factory _$OrderSummaryResponseDataCopyWith(_OrderSummaryResponseData value, $Res Function(_OrderSummaryResponseData) _then) = __$OrderSummaryResponseDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'orderTotal') String orderTotal,@JsonKey(name: 'couponError') String? couponError
});




}
/// @nodoc
class __$OrderSummaryResponseDataCopyWithImpl<$Res>
    implements _$OrderSummaryResponseDataCopyWith<$Res> {
  __$OrderSummaryResponseDataCopyWithImpl(this._self, this._then);

  final _OrderSummaryResponseData _self;
  final $Res Function(_OrderSummaryResponseData) _then;

/// Create a copy of _OrderSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderTotal = null,Object? couponError = freezed,}) {
  return _then(_OrderSummaryResponseData(
orderTotal: null == orderTotal ? _self.orderTotal : orderTotal // ignore: cast_nullable_to_non_nullable
as String,couponError: freezed == couponError ? _self.couponError : couponError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

_SubscribePayload _$SubscribePayloadFromJson(
  Map<String, dynamic> json
) {
    return _SubscribePayloadData.fromJson(
      json
    );
}

/// @nodoc
mixin _$SubscribePayload {

@JsonKey(name: 'planId') String get planId;@JsonKey(name: 'couponCode') String? get couponCode;
/// Create a copy of _SubscribePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribePayloadCopyWith<_SubscribePayload> get copyWith => __$SubscribePayloadCopyWithImpl<_SubscribePayload>(this as _SubscribePayload, _$identity);

  /// Serializes this _SubscribePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribePayload&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,couponCode);

@override
String toString() {
  return '_SubscribePayload(planId: $planId, couponCode: $couponCode)';
}


}

/// @nodoc
abstract mixin class _$SubscribePayloadCopyWith<$Res>  {
  factory _$SubscribePayloadCopyWith(_SubscribePayload value, $Res Function(_SubscribePayload) _then) = __$SubscribePayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'planId') String planId,@JsonKey(name: 'couponCode') String? couponCode
});




}
/// @nodoc
class __$SubscribePayloadCopyWithImpl<$Res>
    implements _$SubscribePayloadCopyWith<$Res> {
  __$SubscribePayloadCopyWithImpl(this._self, this._then);

  final _SubscribePayload _self;
  final $Res Function(_SubscribePayload) _then;

/// Create a copy of _SubscribePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planId = null,Object? couponCode = freezed,}) {
  return _then(_self.copyWith(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [_SubscribePayload].
extension _SubscribePayloadPatterns on _SubscribePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscribePayloadData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscribePayloadData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscribePayloadData value)  $default,){
final _that = this;
switch (_that) {
case _SubscribePayloadData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscribePayloadData value)?  $default,){
final _that = this;
switch (_that) {
case _SubscribePayloadData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'couponCode')  String? couponCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscribePayloadData() when $default != null:
return $default(_that.planId,_that.couponCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'couponCode')  String? couponCode)  $default,) {final _that = this;
switch (_that) {
case _SubscribePayloadData():
return $default(_that.planId,_that.couponCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'planId')  String planId, @JsonKey(name: 'couponCode')  String? couponCode)?  $default,) {final _that = this;
switch (_that) {
case _SubscribePayloadData() when $default != null:
return $default(_that.planId,_that.couponCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscribePayloadData implements _SubscribePayload {
   _SubscribePayloadData({@JsonKey(name: 'planId') required this.planId, @JsonKey(name: 'couponCode') required this.couponCode});
  factory _SubscribePayloadData.fromJson(Map<String, dynamic> json) => _$SubscribePayloadDataFromJson(json);

@override@JsonKey(name: 'planId') final  String planId;
@override@JsonKey(name: 'couponCode') final  String? couponCode;

/// Create a copy of _SubscribePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscribePayloadDataCopyWith<_SubscribePayloadData> get copyWith => __$SubscribePayloadDataCopyWithImpl<_SubscribePayloadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscribePayloadDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscribePayloadData&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planId,couponCode);

@override
String toString() {
  return '_SubscribePayload(planId: $planId, couponCode: $couponCode)';
}


}

/// @nodoc
abstract mixin class _$SubscribePayloadDataCopyWith<$Res> implements _$SubscribePayloadCopyWith<$Res> {
  factory _$SubscribePayloadDataCopyWith(_SubscribePayloadData value, $Res Function(_SubscribePayloadData) _then) = __$SubscribePayloadDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'planId') String planId,@JsonKey(name: 'couponCode') String? couponCode
});




}
/// @nodoc
class __$SubscribePayloadDataCopyWithImpl<$Res>
    implements _$SubscribePayloadDataCopyWith<$Res> {
  __$SubscribePayloadDataCopyWithImpl(this._self, this._then);

  final _SubscribePayloadData _self;
  final $Res Function(_SubscribePayloadData) _then;

/// Create a copy of _SubscribePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planId = null,Object? couponCode = freezed,}) {
  return _then(_SubscribePayloadData(
planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
