import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'dns_store.g.dart';

final dnsRegex = RegExp(r'.*(\DNS\b).*', caseSensitive: false);
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
  ) {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
          malwareBlockerFuture = ObservableFuture(getMalwareBlockerContent());
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
  ReactionDisposer? _authReactionDisposer;

  @computed
  bool get malwareBlockerContent => malwareBlockerFuture.value ?? _initialMalwareBlockerValue;

  @computed
  bool get notSafeContentBlocker =>
      notSafeContentBlockerFuture.value ?? _initialNotSafeContentBlockerValue;

  @observable
  ObservableFuture<bool> malwareBlockerFuture = ObservableFuture.value(_initialMalwareBlockerValue);

  @observable
  ObservableFuture<bool> notSafeContentBlockerFuture =
      ObservableFuture.value(_initialNotSafeContentBlockerValue);

  @computed
  String get dnsAddress {
    var replaceDNS = _defaultDNSAddress;
    if (!_remoteConfigStore.hideNotSafeContentBlocker && notSafeContentBlocker) {
      replaceDNS = _remoteConfigStore.notSafeContentBlockerDnsAddress;
    } else if (!_remoteConfigStore.hideMalwareBlocker && malwareBlockerContent) {
      replaceDNS = _remoteConfigStore.malwareBlockerDnsAddress;
    }
    return replaceDNS;
  }

  @action
  Future<bool> getMalwareBlockerContent() =>
      malwareBlockerFuture = ObservableFuture(_getAndSetMalwareBlockerContent());

  @action
  Future<bool> getNotSafeContentBlocker() =>
      notSafeContentBlockerFuture = ObservableFuture(_getAndSetNotSafeContentBlocker());

  @action
  Future<bool> _getAndSetMalwareBlockerContent() async {
    try {
      return await _localDBService.getMalwareBlocker();
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
    await _localDBService.setMalwareBlocker(
      malwareBlocker: !malwareBlockerContent,
    );
    malwareBlockerFuture = ObservableFuture.value(!malwareBlockerContent);
  }

  @action
  Future<void> toggleNotSafeContentBlocker() async {
    final value = !notSafeContentBlocker;
    if (value) {
      await _localDBService.setMalwareBlocker(malwareBlocker: value);
      malwareBlockerFuture = ObservableFuture.value(value);
    }
    await _localDBService.setNotSafeContentBlocker(
      notSafeContentBlocker: value,
    );
    notSafeContentBlockerFuture = ObservableFuture.value(value);
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _authReactionDisposer?.call();
  }
}
