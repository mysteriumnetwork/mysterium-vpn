import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Centered error state: a circular error-badge [icon], a [title], a [message],
/// and a [ButtonSecondary] retry (full-width on mobile). Shared by the
/// locations "no servers" state and the News Center error state.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.icon = UntitledUI.alert_circle,
    this.loading = false,
    super.key,
  });

  /// Bold headline under the icon.
  final String title;

  /// Secondary explanatory line under the title.
  final String message;

  /// Label of the retry button.
  final String retryLabel;

  /// Called when retry is pressed.
  final VoidCallback onRetry;

  /// Error glyph shown in the badge.
  final IconData icon;

  /// Whether the retry button shows a loading spinner (e.g. a refresh in flight).
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIcon(
            icon: icon,
            decoration: IconDecoration(
              iconSize: 32,
              iconColor: palette.iconErrorPrimary,
              backgroundColor: palette.bgError,
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          SizedBox(height: theme.spacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
          ),
          SizedBox(height: theme.spacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
          ),
          SizedBox(height: theme.spacing.xl),
          SizedBox(
            width: isDesktop ? null : double.infinity,
            child: ButtonSecondary(
              loading: loading ? const ButtonLoading() : null,
              onPressed: onRetry,
              child: Text(retryLabel),
            ),
          ),
        ],
      ),
    );
  }
}
