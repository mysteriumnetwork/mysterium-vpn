import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/modal_page_scaffold.dart';

Future<void> showUpgradePage(BuildContext context) async {
  await showModalPage(
    context,
    builder: (_) => _Page(),
  );
}

class _Page extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => const ModalPageScaffold(
        child: Text('Upgrade Page Content'),
      );
}
