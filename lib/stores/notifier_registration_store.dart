import 'dart:async';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart' hide UserData;
import 'package:mysterium_vpn/repositories/notifications/notifications_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'notifier_registration_store.g.dart';

// ignore: library_private_types_in_public_api
class NotifierRegistrationStore = _NotifierRegistrationStore with _$NotifierRegistrationStore;

/// Keeps the device registered with Notifier for the currently authenticated
/// user, in the background, without blocking startup or authentication.
///
/// The registration identity is (`externalUserId`, `token`, `platform`,
/// [kNotifierContractVersion]). It is persisted after a successful call, so an
/// unchanged identity makes no request. A failed call persists `pending: true`
/// and is re-attempted on the next trigger — login, a new token, app resume,
/// restored connectivity, or permission being granted — never on a timer.
abstract class _NotifierRegistrationStore with Store, Disposeable, WidgetsBindingObserver {
  _NotifierRegistrationStore(
    this._authSessionStore,
    this._ipInfoStore,
    this._subscriptionStore,
    this._repository,
    this._service,
    this._prefs,
    this._analyticsStore,
    this._logger, {
    Connectivity? connectivity,
    NotifierPlatform? Function()? platform,
  }) : _connectivity = connectivity ?? Connectivity(),
       _platform = platform ?? NotifierPlatform.current {
    _init();
  }

  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _ipInfoStore;
  final SubscriptionStore _subscriptionStore;
  final NotificationsRepository _repository;
  final NotifierService _service;
  final SharedPreferenceService _prefs;
  final AnalyticsStore _analyticsStore;
  final Talker _logger;
  final Connectivity _connectivity;

  /// Injected so the state machine is exercisable on a host VM, where
  /// [NotifierPlatform.current] is null.
  final NotifierPlatform? Function() _platform;

  final List<ReactionDisposer> _disposers = [];
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  bool _inFlight = false;
  bool _attributesInFlight = false;

  /// Last attribute map successfully merged, so repeated reaction firings with
  /// an unchanged payload make no request.
  Map<String, Object?>? _sentAttributes;

  void _init() {
    // A null platform means there is no push transport here — nothing to wire.
    if (_platform() == null) {
      return;
    }
    try {
      WidgetsBinding.instance.addObserver(this);
      _setupReactions();
      _setupStreamListeners();
    } catch (e, stack) {
      _reportUnexpected(e, stack, 'store init');
    }
  }

  void _setupReactions() {
    _disposers.addAll([
      _createAuthReaction(),
      reaction(
        (_) => _ipInfoStore.infoFuture.value.toLocationData(),
        (_) async => _syncAttributes(),
      ),
      reaction(
        (_) => _subscriptionStore.subscriptionFuture.value.toSubscriptionData(),
        (_) async => _syncAttributes(),
      ),
    ]);
  }

  /// `fireImmediately` so an already-authenticated session — a cold start, or
  /// the first launch after updating into this version — registers without the
  /// user having to log in again.
  ReactionDisposer _createAuthReaction() {
    var wasAuthenticated = false;
    return reaction((_) => _authSessionStore.userFuture.value.toUserData(), (_) async {
      if (_authSessionStore.userFuture.value == null) {
        // Skip on the initial fire: only a real authenticated → unauthenticated
        // transition should tear the registration down.
        if (wasAuthenticated) {
          await handleLogout();
        }
        wasAuthenticated = false;
        return;
      }
      wasAuthenticated = true;
      await syncRegistration();
    }, fireImmediately: true);
  }

