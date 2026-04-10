import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';

String useABTest(String Function(ABTestingStore store) selector) {
  final store = useProvider<ABTestingStore>(abTestingStorePOD);
  final selectorRef = useRef(selector)..value = selector;
  return useComputedValue(() => selectorRef.value(store), [selectorRef]);
}
