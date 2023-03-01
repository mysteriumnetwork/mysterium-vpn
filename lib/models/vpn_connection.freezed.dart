// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VpnConnection _$VpnConnectionFromJson(Map<String, dynamic> json) {
  return _VpnConnection.fromJson(json);
}

/// @nodoc
mixin _$VpnConnection {
  String get connectionIP => throw _privateConstructorUsedError;
  Location get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VpnConnectionCopyWith<VpnConnection> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnConnectionCopyWith<$Res> {
  factory $VpnConnectionCopyWith(VpnConnection value, $Res Function(VpnConnection) then) =
      _$VpnConnectionCopyWithImpl<$Res, VpnConnection>;
  @useResult
  $Res call({String connectionIP, Location location});

  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class _$VpnConnectionCopyWithImpl<$Res, $Val extends VpnConnection>
    implements $VpnConnectionCopyWith<$Res> {
  _$VpnConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionIP = null,
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      connectionIP: null == connectionIP
          ? _value.connectionIP
          : connectionIP // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res> get location {
    return $LocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_VpnConnectionCopyWith<$Res> implements $VpnConnectionCopyWith<$Res> {
  factory _$$_VpnConnectionCopyWith(_$_VpnConnection value, $Res Function(_$_VpnConnection) then) =
      __$$_VpnConnectionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String connectionIP, Location location});

  @override
  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$_VpnConnectionCopyWithImpl<$Res>
    extends _$VpnConnectionCopyWithImpl<$Res, _$_VpnConnection>
    implements _$$_VpnConnectionCopyWith<$Res> {
  __$$_VpnConnectionCopyWithImpl(_$_VpnConnection _value, $Res Function(_$_VpnConnection) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionIP = null,
    Object? location = null,
  }) {
    return _then(_$_VpnConnection(
      connectionIP: null == connectionIP
          ? _value.connectionIP
          : connectionIP // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_VpnConnection implements _VpnConnection {
  const _$_VpnConnection({required this.connectionIP, required this.location});

  factory _$_VpnConnection.fromJson(Map<String, dynamic> json) => _$$_VpnConnectionFromJson(json);

  @override
  final String connectionIP;
  @override
  final Location location;

  @override
  String toString() {
    return 'VpnConnection(connectionIP: $connectionIP, location: $location)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VpnConnection &&
            (identical(other.connectionIP, connectionIP) || other.connectionIP == connectionIP) &&
            (identical(other.location, location) || other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, connectionIP, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VpnConnectionCopyWith<_$_VpnConnection> get copyWith =>
      __$$_VpnConnectionCopyWithImpl<_$_VpnConnection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VpnConnectionToJson(
      this,
    );
  }
}

abstract class _VpnConnection implements VpnConnection {
  const factory _VpnConnection(
      {required final String connectionIP, required final Location location}) = _$_VpnConnection;

  factory _VpnConnection.fromJson(Map<String, dynamic> json) = _$_VpnConnection.fromJson;

  @override
  String get connectionIP;
  @override
  Location get location;
  @override
  @JsonKey(ignore: true)
  _$$_VpnConnectionCopyWith<_$_VpnConnection> get copyWith => throw _privateConstructorUsedError;
}
