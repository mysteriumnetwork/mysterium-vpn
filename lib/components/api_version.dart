import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ApiVersion extends HookConsumerWidget {
  const ApiVersion({super.key, this.headerText});
  final String? headerText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiStore = ref.read(apiStorePOD);
    useAutorun(apiStore.initStore);

    return Observer(
      builder: (context) {
        if (apiStore.lastHealthcheck == null) {
          return const SizedBox.shrink();
        }

        if (headerText != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EasyText(headerText!, color: Palette.lightBlack, fontSize: 10).padding(bottom: 6),
              EasyText(apiStore.lastHealthcheck!.version, color: Palette.lightBlack, fontSize: 6),
            ],
          ).padding(top: 20);
        }

        return EasyText(
          'v.${apiStore.lastHealthcheck!.version}',
          color: context.c.isDarkMode ? Palette.lightBlue : Palette.white,
          fontSize: 8,
        ).padding(left: 8);
      },
    );
  }
}
