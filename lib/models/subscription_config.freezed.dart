// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionConfig _$SubscriptionConfigFromJson(Map<String, dynamic> json) {
  return _SubscriptionConfig.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionConfig {
  List<Gateway> get gateways => throw _privateConstructorUsedError;
  List<PlanDetails> get plans => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionConfigCopyWith<SubscriptionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionConfigCopyWith<$Res> {
  factory $SubscriptionConfigCopyWith(
          SubscriptionConfig value, $Res Function(SubscriptionConfig) then) =
      _$SubscriptionConfigCopyWithImpl<$Res, SubscriptionConfig>;
  @useResult
  $Res call({List<Gateway> gateways, List<PlanDetails> plans});
}

/// @nodoc
class _$SubscriptionConfigCopyWithImpl<$Res, $Val extends SubscriptionConfig>
    implements $SubscriptionConfigCopyWith<$Res> {
  _$SubscriptionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gateways = null,
    Object? plans = null,
  }) {
    return _then(_value.copyWith(
      gateways: null == gateways
          ? _value.gateways
          : gateways // ignore: cast_nullable_to_non_nullable
              as List<Gateway>,
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<PlanDetails>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionConfigImplCopyWith<$Res>
    implements $SubscriptionConfigCopyWith<$Res> {
  factory _$$SubscriptionConfigImplCopyWith(
          _$SubscriptionConfigImpl value, $Res Function(_$SubscriptionConfigImpl) then) =
      __$$SubscriptionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Gateway> gateways, List<PlanDetails> plans});
}

/// @nodoc
class __$$SubscriptionConfigImplCopyWithImpl<$Res>
    extends _$SubscriptionConfigCopyWithImpl<$Res, _$SubscriptionConfigImpl>
    implements _$$SubscriptionConfigImplCopyWith<$Res> {
  __$$SubscriptionConfigImplCopyWithImpl(
      _$SubscriptionConfigImpl _value, $Res Function(_$SubscriptionConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gateways = null,
    Object? plans = null,
  }) {
    return _then(_$SubscriptionConfigImpl(
      gateways: null == gateways
          ? _value.gateways
          : gateways // ignore: cast_nullable_to_non_nullable
              as List<Gateway>,
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<PlanDetails>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionConfigImpl implements _SubscriptionConfig {
  _$SubscriptionConfigImpl({required this.gateways, required this.plans});

  factory _$SubscriptionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionConfigImplFromJson(json);

  @override
  final List<Gateway> gateways;
  @override
  final List<PlanDetails> plans;

  @override
  String toString() {
    return 'SubscriptionConfig(gateways: $gateways, plans: $plans)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionConfigImpl &&
            const DeepCollectionEquality().equals(other.gateways, gateways) &&
            const DeepCollectionEquality().equals(other.plans, plans));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(gateways),
      const DeepCollectionEquality().hash(plans));

  /// Create a copy of SubscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionConfigImplCopyWith<_$SubscriptionConfigImpl> get copyWith =>
      __$$SubscriptionConfigImplCopyWithImpl<_$SubscriptionConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionConfigImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionConfig implements SubscriptionConfig {
  factory _SubscriptionConfig(
      {required final List<Gateway> gateways,
      required final List<PlanDetails> plans}) = _$SubscriptionConfigImpl;

  factory _SubscriptionConfig.fromJson(Map<String, dynamic> json) =
      _$SubscriptionConfigImpl.fromJson;

  @override
  List<Gateway> get gateways;
  @override
  List<PlanDetails> get plans;

  /// Create a copy of SubscriptionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionConfigImplCopyWith<_$SubscriptionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
