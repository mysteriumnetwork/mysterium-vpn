// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderSummary {

 String get country; String get currency; String get itemSubtotal; String get itemSubtotalBeforeDiscount; String get taxRate; String get taxSubtotal; String get taxSubtotalBeforeDiscount; String get taxType; String get totalPrice; String get totalPriceBeforeDiscount; String? get discountAmount; String? get discountUnits;
/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSummaryCopyWith<OrderSummary> get copyWith => _$OrderSummaryCopyWithImpl<OrderSummary>(this as OrderSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSummary&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.itemSubtotal, itemSubtotal) || other.itemSubtotal == itemSubtotal)&&(identical(other.itemSubtotalBeforeDiscount, itemSubtotalBeforeDiscount) || other.itemSubtotalBeforeDiscount == itemSubtotalBeforeDiscount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxSubtotal, taxSubtotal) || other.taxSubtotal == taxSubtotal)&&(identical(other.taxSubtotalBeforeDiscount, taxSubtotalBeforeDiscount) || other.taxSubtotalBeforeDiscount == taxSubtotalBeforeDiscount)&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.totalPriceBeforeDiscount, totalPriceBeforeDiscount) || other.totalPriceBeforeDiscount == totalPriceBeforeDiscount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountUnits, discountUnits) || other.discountUnits == discountUnits));
}


@override
int get hashCode => Object.hash(runtimeType,country,currency,itemSubtotal,itemSubtotalBeforeDiscount,taxRate,taxSubtotal,taxSubtotalBeforeDiscount,taxType,totalPrice,totalPriceBeforeDiscount,discountAmount,discountUnits);

@override
String toString() {
  return 'OrderSummary(country: $country, currency: $currency, itemSubtotal: $itemSubtotal, itemSubtotalBeforeDiscount: $itemSubtotalBeforeDiscount, taxRate: $taxRate, taxSubtotal: $taxSubtotal, taxSubtotalBeforeDiscount: $taxSubtotalBeforeDiscount, taxType: $taxType, totalPrice: $totalPrice, totalPriceBeforeDiscount: $totalPriceBeforeDiscount, discountAmount: $discountAmount, discountUnits: $discountUnits)';
}


}

/// @nodoc
abstract mixin class $OrderSummaryCopyWith<$Res>  {
  factory $OrderSummaryCopyWith(OrderSummary value, $Res Function(OrderSummary) _then) = _$OrderSummaryCopyWithImpl;
@useResult
$Res call({
 String country, String currency, String itemSubtotal, String itemSubtotalBeforeDiscount, String taxRate, String taxSubtotal, String taxSubtotalBeforeDiscount, String taxType, String totalPrice, String totalPriceBeforeDiscount, String? discountAmount, String? discountUnits
});




}
/// @nodoc
class _$OrderSummaryCopyWithImpl<$Res>
    implements $OrderSummaryCopyWith<$Res> {
  _$OrderSummaryCopyWithImpl(this._self, this._then);

  final OrderSummary _self;
  final $Res Function(OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? country = null,Object? currency = null,Object? itemSubtotal = null,Object? itemSubtotalBeforeDiscount = null,Object? taxRate = null,Object? taxSubtotal = null,Object? taxSubtotalBeforeDiscount = null,Object? taxType = null,Object? totalPrice = null,Object? totalPriceBeforeDiscount = null,Object? discountAmount = freezed,Object? discountUnits = freezed,}) {
  return _then(_self.copyWith(
country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,itemSubtotal: null == itemSubtotal ? _self.itemSubtotal : itemSubtotal // ignore: cast_nullable_to_non_nullable
as String,itemSubtotalBeforeDiscount: null == itemSubtotalBeforeDiscount ? _self.itemSubtotalBeforeDiscount : itemSubtotalBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxSubtotal: null == taxSubtotal ? _self.taxSubtotal : taxSubtotal // ignore: cast_nullable_to_non_nullable
as String,taxSubtotalBeforeDiscount: null == taxSubtotalBeforeDiscount ? _self.taxSubtotalBeforeDiscount : taxSubtotalBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,taxType: null == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,totalPriceBeforeDiscount: null == totalPriceBeforeDiscount ? _self.totalPriceBeforeDiscount : totalPriceBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,discountUnits: freezed == discountUnits ? _self.discountUnits : discountUnits // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderSummary].
extension OrderSummaryPatterns on OrderSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderSummary value)  $default,){
final _that = this;
switch (_that) {
case _OrderSummary():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String country,  String currency,  String itemSubtotal,  String itemSubtotalBeforeDiscount,  String taxRate,  String taxSubtotal,  String taxSubtotalBeforeDiscount,  String taxType,  String totalPrice,  String totalPriceBeforeDiscount,  String? discountAmount,  String? discountUnits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.country,_that.currency,_that.itemSubtotal,_that.itemSubtotalBeforeDiscount,_that.taxRate,_that.taxSubtotal,_that.taxSubtotalBeforeDiscount,_that.taxType,_that.totalPrice,_that.totalPriceBeforeDiscount,_that.discountAmount,_that.discountUnits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String country,  String currency,  String itemSubtotal,  String itemSubtotalBeforeDiscount,  String taxRate,  String taxSubtotal,  String taxSubtotalBeforeDiscount,  String taxType,  String totalPrice,  String totalPriceBeforeDiscount,  String? discountAmount,  String? discountUnits)  $default,) {final _that = this;
switch (_that) {
case _OrderSummary():
return $default(_that.country,_that.currency,_that.itemSubtotal,_that.itemSubtotalBeforeDiscount,_that.taxRate,_that.taxSubtotal,_that.taxSubtotalBeforeDiscount,_that.taxType,_that.totalPrice,_that.totalPriceBeforeDiscount,_that.discountAmount,_that.discountUnits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String country,  String currency,  String itemSubtotal,  String itemSubtotalBeforeDiscount,  String taxRate,  String taxSubtotal,  String taxSubtotalBeforeDiscount,  String taxType,  String totalPrice,  String totalPriceBeforeDiscount,  String? discountAmount,  String? discountUnits)?  $default,) {final _that = this;
switch (_that) {
case _OrderSummary() when $default != null:
return $default(_that.country,_that.currency,_that.itemSubtotal,_that.itemSubtotalBeforeDiscount,_that.taxRate,_that.taxSubtotal,_that.taxSubtotalBeforeDiscount,_that.taxType,_that.totalPrice,_that.totalPriceBeforeDiscount,_that.discountAmount,_that.discountUnits);case _:
  return null;

}
}

}

/// @nodoc


class _OrderSummary extends OrderSummary {
   _OrderSummary({required this.country, required this.currency, required this.itemSubtotal, required this.itemSubtotalBeforeDiscount, required this.taxRate, required this.taxSubtotal, required this.taxSubtotalBeforeDiscount, required this.taxType, required this.totalPrice, required this.totalPriceBeforeDiscount, this.discountAmount, this.discountUnits}): super._();
  

@override final  String country;
@override final  String currency;
@override final  String itemSubtotal;
@override final  String itemSubtotalBeforeDiscount;
@override final  String taxRate;
@override final  String taxSubtotal;
@override final  String taxSubtotalBeforeDiscount;
@override final  String taxType;
@override final  String totalPrice;
@override final  String totalPriceBeforeDiscount;
@override final  String? discountAmount;
@override final  String? discountUnits;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderSummaryCopyWith<_OrderSummary> get copyWith => __$OrderSummaryCopyWithImpl<_OrderSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderSummary&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.itemSubtotal, itemSubtotal) || other.itemSubtotal == itemSubtotal)&&(identical(other.itemSubtotalBeforeDiscount, itemSubtotalBeforeDiscount) || other.itemSubtotalBeforeDiscount == itemSubtotalBeforeDiscount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxSubtotal, taxSubtotal) || other.taxSubtotal == taxSubtotal)&&(identical(other.taxSubtotalBeforeDiscount, taxSubtotalBeforeDiscount) || other.taxSubtotalBeforeDiscount == taxSubtotalBeforeDiscount)&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.totalPriceBeforeDiscount, totalPriceBeforeDiscount) || other.totalPriceBeforeDiscount == totalPriceBeforeDiscount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountUnits, discountUnits) || other.discountUnits == discountUnits));
}


