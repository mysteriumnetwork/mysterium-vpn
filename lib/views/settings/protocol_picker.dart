import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/stores.dart';

class ProtocolPicker extends StatelessWidget {
  const ProtocolPicker({
    required this.store,
    super.key,
  });

  final VpnStore store;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => EasyDropdown<String>(
          value: '',
          onChanged: (String? newProtocol) async {
            if (newProtocol == null) {
              return;
            }
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
        ),
      );
}
