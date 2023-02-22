import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class ProtocolPicker extends StatelessWidget {
  const ProtocolPicker({
    required this.store,
    super.key,
  });

  final VpnStore store;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => DropdownButton<String>(
          isExpanded: true,
          value: store.protocol,
          underline: const SizedBox.shrink(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? newProtocol) async {
            if (newProtocol == null) {
              return;
            }
            store.changeProtocol(newProtocol);
            return;
          },
          items: protocols
              .map<DropdownMenuItem<String>>(
                (protocol) => DropdownMenuItem<String>(
                  value: protocol,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: EasyText(protocol),
                  ),
                ),
              )
              .toList(),
        ).padding(horizontal: 10).decorated(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
      );
}
