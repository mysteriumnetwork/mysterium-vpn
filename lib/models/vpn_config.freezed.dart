// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VpnConfig _$VpnConfigFromJson(Map<String, dynamic> json) {
  return _VpnConfig.fromJson(json);
}

/// @nodoc
mixin _$VpnConfig {
  @JsonKey(name: 'wg_config')
  String get config => throw _privateConstructorUsedError;
  @JsonKey(name: 'limit_exceeded')
  bool get limitExceeded => throw _privateConstructorUsedError;
  @JsonKey(name: 'hash')
  String get hashValue => throw _privateConstructorUsedError;

  /// Serializes this VpnConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VpnConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VpnConfigCopyWith<VpnConfig> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnConfigCopyWith<$Res> {
  factory $VpnConfigCopyWith(VpnConfig value, $Res Function(VpnConfig) then) =
      _$VpnConfigCopyWithImpl<$Res, VpnConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'wg_config') String config,
      @JsonKey(name: 'limit_exceeded') bool limitExceeded,
      @JsonKey(name: 'hash') String hashValue});
}

/// @nodoc
class _$VpnConfigCopyWithImpl<$Res, $Val extends VpnConfig> implements $VpnConfigCopyWith<$Res> {
  _$VpnConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VpnConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
    Object? limitExceeded = null,
    Object? hashValue = null,
  }) {
    return _then(_value.copyWith(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as String,
      limitExceeded: null == limitExceeded
          ? _value.limitExceeded
          : limitExceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      hashValue: null == hashValue
          ? _value.hashValue
          : hashValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VpnConfigImplCopyWith<$Res> implements $VpnConfigCopyWith<$Res> {
  factory _$$VpnConfigImplCopyWith(_$VpnConfigImpl value, $Res Function(_$VpnConfigImpl) then) =
      __$$VpnConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'wg_config') String config,
      @JsonKey(name: 'limit_exceeded') bool limitExceeded,
      @JsonKey(name: 'hash') String hashValue});
}

