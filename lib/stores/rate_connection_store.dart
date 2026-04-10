import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart';

part 'rate_connection_store.g.dart';

// ignore: library_private_types_in_public_api
class RateConnectionStore = _RateConnectionStore with _$RateConnectionStore;

abstract class _RateConnectionStore with Store {
  _RateConnectionStore(this._rateConnectionMode, this._analyticsStore, this._vpnStore);

  final AnalyticsStore _analyticsStore;
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
    _analyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit);
    try {
      await _vpnStore.submitRateConnection(
        mode: _rateConnectionMode,
        reasons: _rateConnectionReasons.isEmpty
            ? RateConnectionReason.other.name
            : _rateConnectionReasons.toList().map((e) => e.name).join(','),
        feedback: feedback,
      );
      _analyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmitSuccess);
    } catch (e) {
      _analyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmitError);
      rethrow;
    }
  }

  @action
  void cancelRateConnection() {
    _analyticsStore.logRateConnectionCancel(_rateConnectionMode);
  }
}
