import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';

part 'intercom_mobile_store.g.dart';

const String intercomAppId = 'sjkeehf4';
const String intercomAndroidApiKey = 'android_sdk-f9955e908e48bf630f3f2a6dc6609c3f4b5aa2b8';
const String intercomIosApiKey = 'ios_sdk-13bd499b260981778455ba0235d7ca612b330582';

// ignore: library_private_types_in_public_api
class IntercomMobileStore = _IntercomMobileStore with _$IntercomMobileStore;

abstract class _IntercomMobileStore extends IntercomStore with Store {
  _IntercomMobileStore({required Intercom intercom})
      : _intercomFuture = ObservableFuture(
          intercom
              .initialize(
                intercomAppId,
                androidApiKey: intercomAndroidApiKey,
                iosApiKey: intercomIosApiKey,
              )
              .then((_) => intercom),
        );

  @observable
  late ObservableFuture<Intercom> _intercomFuture;

  @observable
  bool _isUserLoggedIn = false;

  @override
  @action
  Future<void> registerUser({String? email}) async {
    try {
      final intercom = await _intercomFuture;
      if (email != null) {
        await intercom.loginIdentifiedUser(email: email);
      } else {
        await intercom.loginUnidentifiedUser();
      }
      _isUserLoggedIn = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  @action
  Future<void> logout() async {
    final intercom = await _intercomFuture;
    await intercom.logout();
  }

  @override
  @action
  Future<void> updateUser(
    String email,
    String userId,
  ) async {
    final intercom = await _intercomFuture;
    await intercom.updateUser(
      email: email,
      userId: userId,
    );
  }

  @override
  @action
  Future<void> displayMessageComposer(String message) async {
    final intercom = await _intercomFuture;
    await intercom.displayMessageComposer(message);
  }

  @override
  @action
  Future<void> displayMessenger() async {
    final intercom = await _intercomFuture;
    try {
      if (!_isUserLoggedIn) {
        await registerUser();
      }
      await intercom.displayMessenger();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  @action
  Future<void> displayHelpCenter() async {
    final intercom = await _intercomFuture;
    await intercom.displayHelpCenter();
  }
}
