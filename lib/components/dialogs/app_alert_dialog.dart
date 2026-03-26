import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

class AppAlertDialog extends HookWidget {
  const AppAlertDialog({
    super.key,
    this.titleText,
    this.title,
    this.content,
    this.actions = const <Widget>[],
    this.scrollable = false,
    this.titlePadding = const EdgeInsets.only(left: 20, right: 20, top: 32, bottom: 20),
  });

  final String? titleText;
  final Widget? title;

  final Widget? content;
  final List<Widget> actions;
  final bool scrollable;
  final EdgeInsets titlePadding;

  @override
  Widget build(BuildContext context) {
    final margin = useResponsiveValue<double>(24, tablet: 32, desktop: 36);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: Padding(
          padding: EdgeInsets.all(margin),
          child: Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return AlertDialog(
                  title:
                      title ??
                      (titleText != null
                          ? Text(
                              titleText!,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            )
                          : null),
                  titleTextStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 20),
                  content: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.palette.alertButtonsOutlineColor),
                      ),
                    ),
                    child: content,
                  ),
                  buttonPadding: EdgeInsets.zero,
                  actionsPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  titlePadding: titlePadding,
                  insetPadding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  scrollable: scrollable,
                  backgroundColor: theme.palette.tileColor,
                  clipBehavior: Clip.antiAlias,
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    for (int i = 0; i < actions.length; i++) ...[
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 64, minWidth: 100),
                        child: actions[i],
                      ),
                      if (i < actions.length - 1)
                        SizedBox(
                          height: 81,
                          child: VerticalDivider(color: theme.palette.alertButtonsOutlineColor),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