/// @nodoc
class __$$VpnConfigImplCopyWithImpl<$Res> extends _$VpnConfigCopyWithImpl<$Res, _$VpnConfigImpl>
    implements _$$VpnConfigImplCopyWith<$Res> {
  __$$VpnConfigImplCopyWithImpl(_$VpnConfigImpl _value, $Res Function(_$VpnConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of VpnConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? config = null,
    Object? limitExceeded = null,
    Object? hashValue = null,
  }) {
    return _then(_$VpnConfigImpl(
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as String,
      limitExceeded: null == limitExceeded
          ? _value.limitExceeded
          : limitExceeded // ignore: cast_nullable_to_non_nullable
              as bool,
      hashValue: null == hashValue
          ? _value.hashValue
          : hashValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VpnConfigImpl implements _VpnConfig {
  const _$VpnConfigImpl(
      {@JsonKey(name: 'wg_config') required this.config,
      @JsonKey(name: 'limit_exceeded') required this.limitExceeded,
      @JsonKey(name: 'hash') required this.hashValue});

  factory _$VpnConfigImpl.fromJson(Map<String, dynamic> json) => _$$VpnConfigImplFromJson(json);

  @override
  @JsonKey(name: 'wg_config')
  final String config;
  @override
  @JsonKey(name: 'limit_exceeded')
  final bool limitExceeded;
  @override
  @JsonKey(name: 'hash')
  final String hashValue;

  @override
  String toString() {
    return 'VpnConfig(config: $config, limitExceeded: $limitExceeded, hashValue: $hashValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnConfigImpl &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.limitExceeded, limitExceeded) ||
                other.limitExceeded == limitExceeded) &&
            (identical(other.hashValue, hashValue) || other.hashValue == hashValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, config, limitExceeded, hashValue);

  /// Create a copy of VpnConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnConfigImplCopyWith<_$VpnConfigImpl> get copyWith =>
      __$$VpnConfigImplCopyWithImpl<_$VpnConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VpnConfigImplToJson(
      this,
    );
  }
}

abstract class _VpnConfig implements VpnConfig {
  const factory _VpnConfig(
      {@JsonKey(name: 'wg_config') required final String config,
      @JsonKey(name: 'limit_exceeded') required final bool limitExceeded,
      @JsonKey(name: 'hash') required final String hashValue}) = _$VpnConfigImpl;

  factory _VpnConfig.fromJson(Map<String, dynamic> json) = _$VpnConfigImpl.fromJson;

  @override
  @JsonKey(name: 'wg_config')
  String get config;
  @override
  @JsonKey(name: 'limit_exceeded')
  bool get limitExceeded;
  @override
  @JsonKey(name: 'hash')
  String get hashValue;

  /// Create a copy of VpnConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VpnConfigImplCopyWith<_$VpnConfigImpl> get copyWith => throw _privateConstructorUsedError;
}

VpnConfigInput _$VpnConfigInputFromJson(Map<String, dynamic> json) {
  return _VpnConfigInput.fromJson(json);
}

/// @nodoc
mixin _$VpnConfigInput {
  @JsonKey(name: 'public_key')
  String get publicKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'reset_connection')
  bool get resetConnection => throw _privateConstructorUsedError;
  @JsonKey(name: 'os_type')
  String get osType => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_type')
  String? get ipType => throw _privateConstructorUsedError;

  /// Serializes this VpnConfigInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VpnConfigInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VpnConfigInputCopyWith<VpnConfigInput> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnConfigInputCopyWith<$Res> {
  factory $VpnConfigInputCopyWith(VpnConfigInput value, $Res Function(VpnConfigInput) then) =
      _$VpnConfigInputCopyWithImpl<$Res, VpnConfigInput>;
  @useResult
  $Res call(
      {@JsonKey(name: 'public_key') String publicKey,
      @JsonKey(name: 'reset_connection') bool resetConnection,
      @JsonKey(name: 'os_type') String osType,
      String? country,
      @JsonKey(name: 'ip_type') String? ipType});
}

/// @nodoc
class _$VpnConfigInputCopyWithImpl<$Res, $Val extends VpnConfigInput>
    implements $VpnConfigInputCopyWith<$Res> {
  _$VpnConfigInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VpnConfigInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? resetConnection = null,
    Object? osType = null,
    Object? country = freezed,
    Object? ipType = freezed,
  }) {
    return _then(_value.copyWith(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      resetConnection: null == resetConnection
          ? _value.resetConnection
          : resetConnection // ignore: cast_nullable_to_non_nullable
              as bool,
      osType: null == osType
          ? _value.osType
          : osType // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      ipType: freezed == ipType
          ? _value.ipType
          : ipType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VpnConfigInputImplCopyWith<$Res> implements $VpnConfigInputCopyWith<$Res> {
  factory _$$VpnConfigInputImplCopyWith(
          _$VpnConfigInputImpl value, $Res Function(_$VpnConfigInputImpl) then) =
      __$$VpnConfigInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'public_key') String publicKey,
      @JsonKey(name: 'reset_connection') bool resetConnection,
      @JsonKey(name: 'os_type') String osType,
      String? country,
      @JsonKey(name: 'ip_type') String? ipType});
}

/// @nodoc
class __$$VpnConfigInputImplCopyWithImpl<$Res>
    extends _$VpnConfigInputCopyWithImpl<$Res, _$VpnConfigInputImpl>
    implements _$$VpnConfigInputImplCopyWith<$Res> {
  __$$VpnConfigInputImplCopyWithImpl(
      _$VpnConfigInputImpl _value, $Res Function(_$VpnConfigInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of VpnConfigInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? resetConnection = null,
    Object? osType = null,
    Object? country = freezed,
    Object? ipType = freezed,
  }) {
    return _then(_$VpnConfigInputImpl(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      resetConnection: null == resetConnection
          ? _value.resetConnection
          : resetConnection // ignore: cast_nullable_to_non_nullable
              as bool,
      osType: null == osType
          ? _value.osType
          : osType // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      ipType: freezed == ipType
          ? _value.ipType
          : ipType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VpnConfigInputImpl implements _VpnConfigInput {
  const _$VpnConfigInputImpl(
      {@JsonKey(name: 'public_key') required this.publicKey,
      @JsonKey(name: 'reset_connection') required this.resetConnection,
      @JsonKey(name: 'os_type') required this.osType,
      this.country,
      @JsonKey(name: 'ip_type') this.ipType});

  factory _$VpnConfigInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$VpnConfigInputImplFromJson(json);

  @override
  @JsonKey(name: 'public_key')
  final String publicKey;
  @override
  @JsonKey(name: 'reset_connection')
  final bool resetConnection;
  @override
  @JsonKey(name: 'os_type')
  final String osType;
  @override
  final String? country;
  @override
  @JsonKey(name: 'ip_type')
  final String? ipType;

  @override
  String toString() {
    return 'VpnConfigInput(publicKey: $publicKey, resetConnection: $resetConnection, osType: $osType, country: $country, ipType: $ipType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnConfigInputImpl &&
            (identical(other.publicKey, publicKey) || other.publicKey == publicKey) &&
            (identical(other.resetConnection, resetConnection) ||
                other.resetConnection == resetConnection) &&
            (identical(other.osType, osType) || other.osType == osType) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.ipType, ipType) || other.ipType == ipType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicKey, resetConnection, osType, country, ipType);

  /// Create a copy of VpnConfigInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnConfigInputImplCopyWith<_$VpnConfigInputImpl> get copyWith =>
      __$$VpnConfigInputImplCopyWithImpl<_$VpnConfigInputImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VpnConfigInputImplToJson(
      this,
    );
  }
}

abstract class _VpnConfigInput implements VpnConfigInput {
  const factory _VpnConfigInput(
      {@JsonKey(name: 'public_key') required final String publicKey,
      @JsonKey(name: 'reset_connection') required final bool resetConnection,
      @JsonKey(name: 'os_type') required final String osType,
      final String? country,
      @JsonKey(name: 'ip_type') final String? ipType}) = _$VpnConfigInputImpl;

  factory _VpnConfigInput.fromJson(Map<String, dynamic> json) = _$VpnConfigInputImpl.fromJson;

  @override
  @JsonKey(name: 'public_key')
  String get publicKey;
  @override
  @JsonKey(name: 'reset_connection')
  bool get resetConnection;
  @override
  @JsonKey(name: 'os_type')
  String get osType;
  @override
  String? get country;
  @override
  @JsonKey(name: 'ip_type')
  String? get ipType;

  /// Create a copy of VpnConfigInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VpnConfigInputImplCopyWith<_$VpnConfigInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
