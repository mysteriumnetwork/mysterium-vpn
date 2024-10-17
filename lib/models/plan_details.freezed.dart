// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlanDetails _$PlanDetailsFromJson(Map<String, dynamic> json) {
  return _PlanDetails.fromJson(json);
}

/// @nodoc
mixin _$PlanDetails {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'interval')
  Interval get enabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'supported_gateways')
  List<String> get supportedGateways => throw _privateConstructorUsedError;
  @JsonKey(name: 'apple_product_id')
  String get appleProductId => throw _privateConstructorUsedError;
  @JsonKey(name: 'google_product_id')
  String get googleProductId => throw _privateConstructorUsedError;

  /// Serializes this PlanDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanDetailsCopyWith<PlanDetails> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanDetailsCopyWith<$Res> {
  factory $PlanDetailsCopyWith(PlanDetails value, $Res Function(PlanDetails) then) =
      _$PlanDetailsCopyWithImpl<$Res, PlanDetails>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'interval') Interval enabled,
      @JsonKey(name: 'supported_gateways') List<String> supportedGateways,
      @JsonKey(name: 'apple_product_id') String appleProductId,
      @JsonKey(name: 'google_product_id') String googleProductId});

  $IntervalCopyWith<$Res> get enabled;
}

/// @nodoc
class _$PlanDetailsCopyWithImpl<$Res, $Val extends PlanDetails>
    implements $PlanDetailsCopyWith<$Res> {
  _$PlanDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? enabled = null,
    Object? supportedGateways = null,
    Object? appleProductId = null,
    Object? googleProductId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as Interval,
      supportedGateways: null == supportedGateways
          ? _value.supportedGateways
          : supportedGateways // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appleProductId: null == appleProductId
          ? _value.appleProductId
          : appleProductId // ignore: cast_nullable_to_non_nullable
              as String,
      googleProductId: null == googleProductId
          ? _value.googleProductId
          : googleProductId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IntervalCopyWith<$Res> get enabled {
    return $IntervalCopyWith<$Res>(_value.enabled, (value) {
      return _then(_value.copyWith(enabled: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanDetailsImplCopyWith<$Res> implements $PlanDetailsCopyWith<$Res> {
  factory _$$PlanDetailsImplCopyWith(
          _$PlanDetailsImpl value, $Res Function(_$PlanDetailsImpl) then) =
      __$$PlanDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'interval') Interval enabled,
      @JsonKey(name: 'supported_gateways') List<String> supportedGateways,
      @JsonKey(name: 'apple_product_id') String appleProductId,
      @JsonKey(name: 'google_product_id') String googleProductId});

  @override
  $IntervalCopyWith<$Res> get enabled;
}

/// @nodoc
class __$$PlanDetailsImplCopyWithImpl<$Res>
    extends _$PlanDetailsCopyWithImpl<$Res, _$PlanDetailsImpl>
    implements _$$PlanDetailsImplCopyWith<$Res> {
  __$$PlanDetailsImplCopyWithImpl(_$PlanDetailsImpl _value, $Res Function(_$PlanDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? enabled = null,
    Object? supportedGateways = null,
    Object? appleProductId = null,
    Object? googleProductId = null,
  }) {
    return _then(_$PlanDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as Interval,
      supportedGateways: null == supportedGateways
          ? _value._supportedGateways
          : supportedGateways // ignore: cast_nullable_to_non_nullable
              as List<String>,
      appleProductId: null == appleProductId
          ? _value.appleProductId
          : appleProductId // ignore: cast_nullable_to_non_nullable
              as String,
      googleProductId: null == googleProductId
          ? _value.googleProductId
          : googleProductId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanDetailsImpl implements _PlanDetails {
  _$PlanDetailsImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'interval') required this.enabled,
      @JsonKey(name: 'supported_gateways') required final List<String> supportedGateways,
      @JsonKey(name: 'apple_product_id') required this.appleProductId,
      @JsonKey(name: 'google_product_id') required this.googleProductId})
      : _supportedGateways = supportedGateways;

  factory _$PlanDetailsImpl.fromJson(Map<String, dynamic> json) => _$$PlanDetailsImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'interval')
  final Interval enabled;
  final List<String> _supportedGateways;
  @override
  @JsonKey(name: 'supported_gateways')
  List<String> get supportedGateways {
    if (_supportedGateways is EqualUnmodifiableListView) return _supportedGateways;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedGateways);
  }

  @override
  @JsonKey(name: 'apple_product_id')
  final String appleProductId;
  @override
  @JsonKey(name: 'google_product_id')
  final String googleProductId;

  @override
  String toString() {
    return 'PlanDetails(id: $id, enabled: $enabled, supportedGateways: $supportedGateways, appleProductId: $appleProductId, googleProductId: $googleProductId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other._supportedGateways, _supportedGateways) &&
            (identical(other.appleProductId, appleProductId) ||
                other.appleProductId == appleProductId) &&
            (identical(other.googleProductId, googleProductId) ||
                other.googleProductId == googleProductId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, enabled,
      const DeepCollectionEquality().hash(_supportedGateways), appleProductId, googleProductId);

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanDetailsImplCopyWith<_$PlanDetailsImpl> get copyWith =>
      __$$PlanDetailsImplCopyWithImpl<_$PlanDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanDetailsImplToJson(
      this,
    );
  }
}

abstract class _PlanDetails implements PlanDetails {
  factory _PlanDetails(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'interval') required final Interval enabled,
          @JsonKey(name: 'supported_gateways') required final List<String> supportedGateways,
          @JsonKey(name: 'apple_product_id') required final String appleProductId,
          @JsonKey(name: 'google_product_id') required final String googleProductId}) =
      _$PlanDetailsImpl;

  factory _PlanDetails.fromJson(Map<String, dynamic> json) = _$PlanDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'interval')
  Interval get enabled;
  @override
  @JsonKey(name: 'supported_gateways')
  List<String> get supportedGateways;
  @override
  @JsonKey(name: 'apple_product_id')
  String get appleProductId;
  @override
  @JsonKey(name: 'google_product_id')
  String get googleProductId;

  /// Create a copy of PlanDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanDetailsImplCopyWith<_$PlanDetailsImpl> get copyWith => throw _privateConstructorUsedError;
}

