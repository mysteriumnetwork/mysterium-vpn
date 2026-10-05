import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/ui/dialog_navigation.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A [PromptDialog] whose two choices run async work before it closes.
///
/// First press wins: both buttons go inert, the pressed one spins, and the
/// dialog pops once — needed because [Button] scopes its `loading`
/// [IgnorePointer] to itself, leaving the sibling live.
///
/// [onShown] runs detached on mount, for best-effort "we asked" bookkeeping.
/// [onPrimary] / [onSecondary] surface their own failures.
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
        // In a finally so a throwing callback can't wedge the dialog shut.
        if (context.mounted) {
          popIfCurrent(context);
        }
      }
    }

    final isBusy = pending.value != null;
    return PopScope(
      canPop: !isBusy,
      child: AbsorbPointer(
        absorbing: isBusy,
        child: PromptDialog(
          image: image,
          title: title,
          subtitle: subtitle,
          primaryButton: ButtonPrimary(
            key: primaryKey,
            onPressed: () => choose(primary: true),
            loading: pending.value == true ? const ButtonLoading() : null,
            child: Text(primaryLabel, textAlign: TextAlign.center),
          ),
          secondaryButton: ButtonSecondary(
            key: secondaryKey,
            onPressed: () => choose(primary: false),
            loading: pending.value == false ? const ButtonLoading() : null,
            child: Text(secondaryLabel, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
