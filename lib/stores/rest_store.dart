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
  }) : _apiService = apiService {
    checkEmailCommunicationApproval();
    //checkNotificationsApproval();
  }

  final ApiService _apiService;

  @observable
  ObservableFuture<Approval>? emailCommunicationApprovalFuture;

  @observable
  ObservableFuture<void> setEmailCommunicationApprovalFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<Approval>? notificationsApprovalFuture;

  @observable
  ObservableFuture<void> setNotificationsApprovalFuture = ObservableFuture.value(null);

  @readonly
  Approval _emailCommunicationApproval = Approval.notSet;

  @readonly
  Approval _notificationsApproval = Approval.notSet;

  @action
  Future<void> checkEmailCommunicationApproval() async {
    emailCommunicationApprovalFuture = ObservableFuture(
      Future.delayed(const Duration(seconds: 3), _apiService.getEmailCommunicationApproval),
    );
    _emailCommunicationApproval = await emailCommunicationApprovalFuture!;
  }

  @action
  Future<void> checkNotificationsApproval() async {
    notificationsApprovalFuture = ObservableFuture(
      Future.delayed(const Duration(seconds: 3), _apiService.geNotificationsApproval),
    );
    _notificationsApproval = await notificationsApprovalFuture!;
  }

  @action
  Future<void> setEmailCommunicationApproval({required bool status}) async {
    setEmailCommunicationApprovalFuture = ObservableFuture(
      Future.delayed(
        const Duration(seconds: 3),
        () => _apiService.setEmailCommunicationApproval(approval: status),
      ),
    );
    await setEmailCommunicationApprovalFuture;
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
