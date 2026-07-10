import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_user_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';

void useConfigCatUserUpdater() {
  final remoteConfigStore = useProvider<RemoteConfigStore>(remoteConfigStorePOD);
  final abTestingStore = useProvider<ABTestingStore>(abTestingStorePOD);
  final configCatUserStore = useProvider<ConfigCatUserStore>(configCatUserStorePOD);

  useEffect(() {
    final disposer = reaction((_) => configCatUserStore.future.value, (user) async {
      if (user == null) {
        return;
      }
      await abTestingStore.setUser(user);
      await remoteConfigStore.setUser(user);
    }, fireImmediately: true);

    return disposer.call;
  }, [remoteConfigStore, abTestingStore, configCatUserStore]);
}
