import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';

part 'intercom_mobile_store.g.dart';

// ignore: library_private_types_in_public_api
class IntercomMobileStore = _IntercomMobileStore with _$IntercomMobileStore;

abstract class _IntercomMobileStore extends IntercomStore with Store {
  _IntercomMobileStore({required Intercom intercom}) : _intercom = intercom;

  final Intercom _intercom;

  @observable
  bool _isUserLoggedIn = false;

  @override
  @action
  Future<void> registerUser({String? email}) async {
    try {
      if (email != null) {
        await _intercom.loginIdentifiedUser(email: email);
      } else {
        await _intercom.loginUnidentifiedUser();
      }
      _isUserLoggedIn = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  @action
  Future<void> logout() async {
    await _intercom.logout();
  }

  @override
  @action
  Future<void> updateUser(
    String email,
    String userId,
  ) async {
    await _intercom.updateUser(
      email: email,
      userId: userId,
    );
  }

  @override
  @action
  Future<void> displayMessageComposer(String message) async {
    await _intercom.displayMessageComposer(message);
  }

  @override
  @action
  Future<void> displayMessenger() async {
    try {
      if (!_isUserLoggedIn) {
        await registerUser();
      }
      await _intercom.displayMessenger();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  @action
  Future<void> displayHelpCenter() async {
    await _intercom.displayHelpCenter();
  }
}
