import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsDesktopView extends HookConsumerWidget {
  const SettingsDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('Settings Desktop View'),
    );
  }
}
