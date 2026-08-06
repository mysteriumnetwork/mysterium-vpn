part of 'hooks.dart';

Future<void> Function({
  VPNLocation? location,
  UserIntent? intent,
  AnalyticsEventSelector? selectEvent,
  String? targetIp,
})
useHandleToggleConnection() {
  final context = useContext();
  final handleSubscribe = useHandleSubscribe();
  final handleSetupTunnel = useHandleSetupTunnel();

  return useCallback(({
    VPNLocation? location,
    UserIntent? intent,
    AnalyticsEventSelector? selectEvent,
    String? targetIp,
  }) async {
    final ref = ProviderScope.containerOf(context, listen: false);
    final vpnStore = ref.read(vpnStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    final logEvent = vpnStore.isConnected
        ? analyticsStore.logDisconnect
        : analyticsStore.logConnect;
    logEvent(location, event: selectEvent?.call(vpnStore.isConnected), intent: intent);

    try {
      await vpnStore.manageConnection(location: location, intent: intent, targetIp: targetIp);
    } on AuthenticationRequiredException catch (_) {
      if (context.mounted) {
        Beamer.of(context).beamToNamed(Routes.platformLogin.path);
      }
    } on SubscriptionRequiredException catch (_) {
      handleSubscribe();
    } on TunnelSetupRequiredException catch (_) {
      final permissionsGiven = await handleSetupTunnel();
      if (permissionsGiven) {
        await vpnStore.manageConnection(location: location, intent: intent, targetIp: targetIp);
      }
    }
  }, [handleSubscribe, handleSetupTunnel]);
}

// ignore: avoid_positional_boolean_parameters
typedef AnalyticsEventSelector = AnalyticsEvent Function(bool connected);
