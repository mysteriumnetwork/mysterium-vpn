import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/report_broken_node_request.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

const kFetchIP = 'https://location.mysterium.network/api/v1/location';
const kFetchIPFallback = 'https://ipinfo.io/json';
const kReportBrokenNode = '/connection/report-broken-node';
const kSetMarketingConsent = '/user-preferences/marketing-consent';
const kGetMarketingConsent = '/user-preferences/marketing-consent';
const kGetUserPreferences = '/user-preferences';
const kSetEmailMarketingConsent = '/email-marketing/marketing-consent';

class RestApiService extends ApiService {
  RestApiService({
    required VpnApi api,
    required NetworkService networkService,
    required LocalDBService localDb,
    required Talker logger,
  })  : _networkService = networkService,
        _apiConnection = api.getConnection(),
        _localDb = localDb,
        _logger = logger;

  final Connection _apiConnection;
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
      final data = (await _apiConnection.connectionConfig()).data;
      if (data == null) {
        throw Exception('No data found');
      }

      final topCountryCodes = List<String>.from(data.topCountries)
        ..sort(
          (a, b) => a.tr().compareTo(b.tr()),
        );
      final allCountryCodes = List<String>.from(data.countries)
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
  Future<WireguardConnectResponse> fetchVpnConfig({
    required WireguardConnectRequest request,
  }) async {
    try {
      final response = await _apiConnection.connect(wireguardConnectRequest: request);
      if (response.data == null) {
        throw Exception("config wasn't created");
      }

      return response.data!;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<IPInfo?> getIPAdress() async {
    try {
      final response = await _networkService.fetch(kFetchIP);

      if (response.statusCode == 200) {
        return IPInfo.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load IP info');
      }
    } catch (e) {
      try {
        final fallbackResponse = await _networkService.fetch(kFetchIPFallback);
        if (fallbackResponse.statusCode == 200) {
          return IPInfo.fromJson(fallbackResponse.data as Map<String, dynamic>);
        } else {
          throw Exception('Failed to load IP info from fallback service');
        }
      } catch (fallbackError) {
        return null;
      }
    }
  }

  @override
  Future<void> reportBrokenNode({required ReportBrokenNodeRequest request}) async {
    try {
      await Future.delayed(
        // TODO(Waldz): Generate API client from API documentation openapi.yaml
        const Duration(minutes: 2),
        () => _networkService.post(
          kReportBrokenNode,
          data: request.toJson(),
        ),
      );

      _logger.info('Broken node reported');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
    }
  }

  @override
  Future<void> setUserPrefsMarketingConsent({required bool consent}) async {
    try {
      // TODO(Waldz): Generate API client from API documentation openapi.yaml
      await _networkService.post(
        kSetMarketingConsent,
        data: {
          'consent': consent,
        },
      );
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<bool> getUserPrefsMarketingConsent() async {
    try {
      // TODO(Waldz): Generate API client from API documentation openapi.yaml
      final data = (await _networkService.get(kGetMarketingConsent)).data as Map<String, dynamic>?;
      if (data == null || !data.containsKey('marketing_consent')) {
        throw Exception('No data found');
      }
      return data['marketing_consent'] as bool;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setEmailMarketingConsent({required bool consent}) async {
    try {
      // TODO(Waldz): Generate API client from API documentation openapi.yaml
      await _networkService.post(
        kSetEmailMarketingConsent,
        data: {
          'consent': consent,
        },
      );
    } on ApiException catch (_) {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
