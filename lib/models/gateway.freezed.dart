// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gateway.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Gateway {
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'enabled')
  bool get enabled;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GatewayCopyWith<Gateway> get copyWith =>
      _$GatewayCopyWithImpl<Gateway>(this as Gateway, _$identity);

  /// Serializes this Gateway to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Gateway &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, enabled);

  @override
  String toString() {
    return 'Gateway(name: $name, enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $GatewayCopyWith<$Res> {
  factory $GatewayCopyWith(Gateway value, $Res Function(Gateway) _then) = _$GatewayCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class _$GatewayCopyWithImpl<$Res> implements $GatewayCopyWith<$Res> {
  _$GatewayCopyWithImpl(this._self, this._then);

  final Gateway _self;
  final $Res Function(Gateway) _then;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? enabled = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Gateway].
extension GatewayPatterns on Gateway {
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
    TResult Function(_Gateway value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Gateway() when $default != null:
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
    TResult Function(_Gateway value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Gateway():
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
    TResult? Function(_Gateway value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Gateway() when $default != null:
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
    TResult Function(@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Gateway() when $default != null:
        return $default(_that.name, _that.enabled);
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
    TResult Function(@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Gateway():
        return $default(_that.name, _that.enabled);
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
    TResult? Function(@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Gateway() when $default != null:
        return $default(_that.name, _that.enabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Gateway implements Gateway {
  _Gateway(
      {@JsonKey(name: 'name') required this.name, @JsonKey(name: 'enabled') required this.enabled});
  factory _Gateway.fromJson(Map<String, dynamic> json) => _$GatewayFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'enabled')
  final bool enabled;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GatewayCopyWith<_Gateway> get copyWith => __$GatewayCopyWithImpl<_Gateway>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GatewayToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Gateway &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, enabled);

  @override
  String toString() {
    return 'Gateway(name: $name, enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class _$GatewayCopyWith<$Res> implements $GatewayCopyWith<$Res> {
  factory _$GatewayCopyWith(_Gateway value, $Res Function(_Gateway) _then) = __$GatewayCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'name') String name, @JsonKey(name: 'enabled') bool enabled});
}

/// @nodoc
class __$GatewayCopyWithImpl<$Res> implements _$GatewayCopyWith<$Res> {
  __$GatewayCopyWithImpl(this._self, this._then);

  final _Gateway _self;
  final $Res Function(_Gateway) _then;

  /// Create a copy of Gateway
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? enabled = null,
  }) {
    return _then(_Gateway(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
