part of 'hooks.dart';

Future<void> Function(String? location) useHandleSetupTunnel() {
  final context = useContext();

  final abTestingStore = useProvider(abTestingStorePOD);
  final vpnStore = useProvider(vpnStorePOD);
  final tunnelConsentType = useComputedValue(
    () => abTestingStore.tunnelConsentType,
    [abTestingStore],
  );

  return useCallback((String? location) async {
    final permissionsGranted =
        await shownRequestTunnelPermissionsDialog(context, tunnelConsentType);
    if (permissionsGranted ?? false) {
      vpnStore.setupTunnel(location);
    }
  });
}
