part of 'hooks.dart';

Future<bool> Function() useHandleSetupTunnel() {
  final context = useContext();

  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final analyticsStore = useProvider<AnalyticsStore>(analyticsStorePOD);

  return useCallback(() async {
    analyticsStore.logTunnelPermissionDialogShown().ignore();
    final permissionsGranted = await showRequestTunnelPermissionsDialog(context);
    final accepted = permissionsGranted ?? false;
    analyticsStore.logTunnelPermissionDecision(accepted: accepted).ignore();
    if (accepted) {
      await vpnStore.setupTunnel();
      return true;
    }
    return false;
  }, [vpnStore, analyticsStore]);
}
