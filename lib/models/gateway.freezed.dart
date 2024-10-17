// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gateway.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Gateway _$GatewayFromJson(Map<String, dynamic> json) {
  return _Gateway.fromJson(json);
}

/// @nodoc
mixin _$Gateway {
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'enabled')
  bool get enabled => throw _privateConstructorUsedError;

  /// Serializes this Gateway to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GatewayCopyWith<Gateway> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GatewayCopyWith<$Res> {
  factory $GatewayCopyWith(Gateway value, $Res Function(Gateway) then) =
      _$GatewayCopyWithImpl<$Res, Gateway>;
  @useResult
  $Res call({@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class _$GatewayCopyWithImpl<$Res, $Val extends Gateway> implements $GatewayCopyWith<$Res> {
  _$GatewayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GatewayImplCopyWith<$Res> implements $GatewayCopyWith<$Res> {
  factory _$$GatewayImplCopyWith(_$GatewayImpl value, $Res Function(_$GatewayImpl) then) =
      __$$GatewayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class __$$GatewayImplCopyWithImpl<$Res> extends _$GatewayCopyWithImpl<$Res, _$GatewayImpl>
    implements _$$GatewayImplCopyWith<$Res> {
  __$$GatewayImplCopyWithImpl(_$GatewayImpl _value, $Res Function(_$GatewayImpl) _then)
      : super(_value, _then);

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? enabled = null,
  }) {
    return _then(_$GatewayImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GatewayImpl implements _Gateway {
  _$GatewayImpl(
      {@JsonKey(name: 'name') required this.name, @JsonKey(name: 'enabled') required this.enabled});

  factory _$GatewayImpl.fromJson(Map<String, dynamic> json) => _$$GatewayImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'enabled')
  final bool enabled;

  @override
  String toString() {
    return 'Gateway(name: $name, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GatewayImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, enabled);

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GatewayImplCopyWith<_$GatewayImpl> get copyWith =>
      __$$GatewayImplCopyWithImpl<_$GatewayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GatewayImplToJson(
      this,
    );
  }
}

abstract class _Gateway implements Gateway {
  factory _Gateway(
      {@JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'enabled') required final bool enabled}) = _$GatewayImpl;

  factory _Gateway.fromJson(Map<String, dynamic> json) = _$GatewayImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'enabled')
  bool get enabled;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GatewayImplCopyWith<_$GatewayImpl> get copyWith => throw _privateConstructorUsedError;
}
