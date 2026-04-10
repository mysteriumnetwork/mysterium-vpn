import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useAutoSelectIPType() {
  final context = useContext();
  useEffect(() {
    final ref = ProviderScope.containerOf(context, listen: false);
    final vpnStore = ref.read(vpnStorePOD);
    final locationsStore = ref.read(locationsStorePOD);

    final disposer = reaction(
      (_) => (vpnStore.location?.id, vpnStore.location?.ipType, locationsStore.locationTypes),
      (data) {
        final (location, ipType, availableTypes) = data;

        if ((location != null && ipType == null) || ipType == IPType.closest) {
          return;
        }

        final previous = ref.read(locationsQueryStorePOD).ipType;
        final selected = availableTypes.contains(ipType)
            ? ipType
            : availableTypes.contains(previous)
            ? previous
            : availableTypes.firstOrNull;

        if (selected == null) {
          return;
        }

        ref.read(locationsQueryStorePOD).setIPType(selected);
      },
      fireImmediately: true,
    );

    return disposer.call;
  }, []);
}
