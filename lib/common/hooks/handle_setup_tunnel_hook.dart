part of 'hooks.dart';

Future<bool> Function() useHandleSetupTunnel() {
  final context = useContext();

  final vpnStore = useProvider<VpnStore>(vpnStorePOD);

  return useCallback(() async {
    final permissionsGranted = await showRequestTunnelPermissionsDialog(context);
    if (permissionsGranted ?? false) {
      await vpnStore.setupTunnel();
      return true;
    }
    return false;
  }, [vpnStore]);
}
