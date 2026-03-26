import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';

const kFetchIP = 'https://location.mysterium.network/api/v1/location';
const kFetchIPFallback = 'https://ipinfo.io/json';
const kFetchIPAddress = 'https://ip.mysterium.network';

class RestExternalApiService with ExternalApiService {
  const RestExternalApiService(this._networkService, this._logger);

  final NetworkService _networkService;
  final Talker _logger;

  @override
  Future<IPInfo?> getIPInfo() async =>
      await _fetchIpInfo(kFetchIP) ?? await _fetchIpInfo(kFetchIPFallback);

  Future<IPInfo?> _fetchIpInfo(String url) async {
    try {
      final response = await _networkService.fetch(url);
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      return IPInfo.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.error('Failed to fetch IP info for $url', e, stack);
    }
    return null;
  }

  @override
  Future<String?> getIPAddress() async {
    try {
      final response = await _networkService.fetch(kFetchIPAddress);
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      return response.data as String?;
    } catch (e, stack) {
      _logger.error('Failed to fetch IP address', e, stack);
    }
    return null;
  }
}
