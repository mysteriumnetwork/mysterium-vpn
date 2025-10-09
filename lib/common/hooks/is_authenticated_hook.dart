import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';

bool useIsAuthenticated() {
  final store = useProvider(authSessionStorePOD);
  return useComputedValue(() => store.status == AuthStatus.authenticated);
}
