import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useMQTTService() {
  final mqtt = useProvider(vpnApiMQTTPOD);
  final remoteConfigStore = useProvider(remoteConfigStorePOD);

  useEffect(
    () {
      mqtt.start().then((_) {
        mqtt.subscribe('config-cat/changed').listen(
          (_) {
            remoteConfigStore.refresh();
          },
        );
      });
      return null;
    },
    [mqtt],
  );
}