Interval _$IntervalFromJson(Map<String, dynamic> json) {
  return _Interval.fromJson(json);
}

/// @nodoc
mixin _$Interval {
  String get unit => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this Interval to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Interval
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IntervalCopyWith<Interval> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IntervalCopyWith<$Res> {
  factory $IntervalCopyWith(Interval value, $Res Function(Interval) then) =
      _$IntervalCopyWithImpl<$Res, Interval>;
  @useResult
  $Res call({String unit, double amount});
}

/// @nodoc
class _$IntervalCopyWithImpl<$Res, $Val extends Interval> implements $IntervalCopyWith<$Res> {
  _$IntervalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Interval
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unit = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IntervalImplCopyWith<$Res> implements $IntervalCopyWith<$Res> {
  factory _$$IntervalImplCopyWith(_$IntervalImpl value, $Res Function(_$IntervalImpl) then) =
      __$$IntervalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String unit, double amount});
}

/// @nodoc
class __$$IntervalImplCopyWithImpl<$Res> extends _$IntervalCopyWithImpl<$Res, _$IntervalImpl>
    implements _$$IntervalImplCopyWith<$Res> {
  __$$IntervalImplCopyWithImpl(_$IntervalImpl _value, $Res Function(_$IntervalImpl) _then)
      : super(_value, _then);

  /// Create a copy of Interval
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unit = null,
    Object? amount = null,
  }) {
    return _then(_$IntervalImpl(
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntervalImpl implements _Interval {
  _$IntervalImpl({required this.unit, required this.amount});

  factory _$IntervalImpl.fromJson(Map<String, dynamic> json) => _$$IntervalImplFromJson(json);

  @override
  final String unit;
  @override
  final double amount;

  @override
  String toString() {
    return 'Interval(unit: $unit, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntervalImpl &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, unit, amount);

  /// Create a copy of Interval
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntervalImplCopyWith<_$IntervalImpl> get copyWith =>
      __$$IntervalImplCopyWithImpl<_$IntervalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IntervalImplToJson(
      this,
    );
  }
}

abstract class _Interval implements Interval {
  factory _Interval({required final String unit, required final double amount}) = _$IntervalImpl;

  factory _Interval.fromJson(Map<String, dynamic> json) = _$IntervalImpl.fromJson;

  @override
  String get unit;
  @override
  double get amount;

  /// Create a copy of Interval
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntervalImplCopyWith<_$IntervalImpl> get copyWith => throw _privateConstructorUsedError;
}
