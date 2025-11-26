import 'dart:async';
import 'dart:io';

import 'package:configcat_client/configcat_client.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/config_cat_user_custom.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'config_cat_user_store.g.dart';

// ignore: library_private_types_in_public_api
class ConfigCatUserStore = _ConfigCatUserStore with _$ConfigCatUserStore;

abstract class _ConfigCatUserStore with Store, Disposeable {
  _ConfigCatUserStore(
    this._authSessionStore,
    this._ipInfoStore,
    this._subscriptionStore,
    this._logger,
  ) {
    _init();
  }

  final List<ReactionDisposer> _disposers = [];
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _ipInfoStore;
  final SubscriptionStore _subscriptionStore;
  final Talker _logger;

  Future<void> _init() async {
    await _future; // Ensure initial fetch is complete before setting up reactions
    _disposers.addAll([
      reaction(
        (_) => _authSessionStore.userFuture.value.toUserData(),
        (data) async {
          try {
            final current = await _future;
            _future = ObservableFuture.value(
              current.copyWith(identifier: data.id, email: data.email),
            );
          } catch (e, stack) {
            _logger.handle(e, stack);
          }
        },
      ),
      reaction(
        (_) => _ipInfoStore.infoFuture.value.toLocationData(),
        (data) async {
          try {
            final current = await _future;
            _future = ObservableFuture.value(
              current.copyWith(
                country: data.country,
                custom: current.custom.copyWith(city: data.city),
              ),
            );
          } catch (e, stack) {
            _logger.handle(e, stack);
          }
        },
      ),
      reaction(
        (_) => _subscriptionStore.subscriptionFuture.value.toSubscriptionData(),
        (data) async {
          final current = await _future;
          _future = ObservableFuture.value(
            current.copyWith(
              custom: current.custom.copyWith(
                subscriptionPlan: data.plan,
                subscriptionSource: data.gateway,
              ),
            ),
          );
        },
      ),
    ]);
  }

  @readonly
  late ObservableFuture<ConfigCatUser> _future = ObservableFuture(_fetchUser());

  Future<_UserData> _fetchUserData() async {
    try {
      final user = await _authSessionStore.userFuture;
      return user.toUserData();
    } catch (e, stack) {
      _logger.handle(e, stack);
    }

    return null.toUserData();
  }

  Future<_LocationData> _fetchLocationData() async {
    try {
      final info = await _ipInfoStore.infoFuture;
      return info.toLocationData();
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
    return null.toLocationData();
  }

  Future<_SubscriptionData> _fetchSubscription() async {
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      return subscription.toSubscriptionData();
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
    return null.toSubscriptionData();
  }

  Future<ConfigCatUser> _fetchUser() async {
    final [
      userData as _UserData,
      locationData as _LocationData,
      subscriptionData as _SubscriptionData,
    ] = await Future.wait([
      _fetchUserData(),
      _fetchLocationData(),
      _fetchSubscription(),
    ]);

    return ConfigCatUser(
      identifier: userData.id,
      email: userData.email,
      country: locationData.country,
      custom: ConfigCatUserCustom(
        platform: Platform.operatingSystem,
        version: Env.packageInfo.version,
        city: locationData.city,
        subscriptionSource: subscriptionData.gateway,
        subscriptionPlan: subscriptionData.plan,
      ).toAttributes(),
    );
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}

extension ConfigCatUserExtensions on ConfigCatUser {
  T? getAttributeOrNull<T>(String key) {
    final value = getAttribute(key);
    if (value is T) {
      return value;
    } else {
      return null;
    }
  }

  String? get email => getAttributeOrNull('Email');

  String? get country => getAttributeOrNull('Country');

  ConfigCatUserCustom get custom => ConfigCatUserCustom.fromConfigCatUser(this);

  ConfigCatUser copyWith({
    String? identifier,
    String? email,
    String? country,
    ConfigCatUserCustom? custom,
  }) {
    final currentCustomJson = this.custom.toJson();
    final customJson = custom?.toJson();
    return ConfigCatUser(
      identifier: identifier ?? this.identifier,
      email: email ?? getAttributeOrNull<String>('Email'),
      country: country ?? getAttributeOrNull<String>('Country'),
      custom: {
        for (final entry in currentCustomJson.entries) entry.key: entry.value.toString(),
        if (customJson != null)
          for (final entry in customJson.entries) entry.key: entry.value.toString(),
      },
    );
  }

  bool equals(ConfigCatUser other) =>
      identifier == other.identifier &&
      email == other.email &&
      country == other.country &&
      custom == other.custom;

  String stringify() =>
      'ConfigCatUser(identifier: $identifier, email: $email, country: $country, custom: $custom)';
}

typedef _UserData = ({String id, String email});
typedef _LocationData = ({String country, String city});
typedef _SubscriptionData = ({String gateway, String plan});

extension _AuthUserDataExtensions on AuthUser? {
  ({String id, String email}) toUserData() => (
        id: this?.userId ?? 'null',
        email: this?.username ?? 'null',
      );
}

extension _IPInfoExtensions on IPInfo? {
  ({String country, String city}) toLocationData() => (
        country: this?.country ?? 'null',
        city: this?.city ?? 'null',
      );
}

extension _SubscriptionExtensions on Subscription? {
  ({String gateway, String plan}) toSubscriptionData() {
    final plan = this?.planId;
    final gateway = this?.gatewayName;
    if (plan != null && gateway != null) {
      return (gateway: gateway, plan: plan);
    }
    return (gateway: 'null', plan: 'null');
  }
}
