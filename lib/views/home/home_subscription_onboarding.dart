import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';
import 'package:showcaseview/showcaseview.dart';

final _tooltipContents = [
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip1Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip1Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip2Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip2Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip3Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip3Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip4Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip4Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip5Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip5Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
  TooltipContent(
    title: LocaleKeys.subscriptionOnboardingTooltip6Title.tr(),
    description: LocaleKeys.subscriptionOnboardingTooltip6Description.tr(),
    onActionPressed: () => ShowcaseView.get().next(),
  ),
];

(List<TooltipContent>, List<GlobalKey<State<StatefulWidget>>>) useSubscriptionOnboarding({
  required int keysCount,
}) {
  final globalKeys = useMemoized(
    () => List.generate(keysCount, (index) => GlobalKey<State<StatefulWidget>>()),
  );

  useEffect(() {
    ShowcaseView.register(
      globalFloatingActionWidget: (context) => FloatingActionWidget(
        top: 50,
        right: 50,
        child: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Palette.white),
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
          ),
          icon: Row(
            children: [
              Text(
                'Skip',
                style: TextStyle(
                  color: Palette.grayDark.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.close, color: Palette.grayDark.shade700, size: 20),
            ],
          ),
          onPressed: () => ShowcaseView.get().dismiss(),
        ),
      ),
    );

    // TODO: Testing delete after
    Future.microtask(() async {
      await Future.delayed(const Duration(seconds: 3));
      ShowcaseView.get().startShowCase(globalKeys);
    });

    return ShowcaseView.get().unregister;
  }, []);

  return (_tooltipContents, globalKeys);
}
