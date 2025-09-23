import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'vpn_protocol_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnProtocolStore = _VpnProtocolStore with _$VpnProtocolStore;

abstract class _VpnProtocolStore with Store {
  _VpnProtocolStore(this._localDB, this._analyticsStore) {
    protocolFuture = ObservableFuture(getProtocol());
  }

  final LocalDBService _localDB;
  final AnalyticsStore _analyticsStore;

  @observable
  late ObservableFuture<ProtocolType> protocolFuture;

  @observable
  ProtocolType protocol = ProtocolType.wireguard;

  @action
  Future<ProtocolType> getProtocol() async {
    try {
      final protocol = await _localDB.getProtocolType();
      this.protocol = protocol;
      return protocol;
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
