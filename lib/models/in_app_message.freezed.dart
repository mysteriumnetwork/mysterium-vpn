// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_app_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
InAppMessage _$InAppMessageFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'popup':
      return InAppPopup.fromJson(json);
    case 'banner':
      return InAppBanner.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'InAppMessage', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$InAppMessage {
  String get id;
  String get title;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppMessageCopyWith<InAppMessage> get copyWith =>
      _$InAppMessageCopyWithImpl<InAppMessage>(this as InAppMessage, _$identity);

  /// Serializes this InAppMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title);

  @override
  String toString() {
    return 'InAppMessage(id: $id, title: $title)';
  }
}

/// @nodoc
abstract mixin class $InAppMessageCopyWith<$Res> {
  factory $InAppMessageCopyWith(InAppMessage value, $Res Function(InAppMessage) _then) =
      _$InAppMessageCopyWithImpl;
  @useResult
  $Res call({String id, String title});
}

/// @nodoc
class _$InAppMessageCopyWithImpl<$Res> implements $InAppMessageCopyWith<$Res> {
  _$InAppMessageCopyWithImpl(this._self, this._then);

  final InAppMessage _self;
  final $Res Function(InAppMessage) _then;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [InAppMessage].
extension InAppMessagePatterns on InAppMessage {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InAppPopup value)? popup,
    TResult Function(InAppBanner value)? banner,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup() when popup != null:
        return popup(_that);
      case InAppBanner() when banner != null:
        return banner(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(InAppPopup value) popup,
    required TResult Function(InAppBanner value) banner,
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup():
        return popup(_that);
      case InAppBanner():
        return banner(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InAppPopup value)? popup,
    TResult? Function(InAppBanner value)? banner,
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup() when popup != null:
        return popup(_that);
      case InAppBanner() when banner != null:
        return banner(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String title, String? message, String? imageUrl,
            List<InAppMessageAction> actions)?
        popup,
    TResult Function(String id, String title, String? iconUrl, InAppMessageAction? action)? banner,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup() when popup != null:
        return popup(_that.id, _that.title, _that.message, _that.imageUrl, _that.actions);
      case InAppBanner() when banner != null:
        return banner(_that.id, _that.title, _that.iconUrl, _that.action);
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
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String title, String? message, String? imageUrl,
            List<InAppMessageAction> actions)
        popup,
    required TResult Function(String id, String title, String? iconUrl, InAppMessageAction? action)
        banner,
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup():
        return popup(_that.id, _that.title, _that.message, _that.imageUrl, _that.actions);
      case InAppBanner():
        return banner(_that.id, _that.title, _that.iconUrl, _that.action);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String title, String? message, String? imageUrl,
            List<InAppMessageAction> actions)?
        popup,
    TResult? Function(String id, String title, String? iconUrl, InAppMessageAction? action)? banner,
  }) {
    final _that = this;
    switch (_that) {
      case InAppPopup() when popup != null:
        return popup(_that.id, _that.title, _that.message, _that.imageUrl, _that.actions);
      case InAppBanner() when banner != null:
        return banner(_that.id, _that.title, _that.iconUrl, _that.action);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class InAppPopup extends InAppMessage {
  const InAppPopup(
      {required this.id,
      required this.title,
      required this.message,
      required this.imageUrl,
      required final List<InAppMessageAction> actions,
      final String? $type})
      : _actions = actions,
        $type = $type ?? 'popup',
        super._();
  factory InAppPopup.fromJson(Map<String, dynamic> json) => _$InAppPopupFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final String? message;
  final String? imageUrl;
  final List<InAppMessageAction> _actions;
  List<InAppMessageAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppPopupCopyWith<InAppPopup> get copyWith =>
      _$InAppPopupCopyWithImpl<InAppPopup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InAppPopupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppPopup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._actions, _actions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, message, imageUrl, const DeepCollectionEquality().hash(_actions));

  @override
  String toString() {
    return 'InAppMessage.popup(id: $id, title: $title, message: $message, imageUrl: $imageUrl, actions: $actions)';
  }
}

/// @nodoc
abstract mixin class $InAppPopupCopyWith<$Res> implements $InAppMessageCopyWith<$Res> {
  factory $InAppPopupCopyWith(InAppPopup value, $Res Function(InAppPopup) _then) =
      _$InAppPopupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? message,
      String? imageUrl,
      List<InAppMessageAction> actions});
}

