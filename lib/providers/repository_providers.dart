import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/repositories/vpn/openvpn_repository.dart';
import 'package:mysterium_vpn/repositories/vpn/wireguard_repository.dart';

final wireguardRepositoryPOD = Provider<WireguardRepository>(
  (ref) => WireguardRepository(
    service: ref.watch(wireguardServicePOD),
    logger: ref.watch(loggerPOD),
    wireguradKeyService: ref.watch(wireguradKeyServicePOD),
    apiService: ref.watch(apiServicePOD),
  ),
);

final openVpnRepositoryPOD = Provider<OpenVpnRepository>(
  (ref) => OpenVpnRepository(
    service: ref.watch(openVpnServicePOD),
    logger: ref.watch(loggerPOD),
    apiService: ref.watch(apiServicePOD),
  ),
);
