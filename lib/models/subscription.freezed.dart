// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  bool get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_id')
  String? get planId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gateway')
  String? get gateway => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_until')
  DateTime? get activeUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'expired')
  bool? get expired => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurring')
  bool? get recurring => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {bool active,
      @JsonKey(name: 'plan_id') String? planId,
      @JsonKey(name: 'gateway') String? gateway,
      @JsonKey(name: 'active_until') DateTime? activeUntil,
      @JsonKey(name: 'expired') bool? expired,
      @JsonKey(name: 'recurring') bool? recurring});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? planId = freezed,
    Object? gateway = freezed,
    Object? activeUntil = freezed,
    Object? expired = freezed,
    Object? recurring = freezed,
  }) {
    return _then(_value.copyWith(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      planId: freezed == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      activeUntil: freezed == activeUntil
          ? _value.activeUntil
          : activeUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expired: freezed == expired
          ? _value.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurring: freezed == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool active,
      @JsonKey(name: 'plan_id') String? planId,
      @JsonKey(name: 'gateway') String? gateway,
      @JsonKey(name: 'active_until') DateTime? activeUntil,
      @JsonKey(name: 'expired') bool? expired,
      @JsonKey(name: 'recurring') bool? recurring});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? planId = freezed,
    Object? gateway = freezed,
    Object? activeUntil = freezed,
    Object? expired = freezed,
    Object? recurring = freezed,
  }) {
    return _then(_$SubscriptionImpl(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      planId: freezed == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      activeUntil: freezed == activeUntil
          ? _value.activeUntil
          : activeUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expired: freezed == expired
          ? _value.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurring: freezed == recurring
          ? _value.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl implements _Subscription {
  _$SubscriptionImpl(
      {required this.active,
      @JsonKey(name: 'plan_id') this.planId,
      @JsonKey(name: 'gateway') this.gateway,
      @JsonKey(name: 'active_until') this.activeUntil,
      @JsonKey(name: 'expired') this.expired,
      @JsonKey(name: 'recurring') this.recurring});

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final bool active;
  @override
  @JsonKey(name: 'plan_id')
  final String? planId;
  @override
  @JsonKey(name: 'gateway')
  final String? gateway;
  @override
  @JsonKey(name: 'active_until')
  final DateTime? activeUntil;
  @override
  @JsonKey(name: 'expired')
  final bool? expired;
  @override
  @JsonKey(name: 'recurring')
  final bool? recurring;

  @override
  String toString() {
    return 'Subscription(active: $active, planId: $planId, gateway: $gateway, activeUntil: $activeUntil, expired: $expired, recurring: $recurring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            (identical(other.activeUntil, activeUntil) || other.activeUntil == activeUntil) &&
            (identical(other.expired, expired) || other.expired == expired) &&
            (identical(other.recurring, recurring) || other.recurring == recurring));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, active, planId, gateway, activeUntil, expired, recurring);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription implements Subscription {
  factory _Subscription(
      {required final bool active,
      @JsonKey(name: 'plan_id') final String? planId,
      @JsonKey(name: 'gateway') final String? gateway,
      @JsonKey(name: 'active_until') final DateTime? activeUntil,
      @JsonKey(name: 'expired') final bool? expired,
      @JsonKey(name: 'recurring') final bool? recurring}) = _$SubscriptionImpl;

  factory _Subscription.fromJson(Map<String, dynamic> json) = _$SubscriptionImpl.fromJson;

  @override
  bool get active;
  @override
  @JsonKey(name: 'plan_id')
  String? get planId;
  @override
  @JsonKey(name: 'gateway')
  String? get gateway;
  @override
  @JsonKey(name: 'active_until')
  DateTime? get activeUntil;
  @override
  @JsonKey(name: 'expired')
  bool? get expired;
  @override
  @JsonKey(name: 'recurring')
  bool? get recurring;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
