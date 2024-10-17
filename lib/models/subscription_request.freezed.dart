// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionRequest _$SubscriptionRequestFromJson(Map<String, dynamic> json) {
  return _SubscriptionRequest.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionRequest {
  @JsonKey(name: 'gateway_id')
  String get gatewayId => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_id')
  String get planId => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionRequestCopyWith<SubscriptionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionRequestCopyWith<$Res> {
  factory $SubscriptionRequestCopyWith(
          SubscriptionRequest value, $Res Function(SubscriptionRequest) then) =
      _$SubscriptionRequestCopyWithImpl<$Res, SubscriptionRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'gateway_id') String gatewayId, @JsonKey(name: 'plan_id') String planId});
}

/// @nodoc
class _$SubscriptionRequestCopyWithImpl<$Res, $Val extends SubscriptionRequest>
    implements $SubscriptionRequestCopyWith<$Res> {
  _$SubscriptionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gatewayId = null,
    Object? planId = null,
  }) {
    return _then(_value.copyWith(
      gatewayId: null == gatewayId
          ? _value.gatewayId
          : gatewayId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionRequestImplCopyWith<$Res>
    implements $SubscriptionRequestCopyWith<$Res> {
  factory _$$SubscriptionRequestImplCopyWith(
          _$SubscriptionRequestImpl value, $Res Function(_$SubscriptionRequestImpl) then) =
      __$$SubscriptionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'gateway_id') String gatewayId, @JsonKey(name: 'plan_id') String planId});
}

/// @nodoc
class __$$SubscriptionRequestImplCopyWithImpl<$Res>
    extends _$SubscriptionRequestCopyWithImpl<$Res, _$SubscriptionRequestImpl>
    implements _$$SubscriptionRequestImplCopyWith<$Res> {
  __$$SubscriptionRequestImplCopyWithImpl(
      _$SubscriptionRequestImpl _value, $Res Function(_$SubscriptionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gatewayId = null,
    Object? planId = null,
  }) {
    return _then(_$SubscriptionRequestImpl(
      gatewayId: null == gatewayId
          ? _value.gatewayId
          : gatewayId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionRequestImpl implements _SubscriptionRequest {
  _$SubscriptionRequestImpl(
      {@JsonKey(name: 'gateway_id') required this.gatewayId,
      @JsonKey(name: 'plan_id') required this.planId});

  factory _$SubscriptionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionRequestImplFromJson(json);

  @override
  @JsonKey(name: 'gateway_id')
  final String gatewayId;
  @override
  @JsonKey(name: 'plan_id')
  final String planId;

  @override
  String toString() {
    return 'SubscriptionRequest(gatewayId: $gatewayId, planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionRequestImpl &&
            (identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId) &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gatewayId, planId);

  /// Create a copy of SubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionRequestImplCopyWith<_$SubscriptionRequestImpl> get copyWith =>
      __$$SubscriptionRequestImplCopyWithImpl<_$SubscriptionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionRequestImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionRequest implements SubscriptionRequest {
  factory _SubscriptionRequest(
      {@JsonKey(name: 'gateway_id') required final String gatewayId,
      @JsonKey(name: 'plan_id') required final String planId}) = _$SubscriptionRequestImpl;

  factory _SubscriptionRequest.fromJson(Map<String, dynamic> json) =
      _$SubscriptionRequestImpl.fromJson;

  @override
  @JsonKey(name: 'gateway_id')
  String get gatewayId;
  @override
  @JsonKey(name: 'plan_id')
  String get planId;

  /// Create a copy of SubscriptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionRequestImplCopyWith<_$SubscriptionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
