import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> shownInfoDialog(
  BuildContext context,
  String title, {
  required bool isDismissible,
  List<String>? messages,
  AsyncCallback? onConfirm,
  String? confirmText,
}) async {
  await showBottomSheetDialog<void>(
    context,
    allowDismiss: isDismissible,
    builder: (context) => _InfoDialog(
      title: title,
      messages: messages,
      onConfirm: onConfirm,
      confirmText: confirmText,
      isDismissible: isDismissible,
    ),
  );
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({
    required this.title,
    required this.isDismissible,
    this.messages,
    this.onConfirm,
    this.confirmText,
  });

  final String title;
  final bool isDismissible;
  final List<String>? messages;
  final AsyncCallback? onConfirm;
  final String? confirmText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: isDesktop ? theme.spacing.xl3 : theme.spacing.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyles.textLg.bold.copyWith(color: palette.textPrimary),
          ),
        ),
        if (messages != null && messages!.isNotEmpty) ...[
          SizedBox(height: theme.spacing.md),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
            child: Column(
              children: [
                for (final message in messages!)
                  Padding(
                    padding: EdgeInsets.only(bottom: theme.spacing.xs),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyles.textSm.medium.copyWith(
                        color: palette.textTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        SizedBox(height: theme.spacing.xl2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
          child: SizedBox(
            child: ButtonPrimary(
              onPressed: onConfirm ?? () => Beamer.of(context).popRoute(),
              child: Text(confirmText ?? LocaleKeys.continueBtn.tr()),
            ),
          ),
        ),
        SizedBox(height: isDesktop ? theme.spacing.xl2 : theme.spacing.md),
        if (!isDesktop) const SafeArea(top: false, child: SizedBox.shrink()),
      ],
    );

    final body = isDesktop
        ? ClipRRect(
            borderRadius: BorderRadius.all(theme.radius.xl),
            child: ColoredBox(
              color: palette.bgPrimary,
              child: Stack(
                children: [
                  content,
                  if (isDismissible)
                    Positioned(
                      top: theme.spacing.s,
                      right: theme.spacing.s,
                      child: IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(UntitledUI.x_close),
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ),
          )
        : ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.kXl),
            child: ColoredBox(color: palette.bgPrimary, child: content),
          );

    return body;
  }
}
