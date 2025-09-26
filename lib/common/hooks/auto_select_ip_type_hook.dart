import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useAutoSelectIPType() {
  final vpnStore = useProvider(vpnStorePOD);
  final locationsQueryStore = useProvider(locationsQueryStorePOD);

  useReaction(
    () => vpnStore.location?.ipType,
    (ipType) {
      if (ipType == null || ipType == IPType.closest) {
        return;
      }

      locationsQueryStore.setIPType(ipType);
    },
    fireImmediately: true,
    keys: [locationsQueryStore, vpnStore],
  );
}
