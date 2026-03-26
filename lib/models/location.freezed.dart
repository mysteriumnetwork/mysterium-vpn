// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VPNLocations {

 Set<VPNLocation> get allLocations; Set<VPNLocation> get allLocationsFlattened; bool get isEmpty; List<VPNLocation> get locations; List<VPNLocation> get topLocations;
/// Create a copy of VPNLocations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VPNLocationsCopyWith<VPNLocations> get copyWith => _$VPNLocationsCopyWithImpl<VPNLocations>(this as VPNLocations, _$identity);

  /// Serializes this VPNLocations to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VPNLocations&&const DeepCollectionEquality().equals(other.allLocations, allLocations)&&const DeepCollectionEquality().equals(other.allLocationsFlattened, allLocationsFlattened)&&(identical(other.isEmpty, isEmpty) || other.isEmpty == isEmpty)&&const DeepCollectionEquality().equals(other.locations, locations)&&const DeepCollectionEquality().equals(other.topLocations, topLocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(allLocations),const DeepCollectionEquality().hash(allLocationsFlattened),isEmpty,const DeepCollectionEquality().hash(locations),const DeepCollectionEquality().hash(topLocations));

@override
String toString() {
  return 'VPNLocations(allLocations: $allLocations, allLocationsFlattened: $allLocationsFlattened, isEmpty: $isEmpty, locations: $locations, topLocations: $topLocations)';
}


}

/// @nodoc
abstract mixin class $VPNLocationsCopyWith<$Res>  {
  factory $VPNLocationsCopyWith(VPNLocations value, $Res Function(VPNLocations) _then) = _$VPNLocationsCopyWithImpl;
@useResult
$Res call({
 List<VPNLocation> locations, List<VPNLocation> topLocations
});




}
/// @nodoc
class _$VPNLocationsCopyWithImpl<$Res>
    implements $VPNLocationsCopyWith<$Res> {
  _$VPNLocationsCopyWithImpl(this._self, this._then);

  final VPNLocations _self;
  final $Res Function(VPNLocations) _then;

/// Create a copy of VPNLocations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locations = null,Object? topLocations = null,}) {
  return _then(_self.copyWith(
locations: null == locations ? _self.locations : locations // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>,topLocations: null == topLocations ? _self.topLocations : topLocations // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>,
  ));
}

}