/// @nodoc
class _$InAppPopupCopyWithImpl<$Res> implements $InAppPopupCopyWith<$Res> {
  _$InAppPopupCopyWithImpl(this._self, this._then);

  final InAppPopup _self;
  final $Res Function(InAppPopup) _then;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = freezed,
    Object? imageUrl = freezed,
    Object? actions = null,
  }) {
    return _then(InAppPopup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actions: null == actions
          ? _self._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<InAppMessageAction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class InAppBanner extends InAppMessage {
  const InAppBanner(
      {required this.id,
      required this.title,
      required this.iconUrl,
      required this.action,
      final String? $type})
      : $type = $type ?? 'banner',
        super._();
  factory InAppBanner.fromJson(Map<String, dynamic> json) => _$InAppBannerFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final String? iconUrl;
  final InAppMessageAction? action;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppBannerCopyWith<InAppBanner> get copyWith =>
      _$InAppBannerCopyWithImpl<InAppBanner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InAppBannerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppBanner &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.action, action) || other.action == action));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, iconUrl, action);

  @override
  String toString() {
    return 'InAppMessage.banner(id: $id, title: $title, iconUrl: $iconUrl, action: $action)';
  }
}

/// @nodoc
abstract mixin class $InAppBannerCopyWith<$Res> implements $InAppMessageCopyWith<$Res> {
  factory $InAppBannerCopyWith(InAppBanner value, $Res Function(InAppBanner) _then) =
      _$InAppBannerCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, String? iconUrl, InAppMessageAction? action});

  $InAppMessageActionCopyWith<$Res>? get action;
}

/// @nodoc
class _$InAppBannerCopyWithImpl<$Res> implements $InAppBannerCopyWith<$Res> {
  _$InAppBannerCopyWithImpl(this._self, this._then);

  final InAppBanner _self;
  final $Res Function(InAppBanner) _then;

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? iconUrl = freezed,
    Object? action = freezed,
  }) {
    return _then(InAppBanner(
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
      action: freezed == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as InAppMessageAction?,
    ));
  }

  /// Create a copy of InAppMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InAppMessageActionCopyWith<$Res>? get action {
    if (_self.action == null) {
      return null;
    }

    return $InAppMessageActionCopyWith<$Res>(_self.action!, (value) {
      return _then(_self.copyWith(action: value));
    });
  }
}

InAppMessageTrigger _$InAppMessageTriggerFromJson(Map<String, dynamic> json) {
  return AppLaunch.fromJson(json);
}

/// @nodoc
mixin _$InAppMessageTrigger {
  Duration get repeatInterval;

  /// Create a copy of InAppMessageTrigger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppMessageTriggerCopyWith<InAppMessageTrigger> get copyWith =>
      _$InAppMessageTriggerCopyWithImpl<InAppMessageTrigger>(
          this as InAppMessageTrigger, _$identity);

  /// Serializes this InAppMessageTrigger to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppMessageTrigger &&
            (identical(other.repeatInterval, repeatInterval) ||
                other.repeatInterval == repeatInterval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, repeatInterval);

  @override
  String toString() {
    return 'InAppMessageTrigger(repeatInterval: $repeatInterval)';
  }
}

/// @nodoc
abstract mixin class $InAppMessageTriggerCopyWith<$Res> {
  factory $InAppMessageTriggerCopyWith(
          InAppMessageTrigger value, $Res Function(InAppMessageTrigger) _then) =
      _$InAppMessageTriggerCopyWithImpl;
  @useResult
  $Res call({Duration repeatInterval});
}

/// @nodoc
class _$InAppMessageTriggerCopyWithImpl<$Res> implements $InAppMessageTriggerCopyWith<$Res> {
  _$InAppMessageTriggerCopyWithImpl(this._self, this._then);

  final InAppMessageTrigger _self;
  final $Res Function(InAppMessageTrigger) _then;

