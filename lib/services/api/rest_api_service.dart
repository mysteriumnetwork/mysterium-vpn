import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

const kFetchAllLocations = '/connection/config';
const kCreateConnectionConfig = '/connection/connect';
const kFetchIP = 'https://location.mysterium.network/api/v1/ip';

class RestApiService extends ApiService {
  RestApiService({
    required Dio apiClient,
    required LocalDBService localDb,
  })  : _apiClient = apiClient,
        _localDb = localDb;

  final Dio _apiClient;
  final LocalDBService _localDb;

  @override
  Future<void> setEmailCommunicationApproval({required bool approval}) async =>
      _localDb.setEmailCommunicationApproval(approval: approval);

  @override
  Future<void> setNotificationsApproval({required bool approval}) async =>
      _localDb.setNotificationsApproval(approval: approval);

  @override
  Approval geNotificationsApproval() => _localDb.getNotificationsApproval();

  @override
  Approval getEmailCommunicationApproval() => _localDb.getEmailCommunicationApproval();

  @override
  Future<VPNLocations> fetchVPNLocations({required String keyword}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(kFetchAllLocations);
      if (response.data == null || !response.data!.containsKey('countries')) {
        throw Exception('No data found');
      }
      final topCountryCodes = List<String>.from(response.data!['top_countries'] as List<dynamic>)
        ..sort(
          (a, b) => a.tr().compareTo(b.tr()),
        );
      final allCountryCodes = List<String>.from(response.data!['countries'] as List<dynamic>)
        ..removeWhere(
          topCountryCodes.contains,
        )
        ..sort(
          (a, b) => a.tr().compareTo(b.tr()),
        );
      if (keyword.isNotEmpty) {
        topCountryCodes.removeWhere((element) => !element.tr().toLowerCase().contains(keyword));
        allCountryCodes.removeWhere((element) => !element.tr().toLowerCase().contains(keyword));
      }
      return VPNLocations(
        allLocations: allCountryCodes,
        topLocations: topCountryCodes,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  List<String> getRecentLocations({required String keyword}) {
    final countryCodes = _localDb.getRecentLocations();
    if (keyword.isNotEmpty) {
      final res =
          countryCodes.where((location) => location.tr().toLowerCase().contains(keyword)).toList();
      return res;
    }
    return countryCodes;
  }

  @override
  void addRecentLocation(String location) {
    final recentLocations = _localDb.getRecentLocations();
    if (recentLocations.contains(location)) {
      recentLocations.remove(location);
    }
    recentLocations.insert(0, location);
    if (recentLocations.length > 5) {
      recentLocations.removeLast();
    }
    _localDb.setRecentLocation(recentLocations);
  }

  @override
  Future<VpnConfig> fetchVpnConfig({
    required VpnConfigInput input,
    required String privateKey,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        kCreateConnectionConfig,
        data: input.toJson(),
      );
      if (response.data == null || !response.data!.containsKey('wg_config')) {
        throw Exception("config wasn't created");
      }
      final vpnConfig = VpnConfig.fromJson(response.data!);

      return vpnConfig.copyWith(
        config: vpnConfig.config.replaceFirst('%private_key%', privateKey),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  Future<String?> getIPAdress() async {
    try {
      final res = await Future.delayed(
        const Duration(seconds: 2),
        () async => _apiClient.fetch<Map<String, dynamic>>(
          RequestOptions(baseUrl: kFetchIP),
        ),
      );
      if (res.data != null && res.data!.containsKey('ip')) {
        return res.data!['ip'] as String;
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }
}
