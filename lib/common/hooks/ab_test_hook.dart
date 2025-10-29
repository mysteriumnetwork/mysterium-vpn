import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';

String useABTest(String Function(ABTestingStore store) selector) {
  final store = useProvider(abTestingStorePOD);
  final selectorRef = useRef(selector)..value = selector;
  return useComputedValue(() => selectorRef.value(store), [selectorRef]);
}
