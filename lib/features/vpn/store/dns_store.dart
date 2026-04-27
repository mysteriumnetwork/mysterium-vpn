import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/auth_status.dart';
import 'package:mysterium_vpn/core/enums/blocker_type.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_features_store.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';

part 'dns_store.g.dart';

const _initialMalwareBlockerValue = false;
const _initialNotSafeContentBlockerValue = false;
const _defaultDNSAddress = '1.1.1.1';

// ignore: library_private_types_in_public_api
class DNSStore = _DNSStore with _$DNSStore;

abstract class _DNSStore with Store {
  _DNSStore(
    this._localDBService,
    this._remoteConfigStore,
    this._logger,
    this._authSessionStore,
    this._subscriptionFeaturesStore,
  ) {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
          malwareContentBlockerFuture = ObservableFuture(getMalwareContentBlocker());
          notSafeContentBlockerFuture = ObservableFuture(getNotSafeContentBlocker());
        }
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );
  }

  final LocalDBService _localDBService;
  final RemoteConfigStore _remoteConfigStore;
  final Talker _logger;
  final AuthSessionStore _authSessionStore;
  final SubscriptionFeaturesStore _subscriptionFeaturesStore;
  ReactionDisposer? _authReactionDisposer;

  @computed
  bool get malwareContentBlocker =>
      malwareContentBlockerFuture.value ?? _initialMalwareBlockerValue;

  @computed
  bool get notSafeContentBlocker =>
      notSafeContentBlockerFuture.value ?? _initialNotSafeContentBlockerValue;

  @observable
  ObservableFuture<bool> malwareContentBlockerFuture = ObservableFuture.value(
    _initialMalwareBlockerValue,
  );

  @observable
  ObservableFuture<bool> notSafeContentBlockerFuture = ObservableFuture.value(
    _initialNotSafeContentBlockerValue,
  );

  @computed
  BlockerType get blockerType {
    if (notSafeContentBlocker) {
      return BlockerType.nsfwAndMalware;
    }
    if (malwareContentBlocker) {
      return BlockerType.malware;
    }
    return BlockerType.none;
  }

  @computed
  bool get hideNotSafeContentBlocker =>
      _remoteConfigStore.hideNotSafeContentBlocker ||
      !_subscriptionFeaturesStore.malwareBlockingAllowed;

  @computed
  bool get hideMalwareContentBlocker =>
      _remoteConfigStore.hideMalwareBlocker || !_subscriptionFeaturesStore.malwareBlockingAllowed;

  @computed
  String get dnsAddress {
    var replaceDNS = _defaultDNSAddress;
    if (!hideNotSafeContentBlocker && notSafeContentBlocker) {
      replaceDNS = _remoteConfigStore.notSafeContentBlockerDnsAddress;
    } else if (!hideMalwareContentBlocker && malwareContentBlocker) {
      replaceDNS = _remoteConfigStore.malwareBlockerDnsAddress;
    }
    return replaceDNS;
  }

  @action
  Future<bool> getMalwareContentBlocker() =>
      malwareContentBlockerFuture = ObservableFuture(_getAndSetMalwareBlockerContent());

  @action
  Future<bool> getNotSafeContentBlocker() =>
      notSafeContentBlockerFuture = ObservableFuture(_getAndSetNotSafeContentBlocker());

  @action
  Future<bool> _getAndSetMalwareBlockerContent() async {
    try {
      return await _localDBService.getMalwareContentBlocker();
    } catch (e) {
      _logger.handle(e);
      return false;
    }
  }

  @action
  Future<bool> _getAndSetNotSafeContentBlocker() async {
    try {
      return await _localDBService.getNotSafeContentBlocker();
    } catch (e) {
      _logger.handle(e);
      return false;
    }
  }

  @action
  Future<void> toggleMalwareBlocker() async {
    await _localDBService.setMalwareContentBlocker(value: !malwareContentBlocker);
    malwareContentBlockerFuture = ObservableFuture.value(!malwareContentBlocker);
  }

  @action
  Future<void> toggleNotSafeContentBlocker() async {
    final value = !notSafeContentBlocker;
    if (value) {
      await _localDBService.setMalwareContentBlocker(value: value);
      malwareContentBlockerFuture = ObservableFuture.value(value);
    }
    await _localDBService.setNotSafeContentBlocker(value: value);
    notSafeContentBlockerFuture = ObservableFuture.value(value);
  }

  // Call on log out or app termination
  Future<void> disposeStore() async {
    _authReactionDisposer?.call();
  }
}
