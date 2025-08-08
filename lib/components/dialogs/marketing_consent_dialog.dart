import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showMarketingConsentDialog(
  BuildContext context, {
  required bool desktopSize,
}) async {
  if (desktopSize) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DesktopDialog(),
    );
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _MobileDialog(),
  );
}

class _DesktopDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          width: 600,
          height: 400,
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 120,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Palette.purple,
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: const _DialogContent(
            isMobile: false,
          ),
        ),
      );
}

class _MobileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Dialog.fullscreen(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: _DialogContent(
            isMobile: true,
          ),
        ),
      );
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent({required this.isMobile});
  final bool isMobile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isMobile) const Spacer(),
        Image(
          width: 150,
          height: 150,
          image: AssetImage(
            context.c.isDarkMode ? Assets.marketingConsentDark : Assets.marketingConsentLight,
          ),
        ),
        Text(
          LocaleKeys.marketingConsentPopupTitle.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          LocaleKeys.marketingConsentPopupDesc.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ).padding(
          bottom: 40,
          top: 16,
        ),
        if (isMobile) const Spacer(),
        Observer(
          builder: (context) {
            final futureStatus = userPreferencesStore.updateMarketingConsentFuture.status;
            if (futureStatus == FutureStatus.pending) {
              return const LoadingIndicator();
            }
            return Column(
              children: [
                if (isMobile) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => _updateMarketingConsent(
                      userPreferencesStore,
                      context,
                      consent: true,
                    ),
                    child: Text(
                      LocaleKeys.signMeUpBtn.tr(),
                      style: const TextStyle(
                        color: Palette.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ).width(double.infinity).height(40),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => _updateMarketingConsent(
                      userPreferencesStore,
                      context,
                      consent: false,
                    ),
                    child: Text(LocaleKeys.noThanksBtn.tr()),
                  ).width(double.infinity).height(40),
                ] else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () => _updateMarketingConsent(
                          userPreferencesStore,
                          context,
                          consent: false,
                        ),
                        child: Text(LocaleKeys.noThanksBtn.tr()),
                      ).width(158).height(40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => _updateMarketingConsent(
                          userPreferencesStore,
                          context,
                          consent: true,
                        ),
                        child: Text(
                          LocaleKeys.signMeUpBtn.tr(),
                          style: const TextStyle(
                            color: Palette.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ).width(158).height(40),
                    ],
                  ),
                if (futureStatus == FutureStatus.rejected)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      LocaleKeys.somethingWentWrong.tr(),
                      style: const TextStyle(
                        color: Palette.crimsonRed,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _updateMarketingConsent(
    UserPreferencesStore userPreferencesStore,
    BuildContext context, {
    required bool consent,
  }) async {
    await userPreferencesStore.updateMarketingContact(consent: consent, fromPopup: true);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
