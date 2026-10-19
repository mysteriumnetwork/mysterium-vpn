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
import 'package:mysterium_vpn/repositories/repositories.dart';
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
/// unchanged identity makes no request beyond the one re-register per launch.
/// A failed call is persisted as pending and re-attempted on the next trigger —
/// login, a new token, app resume, restored connectivity, or permission being
/// granted — never on a timer.
///
/// Notification permission is the gate: Notifier should only hold devices that
/// can actually display what it sends. Revoking permission deletes the device,
/// granting it again re-registers it.
abstract class _NotifierRegistrationStore with Store, Disposeable, WidgetsBindingObserver {
  _NotifierRegistrationStore(
    this._authSessionStore,
    this._ipInfoStore,
    this._subscriptionStore,
    this._repository,
    this._service,
    this._registration,
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
  final NotifierRegistrationRepository _registration;
  final AnalyticsStore _analyticsStore;
  final Talker _logger;
  final Connectivity _connectivity;

  /// Injected so the state machine is exercisable on a host VM, where
  /// [NotifierPlatform.current] is null.
  final NotifierPlatform? Function() _platform;

  final List<ReactionDisposer> _disposers = [];
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  /// Serializes Notifier calls. A trigger arriving mid-request queues behind
  /// the current one instead of being dropped, so it re-reads the desired
  /// identity afterwards — a token refresh during a register, or a logout
  /// during a first registration, both land correctly.
  Future<void> _queue = Future<void>.value();

  /// Marks the zone a queued action runs in. Zone values propagate to async
  /// callees, so this distinguishes a genuinely re-entrant call from an outside
  /// trigger that merely overlaps one — a plain flag cannot.
  static const Object _queueZoneKey = #notifierQueue;

  bool _disposed = false;

  bool _attributesInFlight = false;

  /// Set when an attribute change arrives mid-merge, so the newer map is sent
  /// once the current request finishes rather than being lost.
  bool _attributesStale = false;

  /// Whether this launch has already re-registered. The backend wants one
  /// register per launch even when nothing changed, but only one.
  bool _registeredThisLaunch = false;

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
      // A revoke made while the app was not running emits nothing, so the
      // platform has to be read directly.
      unawaited(_guard('reconciling permission', _reconcilePermission));
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
      // The repository emits only on change and only from a fresh platform
      // read, so a value here *is* a trustworthy transition: granting is a
      // registration trigger, revoking a delete trigger.
      _repository.getPermissionStatusStream().listen((granted) async {
        if (granted) {
          await syncRegistration();
        } else {
          await _deleteStoredDevice();
        }
      }, onError: (Object e, StackTrace s) => _reportUnexpected(e, s, 'permission stream')),
      _connectivity.onConnectivityChanged.listen((results) async {
        // Only worth retrying if something is actually outstanding.
        if (results.hasConnectivity && (_registration.read()?.isPending ?? false)) {
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
    // Permission can have been flipped in system settings while backgrounded.
    // The sync is unconditional because nothing else re-runs on resume: an
    // unchanged `true` emits nothing, so a registration left pending by an
    // earlier failure would otherwise never be retried.
    unawaited(
      _guard('reconciling permission', () async {
        await _reconcilePermission();
        await syncRegistration();
      }),
    );
  }

  /// Unregisters the device when a fresh platform read says permission is off.
  ///
  /// Reads through to the platform rather than trusting
  /// [NotificationsRepository.getPermissionStatus], whose cache starts `false`
  /// on a cold start — deleting on its say-so would unregister on every launch.
  ///
  /// Only the revoked direction needs handling at startup: granting either
  /// already agreed with the cache, or changed it and emitted on the
  /// permission stream, and both are triggers. Resume is different — see
  /// [didChangeAppLifecycleState].
  Future<void> _reconcilePermission() async {
    if (!await _repository.refreshPermissionStatus()) {
      await _deleteStoredDevice();
    }
  }

  /// Unregisters whatever is on record, if anything. Queued, so a logout or a
  /// revoke that lands mid-registration deletes the record that register just
  /// wrote rather than finding nothing.
  Future<void> _deleteStoredDevice() => _serialized(() async {
    final stored = _registration.read();
    if (stored != null) {
      await _delete(stored);
    }
  });

  /// Persists [state] against [record] so a retry trigger can pick it up.
  Future<void> _mark(NotifierRegistration record, NotifierSyncState state) =>
      _guard('persisting ${state.name}', () => _registration.save(record.copyWith(state: state)));

  /// Runs [action] after any Notifier call already in flight.
  Future<void> _serialized(Future<void> Function() action) {
    if (_disposed) {
      return Future<void>.value();
    }
    // A call from inside the queue is already in the critical section. Queueing
    // it would wait on an entry that cannot drain until this one returns, which
    // deadlocks the chain permanently — every later trigger would hang with no
    // diagnostic. Running inline keeps the ordering guarantee instead.
    if (Zone.current[_queueZoneKey] == true) {
      return action();
    }
    final next = _queue.then((_) => runZoned(action, zoneValues: {_queueZoneKey: true}));
    // Swallowed on the chain only, so one failure cannot poison later work
    // while the caller still sees its own error.
    _queue = next.catchError((Object _) {});
    return next;
  }

  /// Brings Notifier in line with this device: registers when permission and
  /// every required value are there, deletes when they are not.
  @action
  Future<void> syncRegistration() => _serialized(_syncRegistration);

  Future<void> _syncRegistration() async {
    if (!Env.notifierConfigured) {
      return;
    }

    var stored = _registration.read();

    // Finish an owed delete first, then carry on and register again below.
    if (stored?.state == NotifierSyncState.pendingDelete) {
      if (!await _delete(stored!)) {
        // Still owed; don't register over it.
        return;
      }
      stored = null;
    }

    // Permission is the gate: a device that cannot display a notification has
    // no business being in Notifier's send list. A stale `false` here only
    // defers the register — whatever refreshes it emits, and that re-triggers
    // us. Revoking is never decided from this cache: see [_reconcilePermission].
    if (!_repository.getPermissionStatus()) {
      return;
    }

    final desired = _desiredRegistration();
    if (desired == null) {
      return;
    }

    // Notifier keys rows by (token, externalUserId), so registering B over A
    // leaves A's row pointing at this still-valid token and A's campaigns keep
    // arriving. Only a user change needs this: a refreshed token invalidates
    // the old row on its own.
    if (stored != null && stored.externalUserId != desired.externalUserId) {
      if (!await _delete(stored)) {
        // Retained as pendingDelete; a later trigger finishes it before B
        // registers.
        return;
      }
      stored = null;
    }

    if (stored != null && !stored.isPending && stored.matches(desired) && _registeredThisLaunch) {
      return;
    }

    NotifierRegistration? registered;
    try {
      _analyticsStore.logEvent(AnalyticsEvent.pushDeviceRegistrationStarted);
      await _service.registerDevice(
        externalUserId: desired.externalUserId,
        token: desired.token,
        platform: desired.platform,
      );
      await _registration.save(desired);
      _analyticsStore.logEvent(AnalyticsEvent.pushDeviceRegistrationSucceeded);
      _registeredThisLaunch = true;
      registered = desired;
    } catch (e, stack) {
      await _mark(desired, NotifierSyncState.pendingRegister);
      _reportCallFailure(e, stack, 'device registration', (category, status) {
        _analyticsStore.logPushDeviceRegistrationFailed(errorCategory: category, status: status);
      });
      return;
    }

    await _syncAttributes(registered);
  }

  /// Unregisters the device so the departing user stops receiving pushes, and
  /// clears whatever is still in the tray.
  ///
  /// The FCM token is deliberately kept — Notifier identifies the device by it,
  /// so dropping it locally would strand the very row this call removes.
  @action
  Future<void> handleLogout() async {
    _sentAttributes = null;
    _registeredThisLaunch = false;

    // Independent, and the delete is a network round trip while clearing the
    // tray is local — so run them concurrently, each contained so one failing
    // cannot skip the other.
    await Future.wait([
      _deleteStoredDevice(),
      _guard('clearing displayed notifications', _repository.cancelDisplayedNotifications),
    ]);
  }

  /// Removes the device from Notifier and drops the local record. Returns
  /// whether the record is gone, so a caller can tell a still-owed delete from
  /// a finished one.
  ///
  /// A failure leaves the record as [NotifierSyncState.pendingDelete], which
  /// the triggers in [syncRegistration] pick up.
  Future<bool> _delete(NotifierRegistration stored) async {
    if (!Env.notifierConfigured) {
      return false;
    }

    // Marked before the request: a process death mid-DELETE would otherwise
    // leave a settled record for a signed-out user, and the auth reaction skips
    // logout on a signed-out launch, so nothing would ever retry it.
    await _mark(stored, NotifierSyncState.pendingDelete);
    try {
      await _service.deleteDevice(token: stored.token, externalUserId: stored.externalUserId);
      await _guard('clearing Notifier registration state', _registration.clear);
      _sentAttributes = null;
      _registeredThisLaunch = false;
      _analyticsStore.logEvent(AnalyticsEvent.pushDeviceDeleted);
      return true;
    } catch (e, stack) {
      // Already marked above, so the record is left owing the delete.
      _reportCallFailure(e, stack, 'device delete', (category, status) {
        _analyticsStore.logPushDeviceDeleteFailed(errorCategory: category, status: status);
      });
      return false;
    }
  }

  /// Events a failed Notifier call and decides whether it is also a bug.
  ///
  /// A [NotifierException] is an expected transport outcome (a 4xx, a timeout)
  /// that gets retried, and is already evented — reporting each one would bury
  /// the dashboard. Anything else is a bug on our side.
  void _reportCallFailure(
    Object error,
    StackTrace stack,
    String what,
    void Function(String category, int? status) event,
  ) {
    final failure = error is NotifierException ? error : null;
    final category = failure?.category ?? 'unknown';
    event(category, failure?.statusCode);
    _logger.warning('Notifier $what failed ($category)');
    if (failure == null) {
      _reportUnexpected(error, stack, what);
    }
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
    if (!Env.notifierConfigured) {
      return;
    }
    if (_attributesInFlight) {
      // A reaction fired mid-request; the map it saw is newer than the one in
      // flight, so re-run once that finishes instead of dropping it.
      _attributesStale = true;
      return;
    }
    final stored = known ?? _registration.read();
    if (stored == null || stored.isPending) {
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

    if (_attributesStale) {
      _attributesStale = false;
      await _syncAttributes(known);
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

  @override
  Future<void> dispose() async {
    _disposed = true;
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
