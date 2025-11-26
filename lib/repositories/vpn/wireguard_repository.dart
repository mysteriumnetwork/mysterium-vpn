import 'dart:async';
import 'dart:io';

import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/vpn/base_vpn_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

class WireguardRepository extends BaseVpnRepository {
  WireguardRepository({
    required WireguardDart service,
    required WireguradKeyService wireguradKeyService,
    required super.apiService,
    required super.logger,
  })  : _service = service,
        _wireguradKeyService = wireguradKeyService;

  final WireguardDart _service;
  final WireguradKeyService _wireguradKeyService;

  KeyPair? _wireguardKey;

  @override
  Future<void> init() async {
    await _initWireguardKey();
  }

  Future<void> _initWireguardKey() async {
    try {
      _wireguardKey = await _wireguradKeyService.getWireguradKey();
    } catch (e) {
      logger.handle(e);
    }
  }

  Future<void> _regenerateWireguardKey() async {
    try {
      await disconnect();
      _wireguardKey = await _wireguradKeyService.regenerateWireguardKeys();
    } catch (e) {
      logger.handle(e);
    }
  }

  Future<KeyPair> _getWireguradKey() async {
    if (_wireguardKey == null) {
      await _initWireguardKey();
    }
    return _wireguardKey!;
  }

  @override
  Future<void> setupTunnel() async {
    try {
      await _service.setupTunnel(
        bundleId: Env.bundleId,
        win32ServiceName: win32ServiceName,
        tunnelName: Env.tunnelName,
      );
      logger.info('Wireguard tunnel setup completed');
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> connect({
    required String config,
  }) async {
    try {
      final key = await _getWireguradKey();
      final replaced = config.replaceFirst('%private_key%', key.privateKey);
      await _service.connect(cfg: replaced).timeout(
        const Duration(seconds: vpnConnectionTimeoutSeconds),
        onTimeout: () {
          throw TimeoutException(
            'Wireguard connection timed out after $vpnConnectionTimeoutSeconds seconds',
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
      await _service.disconnect();
      return true;
    }
    return false;
  }

  @override
  Future<bool> isTunnelConfigured() =>
      _service.checkTunnelConfiguration(bundleId: Env.bundleId, tunnelName: Env.tunnelName);

  @override
  Stream<VpnConnectionStatus> statusStream() => _service.statusStream().map(
        (status) => VpnConnectionStatus.fromString(status.name),
      );

  @override
  Future<VpnConnectionStatus> currentStatus() async {
    final status = await _service.status();
    return VpnConnectionStatus.fromString(status.name);
  }

  @override
  Future<void> removeTunnelConfiguration() async {
    try {
      await _service.removeTunnelConfiguration(
        bundleId: Env.bundleId,
        tunnelName: Env.tunnelName,
      );
      logger.info('Wireguard tunnel configuration removed');
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
  }) async {
    try {
      final key = await _getWireguradKey();
      final response = await apiService.fetchVpnConfig(
        request: WireguardConnectRequest(
          publicKey: key.publicKey,
          countryOriginate: countryOriginate,
          country: country,
          city: city,
          ipType: ipType,
          resetConnection: resetConnection,
          osType: Platform.operatingSystem,
          userIntent: userIntent,
          cluster: cluster,
          dns: dnsAddress,
        ),
      );
      return VpnConfig.fromWireguard(response);
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }

  @override
  Future<void> resetApp() async {
    try {
      if (!await isTunnelConfigured()) {
        /// If tunnel is not configured, no need to reset the app
        return;
      }
      if (Platform.isAndroid) {
        return;
      } else if (Platform.isWindows) {
        await _regenerateWireguardKey();
      } else {
        await removeTunnelConfiguration();
      }
    } catch (e) {
      logger.handle(e);
      rethrow;
    }
  }
}
