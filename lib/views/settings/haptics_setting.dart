import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HapticsSetting extends ConsumerWidget {
  const HapticsSetting({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(hapticsStorePOD);

    if (!store.isSupported) {
      return const SizedBox.shrink();
    }

    return Observer(
      builder: (_) => SettingsCard(
        title: S.current.hapticFeedbackSettingLbl,
        subtitle: S.current.hapticFeedbackSettingDesc,
        position: position,
        trailing: Switch(
          value: store.enabled,
          onChanged: (value) => store.setEnabled(value: value),
        ),
      ),
    );
  }
}
