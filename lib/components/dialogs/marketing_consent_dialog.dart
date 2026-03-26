import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showMarketingConsentDialog(BuildContext context) async {
  await showModal<void>(
    context,
    builder: (_) => Theme(data: DesignSystemTheme.of(context), child: const _DialogContent()),
  );
}

class _DialogContent extends ConsumerWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final theme = Theme.of(context);
    return ModalScaffold(
      onModalClose: () => _updateMarketingConsent(context, consent: false),
      autoApplyPadding: false,
      showGradient: false,
      showCloseButton: false,
      body: Padding(
        padding: ModalPadding.insets(
          context,
          add: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        ),
        child: Column(
          key: Keys.marketingConsentDialog,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Asset.images.marketingConsent(context).image(width: 150, height: 150),
            Text(
              LocaleKeys.marketingConsentPopupTitle.tr(),
              style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.marketingConsentPopupDesc.tr(),
              style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ).padding(bottom: 24, top: 12),
            const Spacer(),
            Observer(
              builder: (context) {
                final futureStatus = userPreferencesStore.updateMarketingConsentFuture.status;
                if (futureStatus == FutureStatus.pending) {
                  return const LoadingIndicator();
                }
                return ScreenTypeLayoutBuilder(
                  mobile: (_) => _buildButtonsColumn(context, futureStatus, theme),
                  tablet: (_) => _buildButtonsColumn(context, futureStatus, theme),
                  desktop: (_) => _buildButtonsRow(context, futureStatus, theme),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildButtonsColumn(BuildContext context, FutureStatus futureStatus, ThemeData theme) =>
    Column(
      children: [
        ButtonPrimary(
          key: Keys.marketingConsentAcceptButton,
          onPressed: () => _updateMarketingConsent(context, consent: true),
          child: Text(LocaleKeys.signMeUpBtn.tr()),
        ).width(double.infinity),
        ButtonSecondary(
          key: Keys.marketingConsentDeclineButton,
          onPressed: () => _updateMarketingConsent(context, consent: false),
          child: Text(LocaleKeys.noThanksBtn.tr()),
        ).padding(top: 16).width(double.infinity),
        if (futureStatus == FutureStatus.rejected)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              LocaleKeys.somethingWentWrong.tr(),
              style: TextStyle(color: theme.palette.textErrorPrimary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );

Widget _buildButtonsRow(BuildContext context, FutureStatus futureStatus, ThemeData theme) => Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonSecondary(
          key: Keys.marketingConsentDeclineButton,
          onPressed: () => _updateMarketingConsent(context, consent: false),
          child: Text(LocaleKeys.noThanksBtn.tr()),
        ),
        SizedBox(width: theme.spacing.md),
        ButtonPrimary(
          key: Keys.marketingConsentAcceptButton,
          onPressed: () => _updateMarketingConsent(context, consent: true),
          child: Text(LocaleKeys.signMeUpBtn.tr()),
        ),
      ],
    ),
    if (futureStatus == FutureStatus.rejected)
      Padding(
        padding: EdgeInsets.only(top: theme.spacing.md),
        child: Text(
          LocaleKeys.somethingWentWrong.tr(),
          style: TextStyle(color: theme.palette.textErrorPrimary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
  ],
);

Future<void> _updateMarketingConsent(BuildContext context, {required bool consent}) async {
  await ProviderScope.containerOf(
    context,
    listen: false,
  ).read(userPreferencesStorePOD).updateMarketingContact(consent: consent, fromPopup: true);

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
