import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysterium_vpn/core/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/core/styles/style.dart' hide Palette;
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/home/store/promotional_content_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:mysterium_vpn_design/widgets/promo_bar.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final promotionalContentStore = getIt<PromotionalContentStore>();
    final authSessionStore = getIt<AuthSessionStore>();
    return Observer(
      builder: (context) {
        final banner = promotionalContentStore.activeBanner;
        final isAuthenticated = authSessionStore.isAuthenticated;
        if (banner == null) {
          return const SizedBox.shrink();
        }
        return Theme(
          data: Theme.of(context).designSystem,
          child: _Banner(
            data: banner,
            isAuthenticated: isAuthenticated,
            accessToken: authSessionStore.accessToken,
          ),
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.data, required this.isAuthenticated, required this.accessToken});

  final PromotionalBanner data;
  final bool isAuthenticated;
  final String? accessToken;

  @override
  Widget build(BuildContext context) => PromoBar(
      icon: _buildIcon(data.iconUrl),
      text: data.getLocalizedTitle(context.locale.languageCode),
      onTap: data.redirectUrl != null
          ? () => Beamer.of(context).navigateToUrl(
              url: data.redirectUrl!,
              context: context,
              isAuthenticated: isAuthenticated,
              accessToken: accessToken,
            )
          : null,
    );

  Widget _buildIcon(String? iconUrl) {
    final defaultIcon = Icon(Icons.campaign, size: 24, color: Palette.brand.shade700);

    if (iconUrl == null) {
      return defaultIcon;
    }

    if (iconUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        iconUrl,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(Palette.brand.shade700, BlendMode.srcIn),
        placeholderBuilder: (_) => defaultIcon,
      );
    }

    return Image.network(
      iconUrl,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => defaultIcon,
    );
  }
}
