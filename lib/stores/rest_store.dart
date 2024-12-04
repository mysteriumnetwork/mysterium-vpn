// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';

// Project imports:

part 'rest_store.g.dart';

// ignore: library_private_types_in_public_api
class RestStore = _RestStore with _$RestStore;

abstract class _RestStore with Store {
  _RestStore({
    required ApiService apiService,
    required AuthSessionStore authSessionStore,
  })  : _apiService = apiService,
        _authSessionStore = authSessionStore {
    //checkNotificationsApproval();
  }

  final ApiService _apiService;
  final AuthSessionStore _authSessionStore;

  @observable
  ObservableFuture<Approval>? notificationsApprovalFuture;

  @observable
  ObservableFuture<void> setNotificationsApprovalFuture = ObservableFuture.value(null);

  @readonly
  Approval _notificationsApproval = Approval.notSet;

  @action
  Future<void> checkNotificationsApproval() async {
    if (_authSessionStore.user == null) {
      throw AuthenticationRequiredException();
    }

    notificationsApprovalFuture = ObservableFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () => _apiService.getNotificationsApproval(_authSessionStore.user!),
      ),
    );
    _notificationsApproval = await notificationsApprovalFuture!;
  }

  @action
  Future<void> setNotificationsApproval({required bool status}) async {
    if (_authSessionStore.user == null) {
      throw AuthenticationRequiredException();
    }

    setNotificationsApprovalFuture = ObservableFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () => _apiService.setNotificationsApproval(_authSessionStore.user!, approval: status),
      ),
    );
    await setNotificationsApprovalFuture;
  }
}
