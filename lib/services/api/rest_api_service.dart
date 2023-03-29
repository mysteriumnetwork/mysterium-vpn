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
  Future<List<Location>> fetchAllLocations({required String keyword}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(kFetchAllLocations);
      if (response.data == null || !response.data!.containsKey('countries')) {
        throw Exception('No data found');
      }
      final countryCodes = List<String>.from(response.data!['countries'] as List<dynamic>);
      final locations = countryCodes
          .map(
            (e) => Location(countryCode: e, countryName: e.tr()),
          )
          .toList();
      if (keyword.isNotEmpty) {
        return locations
            .where((location) => location.countryName.tr().toLowerCase().contains(keyword))
            .toList();
      }
      return locations;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  Future<List<Location>> fetchTopLocations({required String keyword}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(kFetchAllLocations);
      if (response.data == null || !response.data!.containsKey('countries')) {
        throw Exception('No data found');
      }
      final countryCodes = List<String>.from(response.data!['countries'] as List<dynamic>);
      final locations = countryCodes
          .map(
            (e) => Location(countryCode: e, countryName: e.tr()),
          )
          .toList();
      if (keyword.isNotEmpty) {
        return locations
            .where((location) => location.countryName.tr().toLowerCase().contains(keyword))
            .toList();
      }
      return locations;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }

  @override
  Future<List<Location>> getRecentLocations({required String keyword}) async =>
      Future.delayed(const Duration(seconds: 1), () {
        final countryCodes = _localDb.getRecentLocations();
        final locations = countryCodes
            .map(
              (e) => Location(countryCode: e, countryName: e.tr()),
            )
            .toList();
        if (keyword.isNotEmpty) {
          return locations
              .where((location) => location.countryName.tr().toLowerCase().contains(keyword))
              .toList();
        }
        return locations;
      });

  @override
  Future<void> setRecentLocation({required String location}) {
    final recentLocations = _localDb.getRecentLocations();
    if (recentLocations.contains(location)) {
      recentLocations.remove(location);
    }
    recentLocations.insert(0, location);
    if (recentLocations.length > 5) {
      recentLocations.removeLast();
    }
    return _localDb.setRecentLocation(recentLocations);
  }

  @override
  Future<VpnConfig> fetchVpnConfig({required VpnConfigInput input}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        kCreateConnectionConfig,
        data: input.toJson(),
      );
      if (response.data == null || !response.data!.containsKey('wg_config')) {
        throw Exception("config wasn't created");
      }
      return VpnConfig.fromJson(response.data!);
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e);
    }
  }
}
