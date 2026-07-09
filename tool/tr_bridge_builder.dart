import 'dart:convert';

import 'package:build/build.dart';

import 'tr_bridge_generator.dart';

/// build_runner factory (registered in build.yaml). Used by `make generate` /
/// `dart run build_runner build`; `make localizely-generate` uses the standalone
/// `tr_bridge_generator.dart` instead. Both share [renderTrBridge].
Builder trBridgeBuilder(BuilderOptions options) => _TrBridgeBuilder();

class _TrBridgeBuilder implements Builder {
  static const _output = 'lib/l10n/tr_bridge_keys.g.dart';

  @override
  Map<String, List<String>> get buildExtensions => const {
    '^lib/l10n/intl_en.arb': [_output],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final arb = jsonDecode(await buildStep.readAsString(buildStep.inputId)) as Map<String, dynamic>;
    await buildStep.writeAsString(AssetId(buildStep.inputId.package, _output), renderTrBridge(arb));
  }
}