/// Adds pattern-matching-related methods to [VPNLocations].
extension VPNLocationsPatterns on VPNLocations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VPNLocations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VPNLocations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VPNLocations value)  $default,){
final _that = this;
switch (_that) {
case _VPNLocations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VPNLocations value)?  $default,){
final _that = this;
switch (_that) {
case _VPNLocations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VPNLocation> locations,  List<VPNLocation> topLocations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VPNLocations() when $default != null:
return $default(_that.locations,_that.topLocations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VPNLocation> locations,  List<VPNLocation> topLocations)  $default,) {final _that = this;
switch (_that) {
case _VPNLocations():
return $default(_that.locations,_that.topLocations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VPNLocation> locations,  List<VPNLocation> topLocations)?  $default,) {final _that = this;
switch (_that) {
case _VPNLocations() when $default != null:
return $default(_that.locations,_that.topLocations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VPNLocations extends VPNLocations {
   _VPNLocations({final  List<VPNLocation> locations = const [], final  List<VPNLocation> topLocations = const []}): _locations = locations,_topLocations = topLocations,super._();
  factory _VPNLocations.fromJson(Map<String, dynamic> json) => _$VPNLocationsFromJson(json);

 final  List<VPNLocation> _locations;
@override@JsonKey() List<VPNLocation> get locations {
  if (_locations is EqualUnmodifiableListView) return _locations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_locations);
}

 final  List<VPNLocation> _topLocations;
@override@JsonKey() List<VPNLocation> get topLocations {
  if (_topLocations is EqualUnmodifiableListView) return _topLocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topLocations);
}


/// Create a copy of VPNLocations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VPNLocationsCopyWith<_VPNLocations> get copyWith => __$VPNLocationsCopyWithImpl<_VPNLocations>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VPNLocationsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VPNLocations&&const DeepCollectionEquality().equals(other._locations, _locations)&&const DeepCollectionEquality().equals(other._topLocations, _topLocations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_locations),const DeepCollectionEquality().hash(_topLocations));

@override
String toString() {
  return 'VPNLocations(locations: $locations, topLocations: $topLocations)';
}


}

/// @nodoc
abstract mixin class _$VPNLocationsCopyWith<$Res> implements $VPNLocationsCopyWith<$Res> {
  factory _$VPNLocationsCopyWith(_VPNLocations value, $Res Function(_VPNLocations) _then) = __$VPNLocationsCopyWithImpl;
@override @useResult
$Res call({
 List<VPNLocation> locations, List<VPNLocation> topLocations
});




}
/// @nodoc
class __$VPNLocationsCopyWithImpl<$Res>
    implements _$VPNLocationsCopyWith<$Res> {
  __$VPNLocationsCopyWithImpl(this._self, this._then);

  final _VPNLocations _self;
  final $Res Function(_VPNLocations) _then;

/// Create a copy of VPNLocations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locations = null,Object? topLocations = null,}) {
  return _then(_VPNLocations(
locations: null == locations ? _self._locations : locations // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>,topLocations: null == topLocations ? _self._topLocations : topLocations // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>,
  ));
}


}


/// @nodoc
mixin _$VPNLocation {

 String get id; IPType get ipType; Map<String, String> get translations; String get countryCode;@LatLngConverter() LatLng? get coordinates; List<VPNLocation>? get children; int? get nodeCount; bool get isAvailable;
/// Create a copy of VPNLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VPNLocationCopyWith<VPNLocation> get copyWith => _$VPNLocationCopyWithImpl<VPNLocation>(this as VPNLocation, _$identity);

  /// Serializes this VPNLocation to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'VPNLocation(id: $id, ipType: $ipType, translations: $translations, countryCode: $countryCode, coordinates: $coordinates, children: $children, nodeCount: $nodeCount, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $VPNLocationCopyWith<$Res>  {
  factory $VPNLocationCopyWith(VPNLocation value, $Res Function(VPNLocation) _then) = _$VPNLocationCopyWithImpl;
@useResult
$Res call({
 String id, IPType ipType, Map<String, String> translations, String countryCode,@LatLngConverter() LatLng? coordinates, List<VPNLocation>? children, int? nodeCount, bool isAvailable
});




}
/// @nodoc
class _$VPNLocationCopyWithImpl<$Res>
    implements $VPNLocationCopyWith<$Res> {
  _$VPNLocationCopyWithImpl(this._self, this._then);

  final VPNLocation _self;
  final $Res Function(VPNLocation) _then;

/// Create a copy of VPNLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ipType = null,Object? translations = null,Object? countryCode = null,Object? coordinates = freezed,Object? children = freezed,Object? nodeCount = freezed,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ipType: null == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as IPType,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, String>,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as LatLng?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>?,nodeCount: freezed == nodeCount ? _self.nodeCount : nodeCount // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VPNLocation].
extension VPNLocationPatterns on VPNLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VPNLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VPNLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VPNLocation value)  $default,){
final _that = this;
switch (_that) {
case _VPNLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VPNLocation value)?  $default,){
final _that = this;
switch (_that) {
case _VPNLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  IPType ipType,  Map<String, String> translations,  String countryCode, @LatLngConverter()  LatLng? coordinates,  List<VPNLocation>? children,  int? nodeCount,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VPNLocation() when $default != null:
return $default(_that.id,_that.ipType,_that.translations,_that.countryCode,_that.coordinates,_that.children,_that.nodeCount,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  IPType ipType,  Map<String, String> translations,  String countryCode, @LatLngConverter()  LatLng? coordinates,  List<VPNLocation>? children,  int? nodeCount,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _VPNLocation():
return $default(_that.id,_that.ipType,_that.translations,_that.countryCode,_that.coordinates,_that.children,_that.nodeCount,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  IPType ipType,  Map<String, String> translations,  String countryCode, @LatLngConverter()  LatLng? coordinates,  List<VPNLocation>? children,  int? nodeCount,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _VPNLocation() when $default != null:
return $default(_that.id,_that.ipType,_that.translations,_that.countryCode,_that.coordinates,_that.children,_that.nodeCount,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VPNLocation extends VPNLocation {
  const _VPNLocation({required this.id, required this.ipType, required final  Map<String, String> translations, required this.countryCode, @LatLngConverter() this.coordinates, final  List<VPNLocation>? children, this.nodeCount, this.isAvailable = true}): _translations = translations,_children = children,super._();
  factory _VPNLocation.fromJson(Map<String, dynamic> json) => _$VPNLocationFromJson(json);

@override final  String id;
@override final  IPType ipType;
 final  Map<String, String> _translations;
@override Map<String, String> get translations {
  if (_translations is EqualUnmodifiableMapView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translations);
}

@override final  String countryCode;
@override@LatLngConverter() final  LatLng? coordinates;
 final  List<VPNLocation>? _children;
@override List<VPNLocation>? get children {
  final value = _children;
  if (value == null) return null;
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? nodeCount;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of VPNLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VPNLocationCopyWith<_VPNLocation> get copyWith => __$VPNLocationCopyWithImpl<_VPNLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VPNLocationToJson(this, );
}



@override
String toString() {
  return 'VPNLocation(id: $id, ipType: $ipType, translations: $translations, countryCode: $countryCode, coordinates: $coordinates, children: $children, nodeCount: $nodeCount, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$VPNLocationCopyWith<$Res> implements $VPNLocationCopyWith<$Res> {
  factory _$VPNLocationCopyWith(_VPNLocation value, $Res Function(_VPNLocation) _then) = __$VPNLocationCopyWithImpl;
@override @useResult
$Res call({
 String id, IPType ipType, Map<String, String> translations, String countryCode,@LatLngConverter() LatLng? coordinates, List<VPNLocation>? children, int? nodeCount, bool isAvailable
});




}
/// @nodoc
class __$VPNLocationCopyWithImpl<$Res>
    implements _$VPNLocationCopyWith<$Res> {
  __$VPNLocationCopyWithImpl(this._self, this._then);

  final _VPNLocation _self;
  final $Res Function(_VPNLocation) _then;

/// Create a copy of VPNLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ipType = null,Object? translations = null,Object? countryCode = null,Object? coordinates = freezed,Object? children = freezed,Object? nodeCount = freezed,Object? isAvailable = null,}) {
  return _then(_VPNLocation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ipType: null == ipType ? _self.ipType : ipType // ignore: cast_nullable_to_non_nullable
as IPType,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, String>,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as LatLng?,children: freezed == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<VPNLocation>?,nodeCount: freezed == nodeCount ? _self.nodeCount : nodeCount // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
