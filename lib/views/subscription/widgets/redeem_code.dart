import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ReedemCode extends ConsumerWidget {
  const ReedemCode({
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    return Observer(
      builder: (context) {
        final hideReedemCode = remoteConfig.hideReedemCode;
        return Visibility(
          visible: Platform.isIOS && !isLoading && !hideReedemCode,
          child: TextButton(
            onPressed: onPressed,
            child: EasyText(
              LocaleKeys.redeemCode.tr(),
              color: Palette.purple,
            ),
          ),
        );
      },
    );
  }
}
