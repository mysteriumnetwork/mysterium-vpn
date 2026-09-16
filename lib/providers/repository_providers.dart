import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

final locationsRepositoryPOD = Provider<LocationsRepository>(
  (ref) => RestLocationsRepository(
    connection: ref.watch(vpnApiPOD).getConnection(),
    db: ref.watch(localDBServicePOD),
    logger: ref.watch(loggerPOD),
    isAuthenticated: () => ref.read(authSessionStorePOD).isAuthenticated,
  ),
);

final wireguardRepositoryPOD = Provider<WireguardRepository>(
  (ref) => WireguardRepository(
    service: ref.watch(wireguardServicePOD),
    logger: ref.watch(loggerPOD),
    wireguardKeyRepository: ref.watch(wireguardKeyRepositoryPOD),
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

final pushNotificationsRepositoryPOD = Provider<NotificationsRepository>(
  (ref) => isDesktop()
      ? DesktopNotificationsRepository()
      : OnesignalNotificationsRepository(logger: ref.watch(loggerPOD)),
);
