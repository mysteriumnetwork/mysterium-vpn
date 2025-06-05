import 'dart:async';
import 'dart:io';

import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
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
        _apiEmailMarketing = api.getEmailMarketing(),
        _logger = logger;

  final Connection _apiConnection;
  final EmailMarketing _apiEmailMarketing;
  final NetworkService _networkService;
  final Talker _logger;

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
      _logger.info(
        'Error resolving domain: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> rateConnection({
    required RateConnectionRequest request,
  }) async {
    try {
      await _apiConnection.rateConnection(
        rateConnectionRequest: request,
      );
      _logger.info('Connection rated successfully');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setMarketingConsentStatus({required bool consent}) async {
    try {
      await _apiEmailMarketing.setMarketingConsent(
        marketingPermissionsRequest: MarketingPermissionsRequest(
          consent: consent,
        ),
      );
      _logger.info(
        'Marketing consent status set to $consent',
      );
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
