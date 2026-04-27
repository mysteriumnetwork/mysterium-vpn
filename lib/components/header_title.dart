import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({required this.text, super.key, this.color});

  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textStyles.textLg.regular.copyWith(fontSize: 20, color: color),
    ).fittedBox().padding(vertical: getMediaHeight(context) * .025);
  }
}
