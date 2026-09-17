import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'real_ip_info_store.g.dart';

// ignore: library_private_types_in_public_api
class RealIPInfoStore = _RealIPInfoStore with _$RealIPInfoStore;

abstract class _RealIPInfoStore with Store {
  _RealIPInfoStore(this._repository, this._analyticsStore) {
    infoFuture = ObservableFuture(_fetch());
  }
  final IpInfoRepository _repository;
  final AnalyticsStore _analyticsStore;

  @observable
  late ObservableFuture<IPInfo?> infoFuture;

  @computed
  IPInfo? get info => infoFuture.value;

  Future<IPInfo?> _fetch() async {
    final info = await _repository.resolve();
    if (info != null) {
      unawaited(
        _analyticsStore.setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.countryUser,
            value: info.country,
          ),
        ),
      );
    }
    return info;
  }

  @action
  Future<void> refresh() async {
    infoFuture = ObservableFuture(_fetch());
    await infoFuture;
  }
}
