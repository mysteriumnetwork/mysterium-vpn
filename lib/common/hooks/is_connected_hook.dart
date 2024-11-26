part of 'hooks.dart';

bool useIsConnected() {
  final store = useProvider(vpnStorePOD);
  return useComputedValue(() => store.isConnected, [store]);
}
