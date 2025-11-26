import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useConfigCatUserUpdater() {
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final abTestingStore = useProvider(abTestingStorePOD);
  final textsStore = useProvider(textsStorePOD);
  final configCatUserStore = useProvider(configCatUserStorePOD);

  useEffect(
    () {
      final disposer = reaction(
        (_) => configCatUserStore.future.value,
        (user) async {
          if (user == null) {
            return;
          }
          await abTestingStore.setUser(user);
          await remoteConfigStore.setUser(user);
          await textsStore.setUser(user);
        },
        fireImmediately: true,
      );

      return disposer.call;
    },
    [remoteConfigStore, abTestingStore, textsStore, configCatUserStore],
  );
}
