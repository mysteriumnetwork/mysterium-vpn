import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'rate_connection_store.g.dart';

// ignore: library_private_types_in_public_api
class RateConnectionStore = _RateConnectionStore with _$RateConnectionStore;

abstract class _RateConnectionStore with Store {
  _RateConnectionStore(
    this._analyticsStore,
  );

  final AnalyticsStore _analyticsStore;

  final ObservableList<RateConnectionReason> _rateConnectionReasons =
      ObservableList<RateConnectionReason>();

  @readonly
  RateConnectionMode? _rateConnectionMode;

  @computed
  bool get isLikeMode => _rateConnectionMode == RateConnectionMode.like;
  @computed
  bool get isDislikeMode => _rateConnectionMode == RateConnectionMode.dislike;

  @computed
  List<RateConnectionReason> get selectedReasons => _rateConnectionReasons.toList();

  @observable
  String feedback = '';

  VpnConnection? connection;

  @readonly
  bool _isSubmitted = false;

  @computed
  List<RateConnectionReason> get showReasons =>
      isLikeMode ? RateConnectionReason.likeReasons : RateConnectionReason.dislikeReasons;

  @action
  void reset() {
    _rateConnectionMode = null;
    _rateConnectionReasons.clear();
    feedback = '';
    _isSubmitted = false;
  }

  @action
  void setRateConnectionMode(RateConnectionMode mode, VpnConnection? connection) {
    this.connection = connection;
    _rateConnectionMode = mode;
    _rateConnectionReasons.clear();
    _analyticsStore.logRateConnnectionClicked(mode);
  }

  @action
  void toggleRateConnectionReason(RateConnectionReason reason) {
    if (_rateConnectionReasons.contains(reason)) {
      _rateConnectionReasons.remove(reason);
    } else {
      _rateConnectionReasons.add(reason);
    }
  }

  @action
  void submitRateConnection() {
    if (_rateConnectionMode != null && connection != null) {
      _analyticsStore.logRateConnectionSubmit(
        mode: _rateConnectionMode!,
        reasons: _rateConnectionReasons.toList(),
        feedback: feedback,
        countryCode: connection!.location.code,
        ipType: connection!.location.ipType,
        ipAddress: connection!.connectionIP,
      );
    }
    _isSubmitted = true;
  }

  @action
  void cancelRateConnection() {
    if (_rateConnectionMode != null) {
      _analyticsStore.logRateConnectionCancel(
        _rateConnectionMode!,
      );
    }
  }
}
