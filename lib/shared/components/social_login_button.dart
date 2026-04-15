// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/loading_indicator.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

const _appleIconSizeScale = 28 / 44;

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.asset,
    required this.isLoading,
    required this.onPressed,
    this.height = 44,
    super.key,
    this.width,
  });

  final String label;
  final SvgGenImage asset;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fontSize = height * 0.43;
    final themeStore = getIt<ThemeStore>();

    return Observer(
      builder: (context) {
        final isDarkMode = themeStore.isDarkMode;
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          color: Palette.white,
          child: Container(
            decoration: BoxDecoration(
              border: isDarkMode ? null : Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 44,
            child: SizedBox(
              width: double.infinity,
              child: isLoading
                  ? const LoadingIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialLoginIcon(asset: asset, height: height, iconSize: fontSize),
                        Flexible(
                          child: EasyText(
                            label,
                            color: Colors.black,
                            fontSize: fontSize,
                            letterSpacing: -0.41,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ).width(width ?? double.infinity).height(height);
      },
    );
  }
}

class _SocialLoginIcon extends StatelessWidget {
  const _SocialLoginIcon({required this.asset, required this.height, required this.iconSize});

  final SvgGenImage asset;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) =>
      SvgIcon(asset: asset, width: iconSize * (25 / 31), height: iconSize)
          .paddingDirectional(bottom: (4 / height) * height, end: 4)
          .width(_appleIconSizeScale * height)
          .height(height * _appleIconSizeScale + 2);
}
