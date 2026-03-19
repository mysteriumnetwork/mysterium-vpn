import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

/// Computes the effective priority country code from selected, connecting,
/// and connected locations. Sticky: remembers the last non-null value so
/// the list stays scrolled when the selection clears.
String? useEffectivePriorityCountryCode(WidgetRef ref) {
  final selectedLocationStore = ref.watch(selectedLocationStorePOD);
  final vpnStore = ref.watch(vpnStorePOD);

  final selectedLocation = useComputedValue(() => selectedLocationStore.value);
  final connectingLocation = useComputedValue(() => vpnStore.connectingLocation);
  final connectedLocation = useComputedValue(
    () => vpnStore.isConnected ? vpnStore.location : null,
  );

  final priorityCountryCode = selectedLocation?.countryCode ??
      connectingLocation?.countryCode ??
      connectedLocation?.countryCode;

  final lastPriorityRef = useRef<String?>(priorityCountryCode);
  if (priorityCountryCode != null) {
    lastPriorityRef.value = priorityCountryCode;
  }

  return priorityCountryCode ?? lastPriorityRef.value;
}
