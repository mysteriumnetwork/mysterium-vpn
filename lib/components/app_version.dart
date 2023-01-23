import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key? key, required this.headerText}) : super(key: key);
  final String headerText;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) => snapshot.hasData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  headerText,
                  color: Palette.lightBlack,
                  fontSize: 10,
                ).padding(bottom: 6),
                EasyText(
                  '${snapshot.data?.version}',
                  color: Palette.lightBlack,
                  fontSize: 6,
                ),
              ],
            ).padding(top: 20)
          : const SizedBox.shrink(),
    );
  }
}
