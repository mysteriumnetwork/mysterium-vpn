import 'package:mysterium_vpn/common/hooks/provider_hook.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

bool useSubscriptionActive() =>
    useProvider(subscriptionStorePOD.select((it) => it.subscription?.active ?? false));
