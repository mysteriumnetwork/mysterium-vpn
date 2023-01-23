import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/language_picker.dart';
import 'package:mysterium_vpn/components/theme_picker.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localStore = ref.watch(localeStorePOD);
    final authStore = ref.watch(authStorePOD);

    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            localStore.loco.title,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LanguagePicker().padding(all: 10),
              const ThemePicker().padding(all: 10),
              EasyButton(
                text: 'Logout',
                onPressed: () {
                  authStore.logout();
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
