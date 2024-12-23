import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationsSearch extends HookConsumerWidget {
  const LocationsSearch({
    required this.onChanged,
    super.key,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final theme = Theme.of(context);
    final brightness = useScaffoldBrightness();
    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    );

    void handleSearch() {
      onChanged(controller.text);
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      autocorrect: false,
      style: TextStyle(
        color: switch (brightness) {
          Brightness.light => Palette.black,
          Brightness.dark => Palette.lightGrey,
        },
      ),
      decoration: InputDecoration(
        filled: true,
        constraints: const BoxConstraints(minHeight: 40),
        contentPadding: const EdgeInsets.only(left: 20),
        fillColor: theme.colorScheme.surface,
        hintText: LocaleKeys.searchForLocations.tr(),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        suffixIcon: SvgIconButton(asset: Assets.search, onPressed: handleSearch).width(20),
      ),
    );
  }
}