  void _setupStreamListeners() {
    _subscriptions.addAll([
      _repository.tokenStream.listen((_) async {
        _analyticsStore.logEvent(AnalyticsEvent.pushTokenRefreshed);
        await syncRegistration();
      }, onError: (Object e, StackTrace s) => _reportUnexpected(e, s, 'token stream')),
      // The repository emits only on change, so a `true` here *is* the
      // granted transition — re-enabling notifications is a registration trigger.
      _repository.getPermissionStatusStream().listen((granted) async {
        if (granted) {
          await syncRegistration();
        }
      }, onError: (Object e, StackTrace s) => _reportUnexpected(e, s, 'permission stream')),
      _connectivity.onConnectivityChanged.listen((results) async {
        // Only worth retrying if something is actually outstanding.
        if (results.hasConnectivity && (_prefs.getNotifierRegistration()?.pending ?? false)) {
          await syncRegistration();
        }
      }, onError: (Object e, StackTrace s) => _reportUnexpected(e, s, 'connectivity stream')),
    ]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    // Permission can have been flipped in system settings while backgrounded;
    // refreshing emits on the permission stream, which is itself a trigger.
    unawaited(_repository.refreshPermissionStatus().then((_) => syncRegistration()));
  }

  /// Registers or updates the device when — and only when — every required
  /// value is available and the identity actually changed (or is pending).
  @action
  Future<void> syncRegistration() async {
    if (_inFlight || !Env.notifierConfigured) {
      return;
    }

    final desired = _desiredRegistration();
    if (desired == null) {
      return;
    }

    final stored = _prefs.getNotifierRegistration();
    if (stored != null && !stored.pending && stored.matches(desired)) {
      return;
    }

    _inFlight = true;
    NotifierRegistration? registered;
    try {
      _analyticsStore.logEvent(AnalyticsEvent.pushDeviceRegistrationStarted);
      await _service.registerDevice(
        externalUserId: desired.externalUserId,
        token: desired.token,
        platform: desired.platform,
      );
      await _prefs.setNotifierRegistration(desired);
      _analyticsStore.logEvent(AnalyticsEvent.pushDeviceRegistrationSucceeded);
      registered = desired;
    } catch (e, stack) {
      await _markPending(desired);
      final failure = e is NotifierException ? e : null;
      final category = failure?.category ?? 'unknown';
      _analyticsStore.logPushDeviceRegistrationFailed(
        errorCategory: category,
        status: failure?.statusCode,
      );
      _logger.warning('Notifier device registration failed ($category)');
      // A NotifierException is an expected, already-evented outcome (a 4xx, a
      // timeout) and is retried — reporting each one would bury the dashboard.
      // Anything else is a bug on our side.
      if (failure == null) {
        _reportUnexpected(e, stack, 'device registration');
      }
      return;
    } finally {
      _inFlight = false;
    }

    await _syncAttributes(registered);
  }

  /// Clears the local state and deletes the FCM token, so the departing user's
  /// device row in Notifier is left holding a token that can no longer be
  /// delivered to. The public API has no device-delete endpoint.
  @action
  Future<void> handleLogout() async {
    _sentAttributes = null;
    // Independent, and clearToken is a network round trip while the prefs write
    // is local — so run them concurrently, each guarded so one failing cannot
    // skip the other.
    await Future.wait([
      _guard('Clearing Notifier registration state', _prefs.clearNotifierRegistration),
      _guard('Clearing the push token', _repository.clearToken),
    ]);
  }

  /// Logs and reports a failure that indicates a bug rather than a transport
  /// outcome. Notifier HTTP failures are evented and retried instead — see
  /// [syncRegistration].
  void _reportUnexpected(Object error, StackTrace? stack, String what) {
    _logger.warning('Notifier $what failed: $error');
    try {
      // Synchronous throws from the reporter would escape the caller's catch,
      // so `unawaited` alone is not enough protection here.
      unawaited(
        _analyticsStore
            .logNonFatal(err: error, stack: stack, reason: 'notifier: $what')
            .catchError((Object _) {}),
      );
    } catch (_) {}
  }

  Future<void> _guard(String what, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, stack) {
      _reportUnexpected(e, stack, what);
    }
  }

  /// Merges user attributes so Notifier segments can target them. Only after a
  /// settled registration — the endpoint 404s for a user Notifier has not seen.
  Future<void> _syncAttributes([NotifierRegistration? known]) async {
    if (_attributesInFlight || !Env.notifierConfigured) {
      return;
    }
    final stored = known ?? _prefs.getNotifierRegistration();
    if (stored == null || stored.pending) {
      return;
    }

    final location = _ipInfoStore.infoFuture.value.toLocationData();
    final subscription = _subscriptionStore.subscriptionFuture.value.toSubscriptionData();
    final attributes = <String, Object?>{
      'country': location.country,
      'city': location.city,
      'subscription_duration': subscription.duration,
      'subscription_exp_date': subscription.expirationDate,
      'subscription_gateway': subscription.gateway,
      'subscription_plan': subscription.plan,
      'subscription_recurring': subscription.recurring,
      'subscription_active': subscription.active,
      'subscription_start_date': subscription.startDate,
      'subscription_expired': subscription.expired,
    };

    // The location and subscription reactions both land here, often in the same
    // MobX batch and with an identical payload. Skip the request when nothing
    // changed rather than sending the same full map two or three times a launch.
    if (const DeepCollectionEquality().equals(_sentAttributes, attributes)) {
      return;
    }

    _attributesInFlight = true;
    try {
      await _service.mergeAttributes(externalUserId: stored.externalUserId, attributes: attributes);
      _sentAttributes = attributes;
    } catch (e, stack) {
      // Attributes are best-effort: never escalate into the registration flow.
      _logger.warning('Merging Notifier attributes failed: $e');
      if (e is! NotifierException) {
        _reportUnexpected(e, stack, 'merging attributes');
      }
    } finally {
      _attributesInFlight = false;
    }
  }

  /// Null unless every required value is present — authenticated user id, FCM
  /// token and a platform Notifier supports.
  NotifierRegistration? _desiredRegistration() {
    final platform = _platform();
    if (platform == null) {
      return null;
    }
    final externalUserId = _authSessionStore.userFuture.value?.userId;
    final token = _repository.currentToken;
    if (externalUserId.isNullOrEmpty || token.isNullOrEmpty) {
      return null;
    }
    return NotifierRegistration(
      externalUserId: externalUserId!,
      token: token!,
      platform: platform,
      contractVersion: kNotifierContractVersion,
    );
  }

  Future<void> _markPending(NotifierRegistration desired) async {
    try {
      await _prefs.setNotifierRegistration(desired.copyWith(pending: true));
    } catch (e, stack) {
      // Losing this flag loses the retry, so it is not merely cosmetic.
      _reportUnexpected(e, stack, 'persisting pending registration');
    }
  }

  @override
  Future<void> dispose() async {
    try {
      WidgetsBinding.instance.removeObserver(this);
    } catch (e) {
      _logger.warning('Removing Notifier lifecycle observer failed: $e');
    }
    for (final disposer in _disposers) {
      try {
        disposer();
      } catch (e) {
        _logger.warning('Disposing Notifier reaction failed: $e');
      }
    }
    _disposers.clear();
    for (final subscription in _subscriptions) {
      try {
        await subscription.cancel();
      } catch (e) {
        _logger.warning('Cancelling Notifier subscription failed: $e');
      }
    }
    _subscriptions.clear();
    _logger.debug('NotifierRegistrationStore disposed');
  }
}
