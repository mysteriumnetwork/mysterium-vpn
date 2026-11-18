import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// [ConnectivityPlatform] fake, so tests touching [Connectivity] do not hit the
/// missing plugin. Install it with [installFakeConnectivity].
class FakeConnectivity extends ConnectivityPlatform with MockPlatformInterfaceMixin {
  FakeConnectivity({this.results = const [ConnectivityResult.wifi]});

  final List<ConnectivityResult> results;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value(results);
}

FakeConnectivity installFakeConnectivity({
  List<ConnectivityResult> results = const [ConnectivityResult.wifi],
}) {
  final fake = FakeConnectivity(results: results);
  ConnectivityPlatform.instance = fake;
  return fake;
}
