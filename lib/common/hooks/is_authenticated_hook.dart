import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

bool useIsAuthenticated() {
  final store = useProvider(authSessionStorePOD);
  return useComputedValue(() => store.status == AuthStatus.authenticated);
}
