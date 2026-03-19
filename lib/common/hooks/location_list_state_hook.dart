import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationListState {
  const LocationListState({
    required this.userExpanded,
    required this.userCollapsed,
    required this.effectivePriorityCountryCode,
  });

  final ValueNotifier<Set<String>> userExpanded;
  final ValueNotifier<Set<String>> userCollapsed;
  final String? effectivePriorityCountryCode;
}

/// Shared hook that computes the priority country code and manages
/// expansion/collapse state for location lists.
LocationListState useLocationListState(WidgetRef ref) {
  final selectedLocationStore = ref.watch(selectedLocationStorePOD);
  final vpnStore = ref.watch(vpnStorePOD);

  final userExpanded = useMemoized(() => ValueNotifier<Set<String>>({}));
  final userCollapsed = useMemoized(() => ValueNotifier<Set<String>>({}));
  useEffect(
    () => () {
      userExpanded.dispose();
      userCollapsed.dispose();
    },
    const [],
  );

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
  final effectivePriorityCountryCode = priorityCountryCode ?? lastPriorityRef.value;

  return LocationListState(
    userExpanded: userExpanded,
    userCollapsed: userCollapsed,
    effectivePriorityCountryCode: effectivePriorityCountryCode,
  );
}
