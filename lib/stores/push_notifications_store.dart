import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
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
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _ipInfoStore;
  final SubscriptionStore _subscriptionStore;
  final Talker _logger;
  final NotificationsRepository _notificationsRepository;
  final AnalyticsStore _analyticsStore;
  final LocalDBService _localDb;
  final RemoteConfigStore _remoteConfigStore;

  bool _isDisposed = false;
  bool _isInitialized = false;

  @visibleForTesting
  bool testIsMobile = false; // default false, will override in tests

  bool get supportsPushNotifications => testIsMobile || isMobile();

  Future<void> _init() async {
    if (_isDisposed || _isInitialized) {
      return;
    }

    try {
      await _notificationsRepository.init();
      _isInitialized = true;

      // Listen to permission changes and track analytics
      final permissionSubscription = _pushNotificationsPermissionStream.listen((granted) {
        if (_isDisposed) {
          return;
        }

        try {
          _analyticsStore
            ..setUserProperty(
              AnalyticsUserProperty.fromEnum(
                name: AnalyticsUserPropName.pnPermissionStatus,
                value: granted.toString(),
              ),
            )
            ..logPushNotificationsPermissionsChanged(permissionsGranted: granted);
        } catch (e, stack) {
          _logger.handle(e, stack, 'Error tracking push notifications permission change');
        }
      });
      _subscriptions.add(permissionSubscription);

      // Setup reactions
      _disposers.addAll([
        // React to authentication changes
        reaction(
          (_) => _authSessionStore.userFuture.value.toUserData(),
          (data) async {
            if (_isDisposed) {
              return;
            }

            if (_authSessionStore.userFuture.value == null) {
              try {
                await _notificationsRepository.logout();
              } catch (e, stack) {
                _logger.handle(e, stack, 'Error logging out from push notifications');
              }
              return;
            }

            try {
              await _notificationsRepository.login(
                userId: data.id,
                userEmail: data.email,
              );
            } catch (e, stack) {
              _logger.handle(e, stack, 'Error logging in to push notifications');
            }
          },
          fireImmediately: true,
        ),

        // React to location changes
        reaction(
          (_) => _ipInfoStore.infoFuture.value.toLocationData(),
          (data) async {
            if (_isDisposed) {
              return;
            }

            try {
              final tags = <String, String>{
                'country': data.country,
                'city': data.city,
              };
              await _notificationsRepository.setTags(tags);
            } catch (e, stack) {
              _logger.handle(e, stack, 'Error setting location tags');
            }
          },
          fireImmediately: true,
        ),

        // React to subscription changes
        reaction(
          (_) => _subscriptionStore.subscriptionFuture.value.toSubscriptionData(),
          (data) async {
            if (_isDisposed) {
              return;
            }
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
              _logger.handle(e, stack, 'Error setting subscription tags');
            }
          },
          fireImmediately: true,
        ),
      ]);
    } catch (e, stack) {
      _logger.handle(e, stack, 'Error initializing push notifications store');
      _isInitialized = false;
    }
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
    if (_isDisposed) {
      _logger.warning('Attempted to update permissions on disposed store');
      return;
    }

    if (!supportsPushNotifications) {
      return;
    }

    try {
      await _notificationsRepository.openAppNotificationsSettings();
    } catch (e, stack) {
      _logger.handle(e, stack, 'Error opening app notification settings');
      rethrow;
    }
  }

  @action
  Future<void> setPushNotificationsShown({required bool userAllowed}) async {
    if (_isDisposed) {
      _logger.warning('Attempted to set notifications shown on disposed store');
      return;
    }

    if (!supportsPushNotifications) {
      return;
    }

    if (userAllowed) {
      try {
        final granted = await _notificationsRepository.requestPermission();
        _logger.info('Push notifications permission request result: $granted');
      } catch (e, stack) {
        _logger.handle(e, stack, 'Error requesting push notifications permission');
      }
    }

    try {
      await _localDb.setPushNotificationsPromptLastShownAt(DateTime.now());
    } catch (e, stack) {
      _logger.handle(e, stack, 'Error saving push notifications prompt timestamp');
    }
  }

  @action
  Future<bool> shouldShowPushNotificationsPermissionPrompt() async {
    if (_isDisposed) {
      _logger.warning('Attempted to check prompt status on disposed store');
      return false;
    }

    // Skip the push notifications prompt if the platform is not mobile
    if (!supportsPushNotifications) {
      return false;
    }

    try {
      // Check cooldown period
      final cooldownHours = _remoteConfigStore.pushNotifPermissionPromptCooldown;
      final lastShownAt = await _localDb.getPushNotificationsPromptLastShownAt();

      if (lastShownAt != null) {
        final nextAllowedTime = lastShownAt.add(Duration(hours: cooldownHours));
        if (nextAllowedTime.isAfter(DateTime.now())) {
          return false;
        }
      }

      // Check if permission is already granted
      if (_notificationsRepository.getPermissionStatus()) {
        return false;
      }

      // Check if we can request permission
      return await _notificationsRepository.canRequestPermission();
    } catch (e, stack) {
      _logger.handle(e, stack, 'Error checking if should show PN prompt');
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    // Dispose all MobX reactions
    for (final disposer in _disposers) {
      try {
        disposer();
      } catch (e, stack) {
        _logger.handle(e, stack, 'Error disposing reaction');
      }
    }
    _disposers.clear();

    // Cancel all stream subscriptions
    for (final subscription in _subscriptions) {
      try {
        await subscription.cancel();
      } catch (e, stack) {
        _logger.handle(e, stack, 'Error canceling subscription');
      }
    }
    _subscriptions.clear();

    // Dispose the notifications repository if it has a dispose method
    try {
      // Check if the repository has a dispose method
      _notificationsRepository.dispose();
    } catch (e, stack) {
      _logger.handle(e, stack, 'Error disposing notifications repository');
    }

    _logger.debug('PushNotificationsStore disposed');
  }
}
