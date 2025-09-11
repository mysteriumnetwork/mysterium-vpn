// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IPInfo _$IPInfoFromJson(Map<String, dynamic> json) {
  return _IPInfo.fromJson(json);
}

/// @nodoc
mixin _$IPInfo {
  String get ip => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;

  /// Serializes this IPInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IPInfoCopyWith<IPInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IPInfoCopyWith<$Res> {
  factory $IPInfoCopyWith(IPInfo value, $Res Function(IPInfo) then) =
      _$IPInfoCopyWithImpl<$Res, IPInfo>;
  @useResult
  $Res call({String ip, String country, String city});
}

/// @nodoc
class _$IPInfoCopyWithImpl<$Res, $Val extends IPInfo> implements $IPInfoCopyWith<$Res> {
  _$IPInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? country = null,
    Object? city = null,
  }) {
    return _then(_value.copyWith(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IPInfoImplCopyWith<$Res> implements $IPInfoCopyWith<$Res> {
  factory _$$IPInfoImplCopyWith(_$IPInfoImpl value, $Res Function(_$IPInfoImpl) then) =
      __$$IPInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ip, String country, String city});
}

/// @nodoc
class __$$IPInfoImplCopyWithImpl<$Res> extends _$IPInfoCopyWithImpl<$Res, _$IPInfoImpl>
    implements _$$IPInfoImplCopyWith<$Res> {
  __$$IPInfoImplCopyWithImpl(_$IPInfoImpl _value, $Res Function(_$IPInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? country = null,
    Object? city = null,
  }) {
    return _then(_$IPInfoImpl(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IPInfoImpl extends _IPInfo {
  const _$IPInfoImpl({required this.ip, required this.country, required this.city}) : super._();

  factory _$IPInfoImpl.fromJson(Map<String, dynamic> json) => _$$IPInfoImplFromJson(json);

  @override
  final String ip;
  @override
  final String country;
  @override
  final String city;

  @override
  String toString() {
    return 'IPInfo(ip: $ip, country: $country, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IPInfoImpl &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip, country, city);

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IPInfoImplCopyWith<_$IPInfoImpl> get copyWith =>
      __$$IPInfoImplCopyWithImpl<_$IPInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IPInfoImplToJson(
      this,
    );
  }
}

abstract class _IPInfo extends IPInfo {
  const factory _IPInfo(
      {required final String ip,
      required final String country,
      required final String city}) = _$IPInfoImpl;
  const _IPInfo._() : super._();

  factory _IPInfo.fromJson(Map<String, dynamic> json) = _$IPInfoImpl.fromJson;

  @override
  String get ip;
  @override
  String get country;
  @override
  String get city;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IPInfoImplCopyWith<_$IPInfoImpl> get copyWith => throw _privateConstructorUsedError;
}
