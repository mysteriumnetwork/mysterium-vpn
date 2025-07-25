// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VPNLocations _$VPNLocationsFromJson(Map<String, dynamic> json) {
  return _VPNLocations.fromJson(json);
}

/// @nodoc
mixin _$VPNLocations {
  List<VPNLocation> get locations => throw _privateConstructorUsedError;
  List<VPNLocation> get topLocations => throw _privateConstructorUsedError;

  /// Serializes this VPNLocations to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VPNLocations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VPNLocationsCopyWith<VPNLocations> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VPNLocationsCopyWith<$Res> {
  factory $VPNLocationsCopyWith(VPNLocations value, $Res Function(VPNLocations) then) =
      _$VPNLocationsCopyWithImpl<$Res, VPNLocations>;
  @useResult
  $Res call({List<VPNLocation> locations, List<VPNLocation> topLocations});
}

/// @nodoc
class _$VPNLocationsCopyWithImpl<$Res, $Val extends VPNLocations>
    implements $VPNLocationsCopyWith<$Res> {
  _$VPNLocationsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VPNLocations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = null,
    Object? topLocations = null,
  }) {
    return _then(_value.copyWith(
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<VPNLocation>,
      topLocations: null == topLocations
          ? _value.topLocations
          : topLocations // ignore: cast_nullable_to_non_nullable
              as List<VPNLocation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VPNLocationsImplCopyWith<$Res> implements $VPNLocationsCopyWith<$Res> {
  factory _$$VPNLocationsImplCopyWith(
          _$VPNLocationsImpl value, $Res Function(_$VPNLocationsImpl) then) =
      __$$VPNLocationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<VPNLocation> locations, List<VPNLocation> topLocations});
}

/// @nodoc
class __$$VPNLocationsImplCopyWithImpl<$Res>
    extends _$VPNLocationsCopyWithImpl<$Res, _$VPNLocationsImpl>
    implements _$$VPNLocationsImplCopyWith<$Res> {
  __$$VPNLocationsImplCopyWithImpl(
      _$VPNLocationsImpl _value, $Res Function(_$VPNLocationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VPNLocations
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = null,
    Object? topLocations = null,
  }) {
    return _then(_$VPNLocationsImpl(
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<VPNLocation>,
      topLocations: null == topLocations
          ? _value._topLocations
          : topLocations // ignore: cast_nullable_to_non_nullable
              as List<VPNLocation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VPNLocationsImpl extends _VPNLocations {
  _$VPNLocationsImpl(
      {final List<VPNLocation> locations = const [],
      final List<VPNLocation> topLocations = const []})
      : _locations = locations,
        _topLocations = topLocations,
        super._();

  factory _$VPNLocationsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VPNLocationsImplFromJson(json);

  final List<VPNLocation> _locations;
  @override
  @JsonKey()
  List<VPNLocation> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  final List<VPNLocation> _topLocations;
  @override
  @JsonKey()
  List<VPNLocation> get topLocations {
    if (_topLocations is EqualUnmodifiableListView) return _topLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topLocations);
  }

  @override
  String toString() {
    return 'VPNLocations(locations: $locations, topLocations: $topLocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VPNLocationsImpl &&
            const DeepCollectionEquality().equals(other._locations, _locations) &&
            const DeepCollectionEquality().equals(other._topLocations, _topLocations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_locations),
      const DeepCollectionEquality().hash(_topLocations));

  /// Create a copy of VPNLocations
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VPNLocationsImplCopyWith<_$VPNLocationsImpl> get copyWith =>
      __$$VPNLocationsImplCopyWithImpl<_$VPNLocationsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VPNLocationsImplToJson(
      this,
    );
  }
}

abstract class _VPNLocations extends VPNLocations {
  factory _VPNLocations({final List<VPNLocation> locations, final List<VPNLocation> topLocations}) =
      _$VPNLocationsImpl;
  _VPNLocations._() : super._();

  factory _VPNLocations.fromJson(Map<String, dynamic> json) = _$VPNLocationsImpl.fromJson;

  @override
  List<VPNLocation> get locations;
  @override
  List<VPNLocation> get topLocations;

  /// Create a copy of VPNLocations
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VPNLocationsImplCopyWith<_$VPNLocationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VPNLocation _$VPNLocationFromJson(Map<String, dynamic> json) {
  return _VPNLocation.fromJson(json);
}

/// @nodoc
mixin _$VPNLocation {
  String get id => throw _privateConstructorUsedError;
  IPType get ipType => throw _privateConstructorUsedError;
  Map<String, String> get translations => throw _privateConstructorUsedError;
  VPNLocation? get parent => throw _privateConstructorUsedError;

  /// Serializes this VPNLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VPNLocationCopyWith<VPNLocation> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VPNLocationCopyWith<$Res> {
  factory $VPNLocationCopyWith(VPNLocation value, $Res Function(VPNLocation) then) =
      _$VPNLocationCopyWithImpl<$Res, VPNLocation>;
  @useResult
  $Res call({String id, IPType ipType, Map<String, String> translations, VPNLocation? parent});

  $VPNLocationCopyWith<$Res>? get parent;
}

/// @nodoc
class _$VPNLocationCopyWithImpl<$Res, $Val extends VPNLocation>
    implements $VPNLocationCopyWith<$Res> {
  _$VPNLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ipType = null,
    Object? translations = null,
    Object? parent = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ipType: null == ipType
          ? _value.ipType
          : ipType // ignore: cast_nullable_to_non_nullable
              as IPType,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as VPNLocation?,
    ) as $Val);
  }

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VPNLocationCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $VPNLocationCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VPNLocationImplCopyWith<$Res> implements $VPNLocationCopyWith<$Res> {
  factory _$$VPNLocationImplCopyWith(
          _$VPNLocationImpl value, $Res Function(_$VPNLocationImpl) then) =
      __$$VPNLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, IPType ipType, Map<String, String> translations, VPNLocation? parent});

  @override
  $VPNLocationCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$VPNLocationImplCopyWithImpl<$Res>
    extends _$VPNLocationCopyWithImpl<$Res, _$VPNLocationImpl>
    implements _$$VPNLocationImplCopyWith<$Res> {
  __$$VPNLocationImplCopyWithImpl(_$VPNLocationImpl _value, $Res Function(_$VPNLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ipType = null,
    Object? translations = null,
    Object? parent = freezed,
  }) {
    return _then(_$VPNLocationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ipType: null == ipType
          ? _value.ipType
          : ipType // ignore: cast_nullable_to_non_nullable
              as IPType,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as VPNLocation?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VPNLocationImpl extends _VPNLocation {
  const _$VPNLocationImpl(
      {required this.id,
      required this.ipType,
      required final Map<String, String> translations,
      this.parent})
      : _translations = translations,
        super._();

  factory _$VPNLocationImpl.fromJson(Map<String, dynamic> json) => _$$VPNLocationImplFromJson(json);

  @override
  final String id;
  @override
  final IPType ipType;
  final Map<String, String> _translations;
  @override
  Map<String, String> get translations {
    if (_translations is EqualUnmodifiableMapView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_translations);
  }

  @override
  final VPNLocation? parent;

  @override
  String toString() {
    return 'VPNLocation(id: $id, ipType: $ipType, translations: $translations, parent: $parent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VPNLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ipType, ipType) || other.ipType == ipType) &&
            const DeepCollectionEquality().equals(other._translations, _translations) &&
            (identical(other.parent, parent) || other.parent == parent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, ipType, const DeepCollectionEquality().hash(_translations), parent);

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VPNLocationImplCopyWith<_$VPNLocationImpl> get copyWith =>
      __$$VPNLocationImplCopyWithImpl<_$VPNLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VPNLocationImplToJson(
      this,
    );
  }
}

abstract class _VPNLocation extends VPNLocation {
  const factory _VPNLocation(
      {required final String id,
      required final IPType ipType,
      required final Map<String, String> translations,
      final VPNLocation? parent}) = _$VPNLocationImpl;
  const _VPNLocation._() : super._();

  factory _VPNLocation.fromJson(Map<String, dynamic> json) = _$VPNLocationImpl.fromJson;

  @override
  String get id;
  @override
  IPType get ipType;
  @override
  Map<String, String> get translations;
  @override
  VPNLocation? get parent;

  /// Create a copy of VPNLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VPNLocationImplCopyWith<_$VPNLocationImpl> get copyWith => throw _privateConstructorUsedError;
}
