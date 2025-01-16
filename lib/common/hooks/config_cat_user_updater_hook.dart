import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useConfigCatUserUpdater() {
  final vpnStore = useProvider(vpnStorePOD);
  final authSessionStore = useProvider(authSessionStorePOD);
  final configCatService = useProvider(configCatServicePOD);

  useReaction(
    () => vpnStore.originIP,
    (originIP) {
      if (originIP == null) {
        return;
      }

      configCatService.setOriginIP(originIP);
    },
    keys: [vpnStore, configCatService],
    fireImmediately: true,
  );

  useReaction(
    () => authSessionStore.userFuture,
    (userFuture) async {
      final user = await userFuture;

      if (user == null) {
        configCatService.clearUser();
      } else {
        configCatService.setUserInfo(identifier: user.userId, email: user.username);
      }
    },
    keys: [authSessionStore, configCatService],
    fireImmediately: true,
  );
}
