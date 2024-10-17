// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_broken_node_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportBrokenNodeRequest _$ReportBrokenNodeRequestFromJson(Map<String, dynamic> json) {
  return _ReportBrokenNodeRequest.fromJson(json);
}

/// @nodoc
mixin _$ReportBrokenNodeRequest {
  @JsonKey(name: 'public_key')
  String get publicKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_country')
  String get destinationCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'os_type')
  String get osType => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String get appVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'hash')
  String get hashValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_country')
  String? get originCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'internet_type')
  ConnectivityResult? get connectivityType => throw _privateConstructorUsedError;

  /// Serializes this ReportBrokenNodeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportBrokenNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportBrokenNodeRequestCopyWith<ReportBrokenNodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportBrokenNodeRequestCopyWith<$Res> {
  factory $ReportBrokenNodeRequestCopyWith(
          ReportBrokenNodeRequest value, $Res Function(ReportBrokenNodeRequest) then) =
      _$ReportBrokenNodeRequestCopyWithImpl<$Res, ReportBrokenNodeRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'public_key') String publicKey,
      @JsonKey(name: 'destination_country') String destinationCountry,
      @JsonKey(name: 'os_type') String osType,
      @JsonKey(name: 'app_version') String appVersion,
      @JsonKey(name: 'hash') String hashValue,
      @JsonKey(name: 'origin_country') String? originCountry,
      @JsonKey(name: 'internet_type') ConnectivityResult? connectivityType});
}

/// @nodoc
class _$ReportBrokenNodeRequestCopyWithImpl<$Res, $Val extends ReportBrokenNodeRequest>
    implements $ReportBrokenNodeRequestCopyWith<$Res> {
  _$ReportBrokenNodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportBrokenNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? destinationCountry = null,
    Object? osType = null,
    Object? appVersion = null,
    Object? hashValue = null,
    Object? originCountry = freezed,
    Object? connectivityType = freezed,
  }) {
    return _then(_value.copyWith(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCountry: null == destinationCountry
          ? _value.destinationCountry
          : destinationCountry // ignore: cast_nullable_to_non_nullable
              as String,
      osType: null == osType
          ? _value.osType
          : osType // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      hashValue: null == hashValue
          ? _value.hashValue
          : hashValue // ignore: cast_nullable_to_non_nullable
              as String,
      originCountry: freezed == originCountry
          ? _value.originCountry
          : originCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      connectivityType: freezed == connectivityType
          ? _value.connectivityType
          : connectivityType // ignore: cast_nullable_to_non_nullable
              as ConnectivityResult?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportBrokenNodeRequestImplCopyWith<$Res>
    implements $ReportBrokenNodeRequestCopyWith<$Res> {
  factory _$$ReportBrokenNodeRequestImplCopyWith(
          _$ReportBrokenNodeRequestImpl value, $Res Function(_$ReportBrokenNodeRequestImpl) then) =
      __$$ReportBrokenNodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'public_key') String publicKey,
      @JsonKey(name: 'destination_country') String destinationCountry,
      @JsonKey(name: 'os_type') String osType,
      @JsonKey(name: 'app_version') String appVersion,
      @JsonKey(name: 'hash') String hashValue,
      @JsonKey(name: 'origin_country') String? originCountry,
      @JsonKey(name: 'internet_type') ConnectivityResult? connectivityType});
}

