import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:vpn_api/vpn_api.dart';

part 'rate_connection_store.g.dart';

// ignore: library_private_types_in_public_api
class RateConnectionStore = _RateConnectionStore with _$RateConnectionStore;

abstract class _RateConnectionStore with Store {
  _RateConnectionStore(
    this._rateConnectionMode,
    this._analyticsStore,
    this._apiService,
    this._vpnStore,
  );

  final AnalyticsStore _analyticsStore;
  final ApiService _apiService;
  final VpnStore _vpnStore;
  final RateConnectionRequestModeEnum _rateConnectionMode;

  final ObservableList<RateConnectionReason> _rateConnectionReasons =
      ObservableList<RateConnectionReason>();

  @computed
  bool get isLikeMode => _rateConnectionMode == RateConnectionRequestModeEnum.like;

  @computed
  bool get isDislikeMode => _rateConnectionMode == RateConnectionRequestModeEnum.dislike;

  @computed
  List<RateConnectionReason> get selectedReasons => _rateConnectionReasons.toList();

  @observable
  String feedback = '';

  @computed
  List<RateConnectionReason> get showReasons =>
      isLikeMode ? RateConnectionReason.likeReasons : RateConnectionReason.dislikeReasons;

  @action
  void toggleRateConnectionReason(RateConnectionReason reason) {
    if (!showReasons.contains(reason)) {
      return;
    }
    if (_rateConnectionReasons.contains(reason)) {
      _rateConnectionReasons.remove(reason);
    } else {
      _rateConnectionReasons.add(reason);
    }
  }

  @action
  Future<void> submitRateConnection() async {
    assert(_vpnStore.vpnConnection != null, 'VPN connection must not be null');
    assert(_vpnStore.wireguardKey?.publicKey != null, 'Wireguard public key must not be null');

    _analyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit);
    await _apiService.rateConnection(
      request: RateConnectionRequest(
        mode: _rateConnectionMode,
        reasons: _rateConnectionReasons.isEmpty
            ? RateConnectionReason.other.name
            : _rateConnectionReasons.toList().map((e) => e.name).join(','),
        feedback: feedback,
        country: _vpnStore.vpnConnection!.location.id,
        ipType: _vpnStore.vpnConnection!.location.ipType.name,
        publicKey: _vpnStore.wireguardKey!.publicKey,
      ),
    );
    _vpnStore.connectionRated = _rateConnectionMode;
  }

  @action
  void cancelRateConnection() {
    _analyticsStore.logRateConnectionCancel(_rateConnectionMode);
  }
}
