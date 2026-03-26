import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/dialogs/adaptive_action_sheet/cancel_action.dart';
import 'package:mysterium_vpn/components/dialogs/adaptive_action_sheet/sheet_action.dart';

Future<T?> showAdaptiveActionSheet<T>({
  required List<BottomSheetAction> actions,
  required BuildContext context,
  Widget? title,
  CancelAction? cancelAction,
  Color? barrierColor,
  Color? bottomSheetColor,
  double? androidBorderRadius,
  bool isDismissible = true,
}) async {
  assert(barrierColor != Colors.transparent, 'The barrier color cannot be transparent.');

  return _show<T>(
    context,
    title,
    actions,
    cancelAction,
    barrierColor,
    bottomSheetColor,
    androidBorderRadius,
    isDismissible: isDismissible,
  );
}

Future<T?> _show<T>(
  BuildContext context,
  Widget? title,
  List<BottomSheetAction> actions,
  CancelAction? cancelAction,
  Color? barrierColor,
  Color? bottomSheetColor,
  double? androidBorderRadius, {
  bool isDismissible = true,
}) {
  if (Platform.isIOS) {
    return _showCupertinoBottomSheet(
      context,
      title,
      actions,
      cancelAction,
      isDismissible: isDismissible,
    );
  } else {
    return _showMaterialBottomSheet(
      context,
      title,
      actions,
      cancelAction,
      barrierColor,
      bottomSheetColor,
      androidBorderRadius,
      isDismissible: isDismissible,
    );
  }
}

Future<T?> _showCupertinoBottomSheet<T>(
  BuildContext context,
  Widget? title,
  List<BottomSheetAction> actions,
  CancelAction? cancelAction, {
  bool isDismissible = true,
}) => showCupertinoModalPopup(
  context: context,
  barrierDismissible: isDismissible,
  builder: (BuildContext coxt) => CupertinoActionSheet(
    title: title,
    actions: actions
        .map(
          (action) => CupertinoActionSheetAction(
            onPressed: () {
              action.onPressed(coxt);
              Beamer.of(coxt).popRoute();
            },
            child: Text(
              action.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
          ),
        )
        .toList(),
    cancelButton: cancelAction != null
        ? CupertinoActionSheetAction(
            onPressed: () {
              if (cancelAction.onPressed != null) {
                cancelAction.onPressed!(coxt);
              } else {
                Beamer.of(coxt).popRoute();
              }
            },
            child: Text(textAlign: TextAlign.center, cancelAction.title),
          )
        : null,
  ),
);

Future<T?> _showMaterialBottomSheet<T>(
  BuildContext context,
  Widget? title,
  List<BottomSheetAction> actions,
  CancelAction? cancelAction,
  Color? barrierColor,
  Color? bottomSheetColor,
  double? androidBorderRadius, {
  bool isDismissible = true,
}) {
  final sheetTheme = Theme.of(context).bottomSheetTheme;
  return showModalBottomSheet<T>(
    context: context,
    elevation: 0,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,
    backgroundColor:
        bottomSheetColor ?? sheetTheme.modalBackgroundColor ?? sheetTheme.backgroundColor,
    barrierColor: barrierColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(androidBorderRadius ?? 30),
        topRight: Radius.circular(androidBorderRadius ?? 30),
      ),
    ),
    builder: (BuildContext coxt) {
      final screenHeight = MediaQuery.of(context).size.height;
      return PopScope(
        canPop: isDismissible,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: title),
                  ),
                ],
                ...actions.map<Widget>(
                  (action) => InkWell(
                    onTap: () {
                      action.onPressed(coxt);
                      Beamer.of(coxt).popRoute();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        action.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                if (cancelAction != null)
                  InkWell(
                    onTap: () {
                      if (cancelAction.onPressed != null) {
                        cancelAction.onPressed!(coxt);
                      } else {
                        Navigator.of(coxt).pop();
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(cancelAction.title, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
