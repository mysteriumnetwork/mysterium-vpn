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

  // Active priority: from explicit selection or active connection attempt.
  // Connected location is excluded so that deselecting doesn't immediately
  // switch priority to the connected country (which would collapse the
  // previously expanded item).
  final activePriority = selectedLocation?.countryCode ?? connectingLocation?.countryCode;

  // Sticky: remember last active priority so expansions survive deselect.
  final lastPriorityRef = useRef<String?>(null);
  if (activePriority != null) {
    lastPriorityRef.value = activePriority;
  }

  // Fall back to sticky value, then to connected location.
  return activePriority ?? lastPriorityRef.value ?? connectedLocation?.countryCode;
}
