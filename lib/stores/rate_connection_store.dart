import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/vpn/i_vpn.dart';
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
  @observable
  ObservableFuture<void>? submitRateConnectionFuture;

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
    if (_vpnStore.vpnConnection != null && _vpnStore.publicKey != null) {
      _analyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit);
      submitRateConnectionFuture = ObservableFuture(
        _apiService.rateConnection(
          request: RateConnectionRequest(
            mode: _rateConnectionMode,
            reasons: _rateConnectionReasons.isEmpty
                ? RateConnectionReason.other.name
                : _rateConnectionReasons.toList().map((e) => e.name).join(','),
            feedback: feedback,
            country: _vpnStore.vpnConnection!.location.id,
            ipType: _vpnStore.vpnConnection!.location.ipType.name,
            publicKey: _vpnStore.publicKey!,
          ),
        ),
      );
      await submitRateConnectionFuture;
      _vpnStore.connectionRated = _rateConnectionMode;
    }
  }

  @action
  void cancelRateConnection() {
    _analyticsStore.logRateConnectionCancel(
      _rateConnectionMode,
    );
  }
}
