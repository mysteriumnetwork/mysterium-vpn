// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IPInfo {
  String get ip;
  String get country;
  String get city;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IPInfoCopyWith<IPInfo> get copyWith => _$IPInfoCopyWithImpl<IPInfo>(this as IPInfo, _$identity);

  /// Serializes this IPInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IPInfo &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip, country, city);

  @override
  String toString() {
    return 'IPInfo(ip: $ip, country: $country, city: $city)';
  }
}

/// @nodoc
abstract mixin class $IPInfoCopyWith<$Res> {
  factory $IPInfoCopyWith(IPInfo value, $Res Function(IPInfo) _then) = _$IPInfoCopyWithImpl;
  @useResult
  $Res call({String ip, String country, String city});
}

/// @nodoc
class _$IPInfoCopyWithImpl<$Res> implements $IPInfoCopyWith<$Res> {
  _$IPInfoCopyWithImpl(this._self, this._then);

  final IPInfo _self;
  final $Res Function(IPInfo) _then;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? country = null,
    Object? city = null,
  }) {
    return _then(_self.copyWith(
      ip: null == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [IPInfo].
extension IPInfoPatterns on IPInfo {
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
    TResult Function(_IPInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IPInfo() when $default != null:
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
    TResult Function(_IPInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IPInfo():
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
    TResult? Function(_IPInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IPInfo() when $default != null:
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
    TResult Function(String ip, String country, String city)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IPInfo() when $default != null:
        return $default(_that.ip, _that.country, _that.city);
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
    TResult Function(String ip, String country, String city) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IPInfo():
        return $default(_that.ip, _that.country, _that.city);
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
    TResult? Function(String ip, String country, String city)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IPInfo() when $default != null:
        return $default(_that.ip, _that.country, _that.city);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IPInfo extends IPInfo {
  const _IPInfo({required this.ip, required this.country, required this.city}) : super._();
  factory _IPInfo.fromJson(Map<String, dynamic> json) => _$IPInfoFromJson(json);

  @override
  final String ip;
  @override
  final String country;
  @override
  final String city;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IPInfoCopyWith<_IPInfo> get copyWith => __$IPInfoCopyWithImpl<_IPInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IPInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IPInfo &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip, country, city);

  @override
  String toString() {
    return 'IPInfo(ip: $ip, country: $country, city: $city)';
  }
}

/// @nodoc
abstract mixin class _$IPInfoCopyWith<$Res> implements $IPInfoCopyWith<$Res> {
  factory _$IPInfoCopyWith(_IPInfo value, $Res Function(_IPInfo) _then) = __$IPInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String ip, String country, String city});
}

/// @nodoc
class __$IPInfoCopyWithImpl<$Res> implements _$IPInfoCopyWith<$Res> {
  __$IPInfoCopyWithImpl(this._self, this._then);

  final _IPInfo _self;
  final $Res Function(_IPInfo) _then;

  /// Create a copy of IPInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ip = null,
    Object? country = null,
    Object? city = null,
  }) {
    return _then(_IPInfo(
      ip: null == ip
          ? _self.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
