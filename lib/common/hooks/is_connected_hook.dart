part of 'hooks.dart';

bool useIsConnected() {
  final store = useProvider(vpnStorePOD);
  return useComputedValue(() => store.isConnected, [store]);
}

bool? useIsLocationConnected([VPNLocation? location]) {
  final store = useProvider(vpnStorePOD);
  return useComputedValue(
    () {
      if (store.isLoading && (location == store.location || location == store.connectingLocation)) {
        return null;
      }

      if (!store.isConnected) {
        return false;
      }

      return location == store.location;
    },
    [location, store],
  );
}

bool? useIsConnectedOrConnecting() {
  final store = useProvider(vpnStorePOD);
  return useComputedValue(
    () {
      if (store.isLoading) {
        return null;
      }

      return store.isConnected;
    },
    [store],
  );
}
