import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
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
    required Talker logger,
    required FlavorConfig env,
  })  : _networkService = networkService,
        _apiConnection = api.getConnection(),
        _logger = logger,
        _env = env;

  final Connection _apiConnection;
  final NetworkService _networkService;
  final LocalDBService _localDb = LocalDBService.instance;
  final Talker _logger;
  final FlavorConfig _env;

  @override
  Future<void> setNotificationsApproval({required bool approval}) async =>
      _localDb.setNotificationsApproval(approval: approval);

  @override
  Future<Approval> getNotificationsApproval() => _localDb.getNotificationsApproval();

  @override
  Future<VPNLocations> fetchVPNLocations({required String keyword}) async {
    try {
      final data = (await _apiConnection.connectionConfig()).data;
      if (data == null) {
        throw Exception('No data found');
      }

      var topCountries = data.topCountries.sortedBy((it) => it.tr()).toList();
      var allCountries =
          data.countries.whereNot(topCountries.contains).sortedBy((it) => it.tr()).toList();

      if (keyword.isNotEmpty) {
        bool isMatch(String it) => it.tr().toLowerCase().contains(keyword);
        topCountries = topCountries.where(isMatch).toList();
        allCountries = allCountries.where(isMatch).toList();
      }

      final dcCountries = _env.values.dcLocations
          .where((it) => allCountries.contains(it) || topCountries.contains(it))
          .toList();

      return VPNLocations(
        allLocations: allCountries.map((code) => VPNLocation(code: code)).toList(),
        topLocations: topCountries.map((code) => VPNLocation(code: code)).toList(),
        dcLocations:
            dcCountries.map((code) => VPNLocation(code: code, ipType: IPType.datacenter)).toList(),
      );
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<VPNLocation>> getRecentLocations({required String keyword}) async {
    var locations = await _localDb.getRecentLocations();
    if (keyword.isNotEmpty) {
      locations = locations
          .where((location) => location.code.tr().toLowerCase().contains(keyword))
          .toList();
    }
    return locations;
  }

  @override
  Future<void> addRecentLocation(VPNLocation location) async {
    final recentLocations = await _localDb.getRecentLocations();
    if (recentLocations.contains(location)) {
      recentLocations.remove(location);
    }
    recentLocations.insert(0, location);
    if (recentLocations.length > 5) {
      recentLocations.removeLast();
    }
    await _localDb.setRecentLocation(recentLocations);
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

  @override
  Future<List<BannerType>> getShownBanners() => _localDb.getShownBanners();

  @override
  Future<void> setShownBanners(List<BannerType> banners) => _localDb.setShownBanners(banners);
}
