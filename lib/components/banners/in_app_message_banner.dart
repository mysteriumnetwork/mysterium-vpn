import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/common/styles/style.dart' hide Palette;
import 'package:mysterium_vpn/models/in_app_message.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/promo_bar.dart';

class InAppMessageBanner extends HookConsumerWidget {
  const InAppMessageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inAppMessagesStore = ref.watch(inAppMessagesStorePOD);
    return Observer(
      builder: (context) {
        final banner = inAppMessagesStore.activeBanner;
        if (banner == null) {
          return const SizedBox.shrink();
        }
        return Theme(
          data: Theme.of(context).designSystem,
          child: _Banner(data: banner),
        );
      },
    );
  }
}

class _Banner extends HookWidget {
  const _Banner({required this.data});

  final InAppBanner data;

  @override
  Widget build(BuildContext context) {
    final icon = useMemoized<Widget?>(
      () {
        if (data.iconUrl == null) {
          return null;
        }
        if (data.iconUrl?.endsWith('svg') ?? false) {
          return SvgPicture.network(
            data.iconUrl!,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(Palette.brand.shade700, BlendMode.srcIn),
          );
        }
        return Image.network(
          data.iconUrl!,
          fit: BoxFit.contain,
          width: 24,
          height: 24,
        );
      },
      [data.iconUrl],
    );

    return PromoBar(
      icon: icon,
      text: data.title,
      onTap: data.action != null ? () => Beamer.of(context).navigateToUrl(data.action!.url) : null,
    );
  }
}
