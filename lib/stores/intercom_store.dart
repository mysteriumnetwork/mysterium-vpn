import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobx/mobx.dart';

part 'intercom_store.g.dart';

const String intercomAppId = 'sjkeehf4';
const String intercomAndroidApiKey = 'android_sdk-f9955e908e48bf630f3f2a6dc6609c3f4b5aa2b8';
const String intercomIosApiKey = 'ios_sdk-13bd499b260981778455ba0235d7ca612b330582';

// ignore: library_private_types_in_public_api
class IntercomStore = _IntercomStore with _$IntercomStore;

abstract class _IntercomStore with Store {
  _IntercomStore({required Intercom intercom}) : _intercom = intercom;

  @action
  Future<void> initialize() async {
    try {
      if (_isIntercomInitialized) {
        return;
      }
      await _intercom.initialize(
        intercomAppId,
        androidApiKey: intercomAndroidApiKey,
        iosApiKey: intercomIosApiKey,
      );
      _isIntercomInitialized = true;
    } catch (e) {
      _isIntercomInitialized = false;

      debugPrint(e.toString());
    }
  }

  @observable
  bool _isIntercomInitialized = false;

  @observable
  bool _isUserLoggedIn = false;

  @action
  Future<void> registerUser({
    String? email,
  }) async {
    try {
      await initialize();
      email != null
          ? await _intercom.loginIdentifiedUser(
              email: email,
            )
          : await _intercom.loginUnidentifiedUser();
      _isUserLoggedIn = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @action
  Future<void> logout() async {
    await _intercom.logout();
  }

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

  @action
  Future<void> displayMessageComposer(String message) async {
    await _intercom.displayMessageComposer(message);
  }

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

  @action
  Future<void> displayHelpCenter() async {
    await _intercom.displayHelpCenter();
  }

  final Intercom _intercom;
}
