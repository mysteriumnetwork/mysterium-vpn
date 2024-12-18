part of 'hooks.dart';

Future<void> Function({String? location}) useHandleToggleConnection() {
  final context = useContext();
  final handleSubscribe = useHandleSubscribe();
  final handleSetupTunnel = useHandleSetupTunnel();

  return useCallback(
    ({String? location}) async {
      final ref = ProviderScope.containerOf(context, listen: false);
      final vpnStore = ref.read(vpnStorePOD);

      try {
        await vpnStore.toggleConnection(location: location);
      } on SubscriptionRequiredException catch (_) {
        handleSubscribe();
      } on TunnelSetupnRequiredException catch (_) {
        final permissionsGiven = await handleSetupTunnel();
        if (permissionsGiven) {
          await vpnStore.toggleConnection(location: location);
        }
      }
    },
    [handleSubscribe, handleSetupTunnel],
  );
}
