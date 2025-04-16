import 'dart:async';
import 'dart:io';

import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/stun_binding_request.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

const kReportBrokenNode = '/connection/report-broken-node';
const kSetMarketingConsent = '/user-preferences/marketing-consent';
const kGetMarketingConsent = '/user-preferences/marketing-consent';
const kGetUserPreferences = '/user-preferences';
const kSetEmailMarketingConsent = '/email-marketing/marketing-consent';
const kDisconnectAllDevices = '/connection/disconnect-all';

class RestApiService extends ApiService {
  RestApiService({
    required VpnApi api,
    required NetworkService networkService,
    required Talker logger,
  })  : _networkService = networkService,
        _apiConnection = api.getConnection(),
        _logger = logger;

  final Connection _apiConnection;
  final NetworkService _networkService;
  final Talker _logger;

  @override
  Future<VPNLocations> fetchVPNLocations([IPType? ipType]) async {
    try {
      final data = (await _apiConnection.connectionConfig(
        ipType: switch (ipType) {
          IPType.datacenter => 'hosting',
          IPType.residential => 'residential',
          _ => null,
        },
      ))
          .data;
      if (data == null) {
        throw Exception('No data found');
      }
      final topLocations = data.topCountries
          .map(
            (code) => VPNLocation(
              code: code,
              ipType: ipType ?? IPType.residential,
            ),
          )
          .toList();

      final locations = data.countries
          .where((it) => !data.topCountries.contains(it))
          .map(
            (code) => VPNLocation(
              code: code,
              ipType: ipType ?? IPType.residential,
            ),
          )
          .toList();

      return VPNLocations(
        topLocations: topLocations,
        locations: locations,
      );
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
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
  Future<void> disconnectAllDevices() async {
    try {
      // TODO(Waldz): Generate API client from API documentation openapi.yaml
      await _networkService.get(kDisconnectAllDevices);
      _logger.info('All devices disconnected');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> udpBlockedCheck() async {
    const domain = 'echo.mysterium.network'; // domain name to resolve
    const serverPort = 3478; // Default STUN port
    var isSocketClosed = false;

    try {
      // Resolve the domain name to an IP address
      final result = await InternetAddress.lookup(domain);
      final serverAddress = result.first.address; // Get the first resolved IP address

      _logger.info('Resolved IP addresses for $domain: $serverAddress');

      // Example STUN Binding Request (binary format)
      final bindingRequest = StunBindingRequest.create().toBytes;

      // Create a socket to the server using UDP
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      // Send the request to the STUN server
      socket.send(bindingRequest, InternetAddress(serverAddress), serverPort);
      _logger.info('Sent STUN Binding Request to $serverAddress:$serverPort');

      // Listen for response
      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            _logger.info('Received response from server: ${datagram.data}');
            socket.close(); // Close the socket after receiving the response
            isSocketClosed = true; // Mark the socket as closed
          }
        }
      });

      // Set up a timeout for receiving the response
      await Future.delayed(const Duration(seconds: 5), () {
        if (!isSocketClosed) {
          _logger.info('No response received within 2seconds');
          socket.close(); // Close the socket after timeout
          throw TimeoutException('No response from STUN server within 2 seconds');
        } else {
          _logger.info('Socket is already closed, no need to close again');
        }
      });
    } catch (e) {
      _logger.log(
        'Error resolving domain: $e',
        logLevel: LogLevel.error,
        exception: e,
      );
      rethrow;
    }
  }
}
