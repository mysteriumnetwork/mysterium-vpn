import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

Future<T?> showModalPage<T>(BuildContext context, {required WidgetBuilder builder}) async {
  final screenType = ScreenType.of(context);
  final palette = Theme.of(context).palette;
  if (screenType > ScreenType.mobile) {
    return showDialog<T>(
      barrierColor: palette.modalBarrierColor,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 630, maxHeight: 650),
            child: builder(context),
          ),
        ),
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    constraints: const BoxConstraints.expand(),
    barrierColor: palette.modalBarrierColor,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(),
    isScrollControlled: true,
    builder: (context) {
      final topInset = MediaQuery.of(context).padding.top;
      final ignoreHeight = topInset + 60.0;
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: ignoreHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(height: ignoreHeight),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ignoreHeight),
            child: builder(context),
          ),
        ],
      );
    },
  );
}

class ModalPageScaffold extends HookWidget {
  const ModalPageScaffold({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    this.header = const _Header(),
    super.key,
  });

  final PreferredSizeWidget? header;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius(context),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.modalGradientColor,
            palette.modalBackgroundColor,
            palette.modalGradientColor,
          ],
        ),
      ),
      child: Scaffold(
        appBar: header,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Padding(padding: padding, child: child),
      ),
    );
  }

  static BorderRadius borderRadius(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenType = getScreenType(size);
    return switch (screenType) {
      ScreenType.mobile => const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      _ => BorderRadius.circular(24),
    };
  }
}

class _Header extends StatelessWidget implements PreferredSizeWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: Asset.icons.close3(context).svg(width: 24, height: 24),
      ),
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
