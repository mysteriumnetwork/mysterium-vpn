import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:talker/talker.dart';

const kFetchAllLocations = '/connection/config';
const kCreateConnectionConfig = '/connection/connect';
const kFetchIP = 'https://location.mysterium.network/api/v1/ip';

class RestApiService extends ApiService {
  RestApiService({
    required NetworkService networkService,
    required LocalDBService localDb,
    required Talker logger,
  })  : _networkService = networkService,
        _localDb = localDb,
        _logger = logger;

  final NetworkService _networkService;
  final LocalDBService _localDb;
  final Talker _logger;

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
      final data = (await _networkService.get(kFetchAllLocations)).data as Map<String, dynamic>?;

      if (data == null || !data.containsKey('countries')) {
        throw Exception('No data found');
      }
      final topCountryCodes = List<String>.from(data['top_countries'] as List<dynamic>)
        ..sort(
          (a, b) => a.tr().compareTo(b.tr()),
        );
      final allCountryCodes = List<String>.from(data['countries'] as List<dynamic>)
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
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
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
      final data = (await _networkService.post(
        kCreateConnectionConfig,
        data: input.toJson(),
      ))
          .data as Map<String, dynamic>?;
      if (data == null || !data.containsKey('wg_config')) {
        throw Exception("config wasn't created");
      }
      final vpnConfig = VpnConfig.fromJson(data);
      return vpnConfig.copyWith(
        config: vpnConfig.config.replaceFirst('%private_key%', privateKey),
      );
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> getIPAdress() async {
    try {
      final data = (await Future.delayed(
        const Duration(seconds: 2),
        () async => _networkService.fetch(
          kFetchIP,
        ),
      ))
          .data as Map<String, dynamic>?;
      if (data != null && data.containsKey('ip')) {
        return data['ip'] as String;
      }
      return null;
    } on ApiException {
      return null;
    } catch (e) {
      _logger.handle(e);
      return null;
    }
  }
}
