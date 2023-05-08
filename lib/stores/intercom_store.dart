import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

part 'intercom_store.g.dart';

const String intercomAppId = 'sjkeehf4';
const String intercomAndroidApiKey = 'android_sdk-f9955e908e48bf630f3f2a6dc6609c3f4b5aa2b8';
const String intercomIosApiKey = 'ios_sdk-13bd499b260981778455ba0235d7ca612b330582';

// ignore: library_private_types_in_public_api
class IntercomStore = _IntercomStore with _$IntercomStore;

abstract class _IntercomStore with Store {
  _IntercomStore({required Intercom intercom, required LocalDBService localDb})
      : _intercom = intercom,
        _localDb = localDb;

  @action
  Future<void> initialize() async {
    await _intercom.initialize(
      intercomAppId,
      androidApiKey: intercomAndroidApiKey,
      iosApiKey: intercomIosApiKey,
    );
  }

  final Intercom _intercom;
  final LocalDBService _localDb;
}
