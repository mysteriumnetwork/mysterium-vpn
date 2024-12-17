part of 'hooks.dart';

Future<void> Function({String? location, bool isRetrying}) useHandleToggleConnection() {
  final context = useContext();
  final handleSubscribe = useHandleSubscribe();
  final handleSetupTunnel = useHandleSetupTunnel();

  return useCallback(
    ({String? location, bool isRetrying = false}) async {
      final ref = ProviderScope.containerOf(context, listen: false);
      final vpnStore = ref.read(vpnStorePOD);

      try {
        await vpnStore.toggleConnection(location: location, isRetrying: isRetrying);
      } on SubscriptionRequiredException catch (_) {
        handleSubscribe();
      } on TunnelSetupnRequiredException catch (_) {
        handleSetupTunnel(location);
      }
    },
    [handleSubscribe],
  );
}
