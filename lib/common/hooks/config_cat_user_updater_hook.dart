import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useConfigCatUserUpdater() {
  final vpnStore = useProvider(vpnStorePOD);
  final authSessionStore = useProvider(authSessionStorePOD);
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final abTestingStore = useProvider(abTestingStorePOD);
  final textsStore = useProvider(textsStorePOD);

  final handleNotify = useCallback(
    () => Future.wait([
      remoteConfigStore.notifyUserChanged(),
      abTestingStore.notifyUserChanged(),
      textsStore.notifyUserChanged(),
    ]),
    [remoteConfigStore, abTestingStore, textsStore],
  );

  useReaction(
    () => vpnStore.originIP,
    (originIP) {
      if (originIP == null) {
        return;
      }

      unawaited(handleNotify());
    },
    keys: [vpnStore, handleNotify],
  );

  useReaction(
    () => authSessionStore.userFuture,
    (userFuture) async {
      await userFuture;
      unawaited(handleNotify());
    },
    keys: [authSessionStore, handleNotify],
  );
}
