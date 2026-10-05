import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A [PromptDialog] whose two choices run async work before the dialog closes.
///
/// The first press wins: both buttons go inert, only the pressed one spins,
/// the barrier and system Back stop dismissing, and the dialog pops exactly
/// once when the work settles. Keeping this in one widget matters because
/// [Button] scopes its own `loading` [IgnorePointer] to itself — marking just
/// the pressed button leaves its sibling live, which lets a second action fire
/// and a second pop take the route underneath.
///
/// [onShown] fires once the dialog is actually on screen, for best-effort
/// "we asked" bookkeeping: it runs detached, so a slow or failing write can
/// neither delay nor block the prompt.
///
/// [onPrimary] / [onSecondary] own surfacing their own failures; the dialog
/// closes either way.
class AsyncPromptDialog extends HookWidget {
  const AsyncPromptDialog({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    this.onShown,
    this.primaryKey,
    this.secondaryKey,
    super.key,
  });

  final Widget image;
  final String title;
  final String subtitle;

  final String primaryLabel;
  final String secondaryLabel;

  final Future<void> Function() onPrimary;
  final Future<void> Function() onSecondary;

  /// Runs once on mount, detached and with failures suppressed.
  final Future<void> Function()? onShown;

  final Key? primaryKey;
  final Key? secondaryKey;

  @override
  Widget build(BuildContext context) {
    // Null while idle, otherwise which button is running.
    final pending = useState<bool?>(null);

    final onShown = this.onShown;
    useEffect(() {
      if (onShown != null) {
        // Future(...) so a synchronous throw also lands in the ignored future
        // rather than failing this build.
        Future(onShown).ignore();
      }
      return null;
    }, const []);

    Future<void> choose({required bool primary}) async {
      // Covers two presses in the same frame, before the buttons go inert.
      if (pending.value != null) {
        return;
      }
      pending.value = primary;
      try {
        await (primary ? onPrimary() : onSecondary());
      } finally {
        // In a finally so a throwing callback can't wedge the dialog shut with
        // both buttons inert and no way out.
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    final isBusy = pending.value != null;
    return PopScope(
      canPop: !isBusy,
      child: PromptDialog(
        image: image,
        title: title,
        subtitle: subtitle,
        primaryButton: ButtonPrimary(
          key: primaryKey,
          onPressed: isBusy ? null : () => choose(primary: true),
          loading: pending.value == true ? const ButtonLoading() : null,
          child: Text(primaryLabel, textAlign: TextAlign.center),
        ),
        secondaryButton: ButtonSecondary(
          key: secondaryKey,
          onPressed: isBusy ? null : () => choose(primary: false),
          loading: pending.value == false ? const ButtonLoading() : null,
          child: Text(secondaryLabel, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
