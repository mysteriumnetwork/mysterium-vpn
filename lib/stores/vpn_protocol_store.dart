import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'vpn_protocol_store.g.dart';

const defaultProtocol = ProtocolType.wireguard;

// ignore: library_private_types_in_public_api
class VpnProtocolStore = _VpnProtocolStore with _$VpnProtocolStore;

abstract class _VpnProtocolStore with Store {
  _VpnProtocolStore(this._localDB, this._analyticsStore, this._remoteConfigStore) {
    protocolFuture = ObservableFuture(getProtocol());
  }

  final LocalDBService _localDB;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;

  @observable
  late ObservableFuture<ProtocolType> protocolFuture;

  @observable
  ProtocolType protocol = defaultProtocol;

  @action
  Future<ProtocolType> getProtocol() async {
    try {
      if (!_remoteConfigStore.isProtocolPickerAvailable) {
        return protocol = ProtocolType.openvpn;
      }
      return protocol = await _localDB.getProtocolType();
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap(
          {
            'platform': defaultTargetPlatform.name,
            'hint': 'Failed to get protocol from local DB',
          },
        ),
      );
      rethrow;
    }
  }

  @action
  Future<void> setProtocol(ProtocolType newProtocol) async {
    if (!_remoteConfigStore.isProtocolPickerAvailable) {
      return;
    }
    try {
      protocol = newProtocol;
      await _localDB.setProtocolType(newProtocol);
      _analyticsStore
          .logEvent(AnalyticsEvent.changeProtocolType, parameters: {'protocol': newProtocol.name});
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap(
          {
            'platform': defaultTargetPlatform.name,
            'hint': 'Failed to set protocol in local DB',
          },
        ),
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.changeProtocolTypeError,
        parameters: {
          'error': e.toString(),
          'protocol': newProtocol.name,
        },
      );
      rethrow;
    }
  }
}