  /// Create a copy of InAppMessageTrigger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repeatInterval = null,
  }) {
    return _then(_self.copyWith(
      repeatInterval: null == repeatInterval
          ? _self.repeatInterval
          : repeatInterval // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// Adds pattern-matching-related methods to [InAppMessageTrigger].
extension InAppMessageTriggerPatterns on InAppMessageTrigger {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppLaunch value)? appLaunch,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch() when appLaunch != null:
        return appLaunch(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(AppLaunch value) appLaunch,
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch():
        return appLaunch(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppLaunch value)? appLaunch,
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch() when appLaunch != null:
        return appLaunch(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Duration repeatInterval)? appLaunch,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch() when appLaunch != null:
        return appLaunch(_that.repeatInterval);
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
  TResult when<TResult extends Object?>({
    required TResult Function(Duration repeatInterval) appLaunch,
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch():
        return appLaunch(_that.repeatInterval);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Duration repeatInterval)? appLaunch,
  }) {
    final _that = this;
    switch (_that) {
      case AppLaunch() when appLaunch != null:
        return appLaunch(_that.repeatInterval);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class AppLaunch extends InAppMessageTrigger {
  const AppLaunch({required this.repeatInterval}) : super._();
  factory AppLaunch.fromJson(Map<String, dynamic> json) => _$AppLaunchFromJson(json);

  @override
  final Duration repeatInterval;

  /// Create a copy of InAppMessageTrigger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppLaunchCopyWith<AppLaunch> get copyWith =>
      _$AppLaunchCopyWithImpl<AppLaunch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppLaunchToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppLaunch &&
            (identical(other.repeatInterval, repeatInterval) ||
                other.repeatInterval == repeatInterval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, repeatInterval);

  @override
  String toString() {
    return 'InAppMessageTrigger.appLaunch(repeatInterval: $repeatInterval)';
  }
}

/// @nodoc
abstract mixin class $AppLaunchCopyWith<$Res> implements $InAppMessageTriggerCopyWith<$Res> {
  factory $AppLaunchCopyWith(AppLaunch value, $Res Function(AppLaunch) _then) =
      _$AppLaunchCopyWithImpl;
  @override
  @useResult
  $Res call({Duration repeatInterval});
}

/// @nodoc
class _$AppLaunchCopyWithImpl<$Res> implements $AppLaunchCopyWith<$Res> {
  _$AppLaunchCopyWithImpl(this._self, this._then);

  final AppLaunch _self;
  final $Res Function(AppLaunch) _then;

  /// Create a copy of InAppMessageTrigger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? repeatInterval = null,
  }) {
    return _then(AppLaunch(
      repeatInterval: null == repeatInterval
          ? _self.repeatInterval
          : repeatInterval // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

InAppMessageAction _$InAppMessageActionFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'primary':
      return InAppActionPrimary.fromJson(json);
    case 'secondary':
      return InAppActionSecondary.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'InAppMessageAction', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$InAppMessageAction {
  String get label;
  String get url;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppMessageActionCopyWith<InAppMessageAction> get copyWith =>
      _$InAppMessageActionCopyWithImpl<InAppMessageAction>(this as InAppMessageAction, _$identity);

  /// Serializes this InAppMessageAction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppMessageAction &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, url);

  @override
  String toString() {
    return 'InAppMessageAction(label: $label, url: $url)';
  }
}

/// @nodoc
abstract mixin class $InAppMessageActionCopyWith<$Res> {
  factory $InAppMessageActionCopyWith(
          InAppMessageAction value, $Res Function(InAppMessageAction) _then) =
      _$InAppMessageActionCopyWithImpl;
  @useResult
  $Res call({String label, String url});
}

/// @nodoc
class _$InAppMessageActionCopyWithImpl<$Res> implements $InAppMessageActionCopyWith<$Res> {
  _$InAppMessageActionCopyWithImpl(this._self, this._then);

  final InAppMessageAction _self;
  final $Res Function(InAppMessageAction) _then;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? url = null,
  }) {
    return _then(_self.copyWith(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [InAppMessageAction].
extension InAppMessageActionPatterns on InAppMessageAction {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InAppActionPrimary value)? primary,
    TResult Function(InAppActionSecondary value)? secondary,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary() when primary != null:
        return primary(_that);
      case InAppActionSecondary() when secondary != null:
        return secondary(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(InAppActionPrimary value) primary,
    required TResult Function(InAppActionSecondary value) secondary,
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary():
        return primary(_that);
      case InAppActionSecondary():
        return secondary(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InAppActionPrimary value)? primary,
    TResult? Function(InAppActionSecondary value)? secondary,
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary() when primary != null:
        return primary(_that);
      case InAppActionSecondary() when secondary != null:
        return secondary(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String label, String url)? primary,
    TResult Function(String label, String url)? secondary,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary() when primary != null:
        return primary(_that.label, _that.url);
      case InAppActionSecondary() when secondary != null:
        return secondary(_that.label, _that.url);
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
  TResult when<TResult extends Object?>({
    required TResult Function(String label, String url) primary,
    required TResult Function(String label, String url) secondary,
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary():
        return primary(_that.label, _that.url);
      case InAppActionSecondary():
        return secondary(_that.label, _that.url);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String label, String url)? primary,
    TResult? Function(String label, String url)? secondary,
  }) {
    final _that = this;
    switch (_that) {
      case InAppActionPrimary() when primary != null:
        return primary(_that.label, _that.url);
      case InAppActionSecondary() when secondary != null:
        return secondary(_that.label, _that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class InAppActionPrimary extends InAppMessageAction {
  const InAppActionPrimary({required this.label, required this.url, final String? $type})
      : $type = $type ?? 'primary',
        super._();
  factory InAppActionPrimary.fromJson(Map<String, dynamic> json) =>
      _$InAppActionPrimaryFromJson(json);

  @override
  final String label;
  @override
  final String url;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppActionPrimaryCopyWith<InAppActionPrimary> get copyWith =>
      _$InAppActionPrimaryCopyWithImpl<InAppActionPrimary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InAppActionPrimaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppActionPrimary &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, url);

  @override
  String toString() {
    return 'InAppMessageAction.primary(label: $label, url: $url)';
  }
}

/// @nodoc
abstract mixin class $InAppActionPrimaryCopyWith<$Res>
    implements $InAppMessageActionCopyWith<$Res> {
  factory $InAppActionPrimaryCopyWith(
          InAppActionPrimary value, $Res Function(InAppActionPrimary) _then) =
      _$InAppActionPrimaryCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String url});
}

/// @nodoc
class _$InAppActionPrimaryCopyWithImpl<$Res> implements $InAppActionPrimaryCopyWith<$Res> {
  _$InAppActionPrimaryCopyWithImpl(this._self, this._then);

  final InAppActionPrimary _self;
  final $Res Function(InAppActionPrimary) _then;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? url = null,
  }) {
    return _then(InAppActionPrimary(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class InAppActionSecondary extends InAppMessageAction {
  const InAppActionSecondary({required this.label, required this.url, final String? $type})
      : $type = $type ?? 'secondary',
        super._();
  factory InAppActionSecondary.fromJson(Map<String, dynamic> json) =>
      _$InAppActionSecondaryFromJson(json);

  @override
  final String label;
  @override
  final String url;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InAppActionSecondaryCopyWith<InAppActionSecondary> get copyWith =>
      _$InAppActionSecondaryCopyWithImpl<InAppActionSecondary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InAppActionSecondaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InAppActionSecondary &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, url);

  @override
  String toString() {
    return 'InAppMessageAction.secondary(label: $label, url: $url)';
  }
}

/// @nodoc
abstract mixin class $InAppActionSecondaryCopyWith<$Res>
    implements $InAppMessageActionCopyWith<$Res> {
  factory $InAppActionSecondaryCopyWith(
          InAppActionSecondary value, $Res Function(InAppActionSecondary) _then) =
      _$InAppActionSecondaryCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String url});
}

/// @nodoc
class _$InAppActionSecondaryCopyWithImpl<$Res> implements $InAppActionSecondaryCopyWith<$Res> {
  _$InAppActionSecondaryCopyWithImpl(this._self, this._then);

  final InAppActionSecondary _self;
  final $Res Function(InAppActionSecondary) _then;

  /// Create a copy of InAppMessageAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? url = null,
  }) {
    return _then(InAppActionSecondary(
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
