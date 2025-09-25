import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:talker/talker.dart';

part 'dns_store.g.dart';

final dnsRegex = RegExp(r'.*(\DNS\b).*', caseSensitive: false);
const _initialMalwareBlockerValue = false;
const _initialNotSafeContentBlockerValue = false;

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

  @readonly
  bool _malwareBlockerContent = _initialMalwareBlockerValue;

  @readonly
  bool _notSafeContentBlocker = _initialNotSafeContentBlockerValue;

  @observable
  ObservableFuture<bool> malwareBlockerFuture = ObservableFuture.value(_initialMalwareBlockerValue);

  @observable
  ObservableFuture<bool> notSafeContentBlockerFuture =
      ObservableFuture.value(_initialNotSafeContentBlockerValue);

  @computed
  String? get dnsAddress {
    String? replaceDNS;
    if (!_remoteConfigStore.hideNotSafeContentBlocker && _notSafeContentBlocker) {
      replaceDNS = _remoteConfigStore.notSafeContentBlockerDnsAddress;
    } else if (!_remoteConfigStore.hideMalwareBlocker && _malwareBlockerContent) {
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
      return _malwareBlockerContent = await _localDBService.getMalwareBlocker();
    } catch (e) {
      _logger.handle(e);
      return false;
    }
  }

  @action
  Future<bool> _getAndSetNotSafeContentBlocker() async {
    try {
      return _notSafeContentBlocker = await _localDBService.getNotSafeContentBlocker();
    } catch (e) {
      _logger.handle(e);
      return false;
    }
  }

  @action
  Future<void> toggleMalwareBlocker() async {
    await _localDBService.setMalwareBlocker(
      malwareBlocker: !_malwareBlockerContent,
    );
    _malwareBlockerContent = !_malwareBlockerContent;
  }

  @action
  Future<void> toggleNotSafeContentBlocker() async {
    final value = !_notSafeContentBlocker;
    if (value) {
      await _localDBService.setMalwareBlocker(malwareBlocker: value);
      _malwareBlockerContent = value;
    }
    await _localDBService.setNotSafeContentBlocker(
      notSafeContentBlocker: value,
    );
    _notSafeContentBlocker = value;
  }

  String replaceDNSAddress(String config) {
    if (dnsAddress.isNotNullOrEmpty) {
      // Find all matches in the content
      final match = dnsRegex.firstMatch(config);
      if (match?[0] != null) {
        final dnsLine = match![0]!;
        return config.replaceFirst(dnsLine, 'DNS = $dnsAddress');
      }
    }
    return config;
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _authReactionDisposer?.call();
  }
}