@override
int get hashCode => Object.hash(runtimeType,country,currency,itemSubtotal,itemSubtotalBeforeDiscount,taxRate,taxSubtotal,taxSubtotalBeforeDiscount,taxType,totalPrice,totalPriceBeforeDiscount,discountAmount,discountUnits);

@override
String toString() {
  return 'OrderSummary(country: $country, currency: $currency, itemSubtotal: $itemSubtotal, itemSubtotalBeforeDiscount: $itemSubtotalBeforeDiscount, taxRate: $taxRate, taxSubtotal: $taxSubtotal, taxSubtotalBeforeDiscount: $taxSubtotalBeforeDiscount, taxType: $taxType, totalPrice: $totalPrice, totalPriceBeforeDiscount: $totalPriceBeforeDiscount, discountAmount: $discountAmount, discountUnits: $discountUnits)';
}


}

/// @nodoc
abstract mixin class _$OrderSummaryCopyWith<$Res> implements $OrderSummaryCopyWith<$Res> {
  factory _$OrderSummaryCopyWith(_OrderSummary value, $Res Function(_OrderSummary) _then) = __$OrderSummaryCopyWithImpl;
@override @useResult
$Res call({
 String country, String currency, String itemSubtotal, String itemSubtotalBeforeDiscount, String taxRate, String taxSubtotal, String taxSubtotalBeforeDiscount, String taxType, String totalPrice, String totalPriceBeforeDiscount, String? discountAmount, String? discountUnits
});




}
/// @nodoc
class __$OrderSummaryCopyWithImpl<$Res>
    implements _$OrderSummaryCopyWith<$Res> {
  __$OrderSummaryCopyWithImpl(this._self, this._then);

  final _OrderSummary _self;
  final $Res Function(_OrderSummary) _then;

/// Create a copy of OrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? country = null,Object? currency = null,Object? itemSubtotal = null,Object? itemSubtotalBeforeDiscount = null,Object? taxRate = null,Object? taxSubtotal = null,Object? taxSubtotalBeforeDiscount = null,Object? taxType = null,Object? totalPrice = null,Object? totalPriceBeforeDiscount = null,Object? discountAmount = freezed,Object? discountUnits = freezed,}) {
  return _then(_OrderSummary(
country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,itemSubtotal: null == itemSubtotal ? _self.itemSubtotal : itemSubtotal // ignore: cast_nullable_to_non_nullable
as String,itemSubtotalBeforeDiscount: null == itemSubtotalBeforeDiscount ? _self.itemSubtotalBeforeDiscount : itemSubtotalBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as String,taxSubtotal: null == taxSubtotal ? _self.taxSubtotal : taxSubtotal // ignore: cast_nullable_to_non_nullable
as String,taxSubtotalBeforeDiscount: null == taxSubtotalBeforeDiscount ? _self.taxSubtotalBeforeDiscount : taxSubtotalBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,taxType: null == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as String,totalPriceBeforeDiscount: null == totalPriceBeforeDiscount ? _self.totalPriceBeforeDiscount : totalPriceBeforeDiscount // ignore: cast_nullable_to_non_nullable
as String,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String?,discountUnits: freezed == discountUnits ? _self.discountUnits : discountUnits // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
