import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/vpn/store/mqtt_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class ApiVersion extends StatefulWidget {
  const ApiVersion({super.key, this.headerText});
  final String? headerText;

  @override
  State<ApiVersion> createState() => _ApiVersionState();
}

class _ApiVersionState extends State<ApiVersion> {
  final _apiStore = getIt<MqttStore>();

  @override
  void initState() {
    super.initState();
    _apiStore.initStore();
  }

  @override
  Widget build(BuildContext context) => Observer(
      builder: (context) {
        if (_apiStore.lastHealthcheck == null) {
          return const SizedBox.shrink();
        }

        if (widget.headerText != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EasyText(widget.headerText!, color: Palette.lightBlack, fontSize: 10)
                  .padding(bottom: 6),
              EasyText(
                _apiStore.lastHealthcheck!.version,
                color: Palette.lightBlack,
                fontSize: 6,
              ),
            ],
          ).padding(top: 20);
        }

        return EasyText(
          'v.${_apiStore.lastHealthcheck!.version}',
          color: context.c.isDarkMode ? Palette.lightBlue : Palette.white,
          fontSize: 8,
        ).padding(left: 8);
      },
    );
}
