import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

const kGetInfo = '$baseUrl/accounts/invitation_code';

class RestApiService extends ApiService {
  RestApiService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;
  final _sharedPrefs = SharedPreferenceService();

  @override
  Future<void> getApi() async {
    _dio.get(kGetInfo);
  }

  @override
  Future<bool> setEmailCommunicationApproval({required bool approval}) async =>
      _sharedPrefs.setEmailCommunicationApproval(approval: approval);

  @override
  Future<bool> setNotificationsApproval({required bool approval}) async =>
      _sharedPrefs.setNotificationsApproval(approval: approval);

  @override
  bool geNotificationsApproval() => _sharedPrefs.getNotificationsApproval() ?? false;

  @override
  bool getEmailCommunicationApproval() => _sharedPrefs.getEmailCommunicationApproval() ?? false;
}
