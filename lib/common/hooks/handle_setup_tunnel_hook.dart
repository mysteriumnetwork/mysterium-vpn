part of 'hooks.dart';

Future<bool> Function() useHandleSetupTunnel() {
  final context = useContext();

  final abTestingStore = useProvider<ABTestingStore>(abTestingStorePOD);
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final tunnelConsentType = useComputedValue(() => abTestingStore.tunnelConsentType, [
    abTestingStore,
  ]);

  return useCallback(() async {
    final permissionsGranted = await showRequestTunnelPermissionsDialog(context, tunnelConsentType);
    if (permissionsGranted ?? false) {
      await vpnStore.setupTunnel();
      return true;
    }
    return false;
  }, [vpnStore, tunnelConsentType]);
}