/// @nodoc
class __$$ReportBrokenNodeRequestImplCopyWithImpl<$Res>
    extends _$ReportBrokenNodeRequestCopyWithImpl<$Res, _$ReportBrokenNodeRequestImpl>
    implements _$$ReportBrokenNodeRequestImplCopyWith<$Res> {
  __$$ReportBrokenNodeRequestImplCopyWithImpl(
      _$ReportBrokenNodeRequestImpl _value, $Res Function(_$ReportBrokenNodeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportBrokenNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicKey = null,
    Object? destinationCountry = null,
    Object? osType = null,
    Object? appVersion = null,
    Object? hashValue = null,
    Object? originCountry = freezed,
    Object? connectivityType = freezed,
  }) {
    return _then(_$ReportBrokenNodeRequestImpl(
      publicKey: null == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCountry: null == destinationCountry
          ? _value.destinationCountry
          : destinationCountry // ignore: cast_nullable_to_non_nullable
              as String,
      osType: null == osType
          ? _value.osType
          : osType // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      hashValue: null == hashValue
          ? _value.hashValue
          : hashValue // ignore: cast_nullable_to_non_nullable
              as String,
      originCountry: freezed == originCountry
          ? _value.originCountry
          : originCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      connectivityType: freezed == connectivityType
          ? _value.connectivityType
          : connectivityType // ignore: cast_nullable_to_non_nullable
              as ConnectivityResult?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportBrokenNodeRequestImpl implements _ReportBrokenNodeRequest {
  _$ReportBrokenNodeRequestImpl(
      {@JsonKey(name: 'public_key') required this.publicKey,
      @JsonKey(name: 'destination_country') required this.destinationCountry,
      @JsonKey(name: 'os_type') required this.osType,
      @JsonKey(name: 'app_version') required this.appVersion,
      @JsonKey(name: 'hash') required this.hashValue,
      @JsonKey(name: 'origin_country') this.originCountry,
      @JsonKey(name: 'internet_type') this.connectivityType});

  factory _$ReportBrokenNodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportBrokenNodeRequestImplFromJson(json);

  @override
  @JsonKey(name: 'public_key')
  final String publicKey;
  @override
  @JsonKey(name: 'destination_country')
  final String destinationCountry;
  @override
  @JsonKey(name: 'os_type')
  final String osType;
  @override
  @JsonKey(name: 'app_version')
  final String appVersion;
  @override
  @JsonKey(name: 'hash')
  final String hashValue;
  @override
  @JsonKey(name: 'origin_country')
  final String? originCountry;
  @override
  @JsonKey(name: 'internet_type')
  final ConnectivityResult? connectivityType;

  @override
  String toString() {
    return 'ReportBrokenNodeRequest(publicKey: $publicKey, destinationCountry: $destinationCountry, osType: $osType, appVersion: $appVersion, hashValue: $hashValue, originCountry: $originCountry, connectivityType: $connectivityType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportBrokenNodeRequestImpl &&
            (identical(other.publicKey, publicKey) || other.publicKey == publicKey) &&
            (identical(other.destinationCountry, destinationCountry) ||
                other.destinationCountry == destinationCountry) &&
            (identical(other.osType, osType) || other.osType == osType) &&
            (identical(other.appVersion, appVersion) || other.appVersion == appVersion) &&
            (identical(other.hashValue, hashValue) || other.hashValue == hashValue) &&
            (identical(other.originCountry, originCountry) ||
                other.originCountry == originCountry) &&
            (identical(other.connectivityType, connectivityType) ||
                other.connectivityType == connectivityType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, publicKey, destinationCountry, osType, appVersion,
      hashValue, originCountry, connectivityType);

  /// Create a copy of ReportBrokenNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportBrokenNodeRequestImplCopyWith<_$ReportBrokenNodeRequestImpl> get copyWith =>
      __$$ReportBrokenNodeRequestImplCopyWithImpl<_$ReportBrokenNodeRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportBrokenNodeRequestImplToJson(
      this,
    );
  }
}

abstract class _ReportBrokenNodeRequest implements ReportBrokenNodeRequest {
  factory _ReportBrokenNodeRequest(
          {@JsonKey(name: 'public_key') required final String publicKey,
          @JsonKey(name: 'destination_country') required final String destinationCountry,
          @JsonKey(name: 'os_type') required final String osType,
          @JsonKey(name: 'app_version') required final String appVersion,
          @JsonKey(name: 'hash') required final String hashValue,
          @JsonKey(name: 'origin_country') final String? originCountry,
          @JsonKey(name: 'internet_type') final ConnectivityResult? connectivityType}) =
      _$ReportBrokenNodeRequestImpl;

  factory _ReportBrokenNodeRequest.fromJson(Map<String, dynamic> json) =
      _$ReportBrokenNodeRequestImpl.fromJson;

  @override
  @JsonKey(name: 'public_key')
  String get publicKey;
  @override
  @JsonKey(name: 'destination_country')
  String get destinationCountry;
  @override
  @JsonKey(name: 'os_type')
  String get osType;
  @override
  @JsonKey(name: 'app_version')
  String get appVersion;
  @override
  @JsonKey(name: 'hash')
  String get hashValue;
  @override
  @JsonKey(name: 'origin_country')
  String? get originCountry;
  @override
  @JsonKey(name: 'internet_type')
  ConnectivityResult? get connectivityType;

  /// Create a copy of ReportBrokenNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportBrokenNodeRequestImplCopyWith<_$ReportBrokenNodeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
