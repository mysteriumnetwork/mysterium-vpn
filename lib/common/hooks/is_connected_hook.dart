import 'package:mysterium_vpn/common/hooks/computed_hook.dart';
import 'package:mysterium_vpn/common/hooks/provider_hook.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

bool useIsConnected() {
  final store = useProvider(vpnStorePOD);
  return useComputed(() => store.isConnected, [store]).value;
}
