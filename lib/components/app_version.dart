import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:styled_widget/styled_widget.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key, this.headerText});
  final String? headerText;

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    // ignore: discarded_futures
    future: PackageInfo.fromPlatform(),
    builder: (context, snapshot) => snapshot.hasData
        ? headerText != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EasyText(
                      headerText!,
                      color: Palette.lightBlack,
                      fontSize: 10,
                    ).padding(bottom: 6),
                    EasyText('${snapshot.data?.version}', color: Palette.lightBlack, fontSize: 6),
                  ],
                ).padding(top: 20)
              : EasyText(
                  'v.${snapshot.data?.version}',
                  color: context.c.isDarkMode ? Palette.lightBlue : Palette.white,
                  fontSize: 8,
                )
        : const SizedBox.shrink(),
  );
}
