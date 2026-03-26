part of 'hooks.dart';

bool useIsConnected() {
  final store = useProvider<VpnStore>(vpnStorePOD);
  return useComputedValue(() => store.isConnected, [store]);
}

bool? useIsLocationConnected([VPNLocation? location]) {
  final store = useProvider<VpnStore>(vpnStorePOD);

  return useComputedValue(() {
    // Special case, when no location is used
    if (location == null) {
      if (store.isLoading) {
        return null;
      }
      return store.isConnected;
    }

    if (store.isLoading && (location == store.location || location == store.connectingLocation)) {
      return null;
    }

    if (!store.isConnected) {
      return false;
    }

    return location == store.location;
  }, [location, store]);
}
