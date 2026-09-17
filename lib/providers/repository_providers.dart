import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

final authFlowRepositoryPOD = Provider<AuthFlowRepository>(
  (ref) => LocalAuthFlowRepository(ref.watch(secureStorageServicePOD)),
);

final reviewPromptRepositoryPOD = Provider<ReviewPromptRepository>(
  (ref) => LocalReviewPromptRepository(ref.watch(sharedPreferenceServicePOD)),
);

final appSettingsRepositoryPOD = Provider<AppSettingsRepository>(
  (ref) => LocalAppSettingsRepository(ref.watch(sharedPreferenceServicePOD)),
);

final promptsRepositoryPOD = Provider<PromptsRepository>(
  (ref) => LocalPromptsRepository(ref.watch(localDBServicePOD)),
);

final connectionSettingsRepositoryPOD = Provider<ConnectionSettingsRepository>(
  (ref) => LocalConnectionSettingsRepository(
    db: ref.watch(localDBServicePOD),
    prefs: ref.watch(sharedPreferenceServicePOD),
  ),
);

final sessionRepositoryPOD = Provider<SessionRepository>(
  (ref) => LocalSessionRepository(
    secureStorage: ref.watch(secureStorageServicePOD),
    db: ref.watch(localDBServicePOD),
  ),
);

final ipInfoRepositoryPOD = Provider<IpInfoRepository>(
  (ref) => RestIpInfoRepository(
    api: ref.watch(externalApiServicePOD),
    preferences: ref.watch(sharedPreferenceServicePOD),
    wireguardService: ref.watch(wireguardServicePOD),
  ),
);

final deviceIdRepositoryPOD = Provider<DeviceIdRepository>(
  (ref) => PlatformDeviceIdRepository(secureStorageService: ref.watch(secureStorageServicePOD)),
);

final favoriteIpsRepositoryPOD = Provider<FavoriteIpsRepository>(
  (ref) => LocalFavoriteIpsRepository(
    db: ref.watch(localDBServicePOD),
    availabilityService: ref.watch(favoriteIpsAvailabilityServicePOD),
  ),
);

final recentLocationsRepositoryPOD = Provider<RecentLocationsRepository>(
  (ref) => LocalRecentLocationsRepository(ref.watch(localDBServicePOD)),
);

final locationsRepositoryPOD = Provider<LocationsRepository>(
  (ref) => RestLocationsRepository(
    connection: ref.watch(vpnApiPOD).getConnection(),
    db: ref.watch(localDBServicePOD),
    logger: ref.watch(loggerPOD),
    session: ref.watch(authSessionStorePOD),
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
