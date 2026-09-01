import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

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

final pushNotificationsRepositoryPOD = Provider<NotificationsRepository>(
  (ref) => isPushSupported()
      ? FcmNotificationsRepository(
          logger: ref.watch(loggerPOD),
          notifierService: ref.watch(notifierServicePOD),
          analyticsStore: ref.watch(analyticsStorePOD),
        )
      : DesktopNotificationsRepository(),
);
