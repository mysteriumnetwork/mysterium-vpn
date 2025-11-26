import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

class RestApiService extends ApiService {
  RestApiService({
    required VpnApi api,
    required Talker logger,
  })  : _apiConnection = api.getConnection(),
        _apiEmailMarketing = api.getEmailMarketing(),
        _logger = logger;

  final Connection _apiConnection;
  final EmailMarketing _apiEmailMarketing;
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
    } on ApiException catch (e) {
      if (e.errorCode == DeviceLimitReachedException.code) {
        throw const DeviceLimitReachedException();
      }
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> disconnectAllDevices() async {
    try {
      await _apiConnection.disconnectAll();
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
      // Pick the first IPv4 address, or fallback to the first if none found
      final ipv4 = result.firstWhere(
        (addr) => addr.type == InternetAddressType.IPv4,
        orElse: () => result.first,
      );
      final serverAddress = ipv4.address; // Get the first resolved IP address

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
  Future<void> createMarketingContact({required String? country}) async {
    try {
      await _apiEmailMarketing.createContactRequest(
        createContactRequest: CreateContactRequest(
          country: country,
        ),
      );
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _apiConnection.disconnect();
      _logger.info(
        'Disconnected successfully',
      );
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<bool> getMarketingContactStatus() async {
    try {
      final res = await _apiEmailMarketing.contactStatusRequest();
      return res.data?.consent ?? false;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateMarketingContact({required bool consent}) {
    try {
      return _apiEmailMarketing.updateContactRequest(
        updateContactRequest: UpdateContactRequest(
          consent: consent,
        ),
      );
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Set<UserIntent>> fetchUserIntents() async {
    try {
      final res = await _apiConnection.userIntents();
      final data = res.data ?? const <String>[];

      return data
          .map((it) => UserIntent.values.firstWhereOrNull((value) => value.key == it))
          .nonNulls
          .toSet();
    } catch (e, stack) {
      _logger.handle(e, stack);
      rethrow;
    }
  }

  @override
  Future<OpenVpnConnectResponse> fetchOpenVpnConfig({
    required OpenVpnConnectRequest request,
  }) async {
    try {
      final response = await _apiConnection.connectOpenvpn(openVpnConnectRequest: request);
      if (response.data == null) {
        throw Exception("openvpn config wasn't created");
      }

      return response.data!;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
