// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';

// Project imports:

part 'rest_store.g.dart';

// ignore: library_private_types_in_public_api
class RestStore = _RestStore with _$RestStore;

abstract class _RestStore with Store {
  _RestStore({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;

  @observable
  ObservableFuture<Approval>? notificationsApprovalFuture;

  @observable
  ObservableFuture<void> setNotificationsApprovalFuture = ObservableFuture.value(null);

  @readonly
  Approval _notificationsApproval = Approval.notSet;

  @action
  Future<void> checkNotificationsApproval() async {
    notificationsApprovalFuture = ObservableFuture(
      Future.delayed(
        const Duration(seconds: 3),
        _apiService.getNotificationsApproval,
      ),
    );
    _notificationsApproval = await notificationsApprovalFuture!;
  }

  @action
  Future<void> setNotificationsApproval({required bool status}) async {
    setNotificationsApprovalFuture = ObservableFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () => _apiService.setNotificationsApproval(approval: status),
      ),
    );
    await setNotificationsApprovalFuture;
  }
}
