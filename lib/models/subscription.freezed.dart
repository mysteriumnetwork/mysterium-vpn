// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subscription {
  bool get active;
  @JsonKey(name: 'plan_id')
  String? get planId;
  @JsonKey(name: 'gateway')
  String? get gateway;
  @JsonKey(name: 'active_until')
  DateTime? get activeUntil;
  @JsonKey(name: 'expired')
  bool? get expired;
  @JsonKey(name: 'recurring')
  bool? get recurring;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubscriptionCopyWith<Subscription> get copyWith =>
      _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Subscription &&
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

  @override
  String toString() {
    return 'Subscription(active: $active, planId: $planId, gateway: $gateway, activeUntil: $activeUntil, expired: $expired, recurring: $recurring)';
  }
}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) =
      _$SubscriptionCopyWithImpl;
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
class _$SubscriptionCopyWithImpl<$Res> implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

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
    return _then(_self.copyWith(
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      planId: freezed == planId
          ? _self.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _self.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      activeUntil: freezed == activeUntil
          ? _self.activeUntil
          : activeUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expired: freezed == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurring: freezed == recurring
          ? _self.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Subscription value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Subscription value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Subscription value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            bool active,
            @JsonKey(name: 'plan_id') String? planId,
            @JsonKey(name: 'gateway') String? gateway,
            @JsonKey(name: 'active_until') DateTime? activeUntil,
            @JsonKey(name: 'expired') bool? expired,
            @JsonKey(name: 'recurring') bool? recurring)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(_that.active, _that.planId, _that.gateway, _that.activeUntil, _that.expired,
            _that.recurring);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            bool active,
            @JsonKey(name: 'plan_id') String? planId,
            @JsonKey(name: 'gateway') String? gateway,
            @JsonKey(name: 'active_until') DateTime? activeUntil,
            @JsonKey(name: 'expired') bool? expired,
            @JsonKey(name: 'recurring') bool? recurring)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription():
        return $default(_that.active, _that.planId, _that.gateway, _that.activeUntil, _that.expired,
            _that.recurring);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            bool active,
            @JsonKey(name: 'plan_id') String? planId,
            @JsonKey(name: 'gateway') String? gateway,
            @JsonKey(name: 'active_until') DateTime? activeUntil,
            @JsonKey(name: 'expired') bool? expired,
            @JsonKey(name: 'recurring') bool? recurring)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subscription() when $default != null:
        return $default(_that.active, _that.planId, _that.gateway, _that.activeUntil, _that.expired,
            _that.recurring);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Subscription extends Subscription {
  _Subscription(
      {required this.active,
      @JsonKey(name: 'plan_id') this.planId,
      @JsonKey(name: 'gateway') this.gateway,
      @JsonKey(name: 'active_until') this.activeUntil,
      @JsonKey(name: 'expired') this.expired,
      @JsonKey(name: 'recurring') this.recurring})
      : super._();
  factory _Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

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

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubscriptionCopyWith<_Subscription> get copyWith =>
      __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubscriptionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Subscription &&
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

  @override
  String toString() {
    return 'Subscription(active: $active, planId: $planId, gateway: $gateway, activeUntil: $activeUntil, expired: $expired, recurring: $recurring)';
  }
}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) =
      __$SubscriptionCopyWithImpl;
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
class __$SubscriptionCopyWithImpl<$Res> implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? active = null,
    Object? planId = freezed,
    Object? gateway = freezed,
    Object? activeUntil = freezed,
    Object? expired = freezed,
    Object? recurring = freezed,
  }) {
    return _then(_Subscription(
      active: null == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      planId: freezed == planId
          ? _self.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _self.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      activeUntil: freezed == activeUntil
          ? _self.activeUntil
          : activeUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expired: freezed == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as bool?,
      recurring: freezed == recurring
          ? _self.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
