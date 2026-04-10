import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';

void useMQTTService() {
  final mqtt = useProvider<MQTTService>(vpnApiMQTTPOD);
  final remoteConfigStore = useProvider<RemoteConfigStore>(remoteConfigStorePOD);

  useEffect(() {
    mqtt.start().then((_) {
      mqtt.subscribe('config-cat/changed').listen((_) {
        remoteConfigStore.refresh();
      });
    });
    return null;
  }, [mqtt]);
}
