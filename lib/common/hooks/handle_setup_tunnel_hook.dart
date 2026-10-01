part of 'hooks.dart';

Future<bool> Function() useHandleSetupTunnel() {
  final context = useContext();

  final vpnStore = useProvider<VpnStore>(vpnStorePOD);

  return useCallback(() async {
    vpnStore.onTunnelPermissionDialogShown();
    final permissionsGranted = await showRequestTunnelPermissionsDialog(context);
    final accepted = permissionsGranted ?? false;
    vpnStore.onTunnelPermissionDecision(accepted: accepted);
    if (accepted) {
      await vpnStore.setupTunnel(trigger: tunnelSetupTriggerPermissionFlow);
      return true;
    }
    return false;
  }, [vpnStore]);
}
