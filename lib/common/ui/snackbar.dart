import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// Local messengers registered by open modals, most recent last. Snackbars go
// to the top-most mounted one so they render above the modal, not behind it.
final List<GlobalKey<ScaffoldMessengerState>> _localMessengers = [];

/// Wrap a modal's content in this to make [showSnackbar] target the modal
/// instead of the root messenger while the modal is open:
///
/// ```dart
/// showModal(context, builder: (_) => const ModalMessengerScope(child: MyDialog()));
/// ```
class ModalMessengerScope extends StatefulWidget {
  const ModalMessengerScope({required this.child, super.key});

  final Widget child;

  @override
  State<ModalMessengerScope> createState() => _ModalMessengerScopeState();
}

class _ModalMessengerScopeState extends State<ModalMessengerScope> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _localMessengers.add(_messengerKey);
  }

  @override
  void dispose() {
    _localMessengers.remove(_messengerKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(key: _messengerKey, child: widget.child);
}

ScaffoldMessengerState? _targetMessenger() {
  for (final key in _localMessengers.reversed) {
    final state = key.currentState;
    if (state != null) {
      return state;
    }
  }
  return snackbarKey.currentState;
}

/// Shows on the top-most open modal wrapped in a [ModalMessengerScope],
/// otherwise on the app-root messenger.
void showSnackbar(String message, {SnackbarType type = SnackbarType.error, Widget? action}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    duration: action != null ? const Duration(seconds: 10) : const Duration(seconds: 4),
    content: Snackbar(message: message, type: type, action: action),
  );

  _targetMessenger()
    ?..clearSnackBars()
    ..showSnackBar(snackBar);
}

void showError(Object? error) {
  showSnackbar(error?.toString() ?? S.current.somethingWentWrong);
}
