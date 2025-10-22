import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:styled_widget/styled_widget.dart';

/// Displays a dialog asking for push notification permissions.
Future<void> showPushNotificationsPermissionDialog(
  BuildContext context, {
  required bool desktopSize,
}) async =>
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => HookBuilder(
        builder: (context) {
          final isDesktop = useResponsiveValue(false, desktop: true);
          return isDesktop ? _DesktopDialog() : _MobileDialog();
        },
      ),
    );

/// -------- Desktop Layout --------
class _DesktopDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      child: Container(
        width: 600,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Palette.purple),
        ),
        child: const Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: _CloseButton(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 120,
              ),
              child: _DialogContent(isMobile: false),
            ),
          ],
        ),
      ),
    );
  }
}

/// -------- Mobile Layout --------
class _MobileDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Dialog.fullscreen(
      backgroundColor: theme.palette.connectionTileBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: const Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: _CloseButton(),
                ),
                _DialogContent(isMobile: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -------- Shared Dialog Content --------
class _DialogContent extends ConsumerWidget {
  const _DialogContent({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);

    Future<void> handleAllow() async {
      await _completePushNotificationsFlow(
        context,
        userPreferencesStore: userPreferencesStore,
        userAllowed: true,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile) const Spacer(),
        Asset.images
            .marketingConsent(context)
            .image(width: 150, height: 150), // Replace with your icon
        Text(
          'Can we notify you?',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "We'll only send important notifications we think you'll want to know about.",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ).padding(bottom: 24, top: 12),

        // Points
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PermissionPoint(text: '• VPN Connection status'),
            _PermissionPoint(text: '• Server maintenance'),
          ],
        ).padding(bottom: 40),

        if (isMobile) const Spacer(),

        Observer(
          builder: (context) {
            // You can show loading if you ever add async update logic
            const futureStatus = FutureStatus.fulfilled;
            if (futureStatus == FutureStatus.pending) {
              return const LoadingIndicator();
            }
            return _Actions(
              onAllowPressed: handleAllow,
              flexDirection: isMobile ? Axis.vertical : Axis.horizontal,
            );
          },
        ),
      ],
    );
  }
}

/// -------- Close Button --------
class _CloseButton extends ConsumerWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleCancel() async {
      if (context.mounted) {
        _completePushNotificationsFlow(
          context,
          userPreferencesStore: ref.read(userPreferencesStorePOD),
          userAllowed: false,
        );
      }
    }

    return SvgIconButton(
      asset: Asset.icons.close2(context),
      onPressed: handleCancel,
      size: 32,
    );
  }
}

/// -------- Text Bullet Point Widget --------
class _PermissionPoint extends StatelessWidget {
  const _PermissionPoint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ).padding(bottom: 4);
}

/// -------- Action Buttons --------
class _Actions extends StatelessWidget {
  const _Actions({
    required this.flexDirection,
    required this.onAllowPressed,
  });

  final VoidCallback? onAllowPressed;
  final Axis flexDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const minButtonSize = Size(164, 48);

    final children = <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: minButtonSize,
          backgroundColor: theme.palette.outlinedButtonBorderColor,
        ),
        onPressed: onAllowPressed,
        child: Text(
          'Allow Notifications',
          style: GoogleFonts.montserrat(
            color: Palette.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ];

    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: flexDirection,
      spacing: 20,
      crossAxisAlignment: switch (flexDirection) {
        Axis.vertical => CrossAxisAlignment.stretch,
        Axis.horizontal => CrossAxisAlignment.center,
      },
      children: [
        ...switch (flexDirection) {
          Axis.vertical => children,
          Axis.horizontal => children.reversed,
        },
      ],
    );
  }
}

/// -------- Handle State Update --------
Future<void> _completePushNotificationsFlow(
  BuildContext context, {
  required UserPreferencesStore userPreferencesStore,
  required bool userAllowed,
}) async {
  await userPreferencesStore.setPushNotificationsShown(userAllowed: userAllowed);

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
