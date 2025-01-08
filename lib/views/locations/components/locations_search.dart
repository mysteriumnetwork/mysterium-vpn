import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
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

    final onChangedRef = useRef(onChanged)..value = onChanged;

    useEffect(
      () {
        void listener() {
          onChangedRef.value(controller.text);
        }

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [controller, onChangedRef],
    );

    return TextField(
      controller: controller,
      autocorrect: false,
      onTapOutside: (_) => FocusScope.of(
        context,
        createDependency: false,
      ).unfocus(),
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
        suffixIcon: _Button(controller: controller).width(20),
      ),
    );
  }
}

class _Button extends HookWidget {
  const _Button({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final canClear = useListenableSelector(controller, () => controller.text.isNotEmpty);
    if (!canClear) {
      return const SvgIcon(asset: Assets.search, width: 11);
    }

    void handleClear() {
      controller
        ..clear()
        ..text = '';
      FocusScope.of(context, createDependency: false).unfocus();
    }

    return SvgIconButton(
      onPressed: handleClear,
      asset: Assets.clear,
    );
  }
}
