import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'push_notifications_store.g.dart';

// ignore: library_private_types_in_public_api
class PushNotificationsStore = _PushNotificationsStore with _$PushNotificationsStore;

abstract class _PushNotificationsStore with Store, Disposeable {
  _PushNotificationsStore(
    this._authSessionStore,
    this._ipInfoStore,
    this._subscriptionStore,
    this._logger,
    this._notificationsRepository,
    this._analyticsStore,
    this._localDb,
    this._remoteConfigStore,
  ) {
    _init();
  }

  final List<ReactionDisposer> _disposers = [];
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _ipInfoStore;
  final SubscriptionStore _subscriptionStore;
  final Talker _logger;
  final NotificationsRepository _notificationsRepository;
  final AnalyticsStore _analyticsStore;
  final LocalDBService _localDb;
  final RemoteConfigStore _remoteConfigStore;

  @visibleForTesting
  bool testIsMobile = false; // default false, will override in tests

  bool get supportsPushNotifications => testIsMobile || isMobile();

  Future<void> _init() async {
    await _notificationsRepository.init();
    _pushNotificationsPermissionStream.listen((granted) {
      _analyticsStore
        ..setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.pnPermissionStatus,
            value: granted.toString(),
          ),
        )
        ..logPushNotificationsPermissionsChanged(permissionsGranted: granted);
    });
    _disposers.addAll([
      reaction(
        (_) => _authSessionStore.userFuture.value.toUserData(),
        (data) async {
          if (_authSessionStore.userFuture.value == null) {
            await _notificationsRepository.logout();
            return;
          }
          try {
            await _notificationsRepository.login(userId: data.id, userEmail: data.email);
          } catch (e, stack) {
            _logger.handle(e, stack);
          }
        },
        fireImmediately: true,
      ),
      reaction(
        (_) => _ipInfoStore.infoFuture.value.toLocationData(),
        (data) async {
          try {
            final tags = <String, String>{
              'country': data.country,
              'city': data.city,
            };
            await _notificationsRepository.setTags(tags);
          } catch (e, stack) {
            _logger.handle(e, stack);
          }
        },
        fireImmediately: true,
      ),
      reaction(
        (_) => _subscriptionStore.subscriptionFuture.value.toSubscriptionData(),
        (data) async {
          if (!_authSessionStore.isAuthenticated) {
            return;
          }
          try {
            final tags = <String, String>{
              'subscription_duration': data.duration,
              'subscription_exp_date': data.expirationDate,
              'subscription_gateway': data.gateway,
              'subscription_plan': data.plan,
              'subscription_recurring': data.recurring,
            };
            await _notificationsRepository.setTags(tags);
          } catch (e, stack) {
            _logger.handle(e, stack);
          }
        },
        fireImmediately: true,
      ),
    ]);
  }

  @readonly
  late ObservableStream<PushNotificationsUser> _pushNotificationsUser =
      ObservableStream(_notificationsRepository.getUser());

  @readonly
  late ObservableStream<bool> _pushNotificationsPermissionStream = ObservableStream(
    _notificationsRepository.getPermissionStatusStream(),
  );

  @computed
  String? get user => _pushNotificationsUser.value?.toString();

  @computed
  bool get pushNotificationsPermissionGranted => _pushNotificationsPermissionStream.value ?? false;

  @action
  Future<void> updatePushNotificationsPermissions() async {
    if (!supportsPushNotifications) {
      return;
    }
    await _notificationsRepository.openAppNotificationsSettings();
  }

  @action
  Future<void> setPushNotificationsShown({required bool userAllowed}) async {
    if (!supportsPushNotifications) {
      return;
    }
    if (userAllowed) {
      try {
        await _notificationsRepository.requestPermission();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    await _localDb.setPushNotificationsPromptLastShownAt(DateTime.now());
  }

  @action
  Future<bool> shouldShowPushNotificationsPermissionPrompt() async {
    // Skip the push notifications prompt if the platform is not mobile
    // or if the prompt has already been shown.
    if (!supportsPushNotifications) {
      return false;
    }
    final cooldownHours = _remoteConfigStore.pushNotifPermissionPromptCooldown;
    final lastShownAt = await _localDb.getPushNotificationsPromptLastShownAt();
    if (lastShownAt?.add(Duration(hours: cooldownHours)).isAfter(DateTime.now()) ?? false) {
      return false;
    }
    return !_notificationsRepository.getPermissionStatus() &&
        await _notificationsRepository.canRequestPermission();
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}
