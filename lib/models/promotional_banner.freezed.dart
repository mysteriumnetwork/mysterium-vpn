// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotional_banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromotionalBanner {
  String get id;
  String get title;
  String? get iconUrl;
  Map<String, String>? get localizedTitles;
  String? get redirectUrl;
  DateTime? get startDate;
  DateTime? get endDate;

  /// Create a copy of PromotionalBanner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PromotionalBannerCopyWith<PromotionalBanner> get copyWith =>
      _$PromotionalBannerCopyWithImpl<PromotionalBanner>(this as PromotionalBanner, _$identity);

  /// Serializes this PromotionalBanner to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PromotionalBanner &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other.localizedTitles, localizedTitles) &&
            (identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, iconUrl,
      const DeepCollectionEquality().hash(localizedTitles), redirectUrl, startDate, endDate);

  @override
  String toString() {
    return 'PromotionalBanner(id: $id, title: $title, iconUrl: $iconUrl, localizedTitles: $localizedTitles, redirectUrl: $redirectUrl, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $PromotionalBannerCopyWith<$Res> {
  factory $PromotionalBannerCopyWith(
          PromotionalBanner value, $Res Function(PromotionalBanner) _then) =
      _$PromotionalBannerCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String? iconUrl,
      Map<String, String>? localizedTitles,
      String? redirectUrl,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class _$PromotionalBannerCopyWithImpl<$Res> implements $PromotionalBannerCopyWith<$Res> {
  _$PromotionalBannerCopyWithImpl(this._self, this._then);

  final PromotionalBanner _self;
  final $Res Function(PromotionalBanner) _then;

  /// Create a copy of PromotionalBanner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? iconUrl = freezed,
    Object? localizedTitles = freezed,
    Object? redirectUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localizedTitles: freezed == localizedTitles
          ? _self.localizedTitles
          : localizedTitles // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      redirectUrl: freezed == redirectUrl
          ? _self.redirectUrl
          : redirectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PromotionalBanner].
extension PromotionalBannerPatterns on PromotionalBanner {
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
    TResult Function(_PromotionalBanner value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner() when $default != null:
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
    TResult Function(_PromotionalBanner value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner():
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
    TResult? Function(_PromotionalBanner value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner() when $default != null:
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
    TResult Function(String id, String title, String? iconUrl, Map<String, String>? localizedTitles,
            String? redirectUrl, DateTime? startDate, DateTime? endDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner() when $default != null:
        return $default(_that.id, _that.title, _that.iconUrl, _that.localizedTitles,
            _that.redirectUrl, _that.startDate, _that.endDate);
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
    TResult Function(String id, String title, String? iconUrl, Map<String, String>? localizedTitles,
            String? redirectUrl, DateTime? startDate, DateTime? endDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner():
        return $default(_that.id, _that.title, _that.iconUrl, _that.localizedTitles,
            _that.redirectUrl, _that.startDate, _that.endDate);
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
            String id,
            String title,
            String? iconUrl,
            Map<String, String>? localizedTitles,
            String? redirectUrl,
            DateTime? startDate,
            DateTime? endDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PromotionalBanner() when $default != null:
        return $default(_that.id, _that.title, _that.iconUrl, _that.localizedTitles,
            _that.redirectUrl, _that.startDate, _that.endDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PromotionalBanner implements PromotionalBanner {
  _PromotionalBanner(
      {required this.id,
      required this.title,
      this.iconUrl,
      final Map<String, String>? localizedTitles,
      this.redirectUrl,
      this.startDate,
      this.endDate})
      : _localizedTitles = localizedTitles;
  factory _PromotionalBanner.fromJson(Map<String, dynamic> json) =>
      _$PromotionalBannerFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? iconUrl;
  final Map<String, String>? _localizedTitles;
  @override
  Map<String, String>? get localizedTitles {
    final value = _localizedTitles;
    if (value == null) return null;
    if (_localizedTitles is EqualUnmodifiableMapView) return _localizedTitles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? redirectUrl;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  /// Create a copy of PromotionalBanner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PromotionalBannerCopyWith<_PromotionalBanner> get copyWith =>
      __$PromotionalBannerCopyWithImpl<_PromotionalBanner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PromotionalBannerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PromotionalBanner &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other._localizedTitles, _localizedTitles) &&
            (identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl) &&
            (identical(other.startDate, startDate) || other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, iconUrl,
      const DeepCollectionEquality().hash(_localizedTitles), redirectUrl, startDate, endDate);

  @override
  String toString() {
    return 'PromotionalBanner(id: $id, title: $title, iconUrl: $iconUrl, localizedTitles: $localizedTitles, redirectUrl: $redirectUrl, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$PromotionalBannerCopyWith<$Res> implements $PromotionalBannerCopyWith<$Res> {
  factory _$PromotionalBannerCopyWith(
          _PromotionalBanner value, $Res Function(_PromotionalBanner) _then) =
      __$PromotionalBannerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? iconUrl,
      Map<String, String>? localizedTitles,
      String? redirectUrl,
      DateTime? startDate,
      DateTime? endDate});
}

/// @nodoc
class __$PromotionalBannerCopyWithImpl<$Res> implements _$PromotionalBannerCopyWith<$Res> {
  __$PromotionalBannerCopyWithImpl(this._self, this._then);

  final _PromotionalBanner _self;
  final $Res Function(_PromotionalBanner) _then;

  /// Create a copy of PromotionalBanner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? iconUrl = freezed,
    Object? localizedTitles = freezed,
    Object? redirectUrl = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_PromotionalBanner(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _self.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      localizedTitles: freezed == localizedTitles
          ? _self._localizedTitles
          : localizedTitles // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      redirectUrl: freezed == redirectUrl
          ? _self.redirectUrl
          : redirectUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
