// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductOffer {
  String? get id;
  double get price;
  double get fullPrice;
  OfferDuration get durationUnit;
  int get durationValue;

  /// Create a copy of ProductOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductOfferCopyWith<ProductOffer> get copyWith =>
      _$ProductOfferCopyWithImpl<ProductOffer>(this as ProductOffer, _$identity);

  /// Serializes this ProductOffer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductOffer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.fullPrice, fullPrice) || other.fullPrice == fullPrice) &&
            (identical(other.durationUnit, durationUnit) || other.durationUnit == durationUnit) &&
            (identical(other.durationValue, durationValue) ||
                other.durationValue == durationValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, fullPrice, durationUnit, durationValue);

  @override
  String toString() {
    return 'ProductOffer(id: $id, price: $price, fullPrice: $fullPrice, durationUnit: $durationUnit, durationValue: $durationValue)';
  }
}

/// @nodoc
abstract mixin class $ProductOfferCopyWith<$Res> {
  factory $ProductOfferCopyWith(ProductOffer value, $Res Function(ProductOffer) _then) =
      _$ProductOfferCopyWithImpl;
  @useResult
  $Res call(
      {String? id, double price, double fullPrice, OfferDuration durationUnit, int durationValue});
}

/// @nodoc
class _$ProductOfferCopyWithImpl<$Res> implements $ProductOfferCopyWith<$Res> {
  _$ProductOfferCopyWithImpl(this._self, this._then);

  final ProductOffer _self;
  final $Res Function(ProductOffer) _then;

  /// Create a copy of ProductOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? price = null,
    Object? fullPrice = null,
    Object? durationUnit = null,
    Object? durationValue = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      fullPrice: null == fullPrice
          ? _self.fullPrice
          : fullPrice // ignore: cast_nullable_to_non_nullable
              as double,
      durationUnit: null == durationUnit
          ? _self.durationUnit
          : durationUnit // ignore: cast_nullable_to_non_nullable
              as OfferDuration,
      durationValue: null == durationValue
          ? _self.durationValue
          : durationValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductOffer].
extension ProductOfferPatterns on ProductOffer {
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
    TResult Function(_ProductOffer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductOffer() when $default != null:
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
    TResult Function(_ProductOffer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductOffer():
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
    TResult? Function(_ProductOffer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductOffer() when $default != null:
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
    TResult Function(String? id, double price, double fullPrice, OfferDuration durationUnit,
            int durationValue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductOffer() when $default != null:
        return $default(
            _that.id, _that.price, _that.fullPrice, _that.durationUnit, _that.durationValue);
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
    TResult Function(String? id, double price, double fullPrice, OfferDuration durationUnit,
            int durationValue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductOffer():
        return $default(
            _that.id, _that.price, _that.fullPrice, _that.durationUnit, _that.durationValue);
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
    TResult? Function(String? id, double price, double fullPrice, OfferDuration durationUnit,
            int durationValue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductOffer() when $default != null:
        return $default(
            _that.id, _that.price, _that.fullPrice, _that.durationUnit, _that.durationValue);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductOffer extends ProductOffer {
  _ProductOffer(
      {required this.id,
      required this.price,
      required this.fullPrice,
      required this.durationUnit,
      required this.durationValue})
      : super._();
  factory _ProductOffer.fromJson(Map<String, dynamic> json) => _$ProductOfferFromJson(json);

  @override
  final String? id;
  @override
  final double price;
  @override
  final double fullPrice;
  @override
  final OfferDuration durationUnit;
  @override
  final int durationValue;

  /// Create a copy of ProductOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductOfferCopyWith<_ProductOffer> get copyWith =>
      __$ProductOfferCopyWithImpl<_ProductOffer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductOfferToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductOffer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.fullPrice, fullPrice) || other.fullPrice == fullPrice) &&
            (identical(other.durationUnit, durationUnit) || other.durationUnit == durationUnit) &&
            (identical(other.durationValue, durationValue) ||
                other.durationValue == durationValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, fullPrice, durationUnit, durationValue);

  @override
  String toString() {
    return 'ProductOffer(id: $id, price: $price, fullPrice: $fullPrice, durationUnit: $durationUnit, durationValue: $durationValue)';
  }
}

/// @nodoc
abstract mixin class _$ProductOfferCopyWith<$Res> implements $ProductOfferCopyWith<$Res> {
  factory _$ProductOfferCopyWith(_ProductOffer value, $Res Function(_ProductOffer) _then) =
      __$ProductOfferCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id, double price, double fullPrice, OfferDuration durationUnit, int durationValue});
}

/// @nodoc
class __$ProductOfferCopyWithImpl<$Res> implements _$ProductOfferCopyWith<$Res> {
  __$ProductOfferCopyWithImpl(this._self, this._then);

  final _ProductOffer _self;
  final $Res Function(_ProductOffer) _then;

  /// Create a copy of ProductOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? price = null,
    Object? fullPrice = null,
    Object? durationUnit = null,
    Object? durationValue = null,
  }) {
    return _then(_ProductOffer(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      fullPrice: null == fullPrice
          ? _self.fullPrice
          : fullPrice // ignore: cast_nullable_to_non_nullable
              as double,
      durationUnit: null == durationUnit
          ? _self.durationUnit
          : durationUnit // ignore: cast_nullable_to_non_nullable
              as OfferDuration,
      durationValue: null == durationValue
          ? _self.durationValue
          : durationValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
