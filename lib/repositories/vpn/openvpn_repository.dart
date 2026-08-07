import 'dart:async';
import 'dart:io';

import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/vpn/base_vpn_repository.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:vpn_api/vpn_api.dart';

class OpenVpnRepository extends BaseVpnRepository {
  OpenVpnRepository({
    required OpenVPNDart service,
    required super.apiService,
    required super.logger,
  }) : _service = service;

  final OpenVPNDart _service;

  @override
  Future<void> init() async {
    await _service.initialize(
      providerBundleIdentifier: Env.openVpnExtensionId,
      localizedDescription: Env.openVpnExtensionName,
    );
  }

  @override
  Future<void> setupTunnel() async {
    try {
      await _service.setupTunnel();
      logger.info('OpenVPN tunnel setup completed');
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> connect({required String config}) async {
    try {
      var finalConfig = config;
      if (Platform.isWindows) {
        // Remove 'client-cert-not-required' for Windows as it causes issues
        // Windows OpenVPN client doesn't support 'client-cert-not-required' directive
        finalConfig = config.replaceAll('client-cert-not-required', '');

        // Fix cipher negotiation - replace CBC-only ciphers with GCM ciphers
        // Modern OpenVPN servers require AEAD ciphers (GCM) for security
        finalConfig = finalConfig.replaceAll(
          RegExp(r'cipher\s+AES-256-CBC', multiLine: true),
          'cipher AES-256-GCM',
        );
        finalConfig = finalConfig.replaceAll(
          RegExp(r'data-ciphers\s+AES-256-CBC', multiLine: true),
          'data-ciphers AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305',
        );
      }
      await _service
          .connect(finalConfig)
          .timeout(
            const Duration(seconds: vpnConnectionTimeoutSeconds),
            onTimeout: () {
              throw TimeoutException(
                'OpenVPN connection timed out after $vpnConnectionTimeoutSeconds seconds',
              );
            },
          );
    } on TimeoutException catch (e, stackTrace) {
      logger.handle(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      logger.handle(e, stackTrace);
      throw VpnConnectException(e.toString());
    }
  }

  @override
  Future<bool> disconnect() async {
    final status = await currentStatus();
    if (status == VpnConnectionStatus.connected) {
      _service.disconnect();
      return true;
    }
    return false;
  }

  @override
  Future<bool> isTunnelConfigured() => _service.checkTunnelConfiguration();

  @override
  Stream<VpnConnectionStatus> statusStream() =>
      _service.statusStream().map((status) => VpnConnectionStatus.fromString(status.name));

  @override
  Future<VpnConnectionStatus> currentStatus() async {
    final status = await _service.getVPNStatus();
    return VpnConnectionStatus.fromString(status.name);
  }

  @override
  Future<void> removeTunnelConfiguration() async {
    try {
      await _service.removeTunnelConfiguration();
      logger.info('OpenVPN tunnel configuration removed');
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<VpnConfig> fetchVpnConfig({
    required String? countryOriginate,
    required String? country,
    required String? city,
    required String? ipType,
    required String? userIntent,
    required String? cluster,
    required bool? resetConnection,
    required String dnsAddress,
    String? targetIp,
  }) async {
    try {
      final response = await apiService.fetchOpenVpnConfig(
        request: OpenVpnConnectRequest(
          countryOriginate: countryOriginate,
          country: country,
          city: city,
          ipType: ipType,
          resetConnection: resetConnection,
          osType: Platform.operatingSystem,
          userIntent: userIntent,
          cluster: cluster,
          dns: dnsAddress,
          targetIp: targetIp,
        ),
      );
      return VpnConfig.fromOpenVpn(response);
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> resetApp() async {
    try {
      if (Platform.isAndroid || Platform.isWindows) {
        return;
      }
      await removeTunnelConfiguration();
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }
}
