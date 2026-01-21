import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/design_system_theme.dart';
import 'package:mysterium_vpn/common/utils/keys.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showMarketingConsentDialog(BuildContext context) async {
  showModal<void>(
    context,
    builder: (_) => Theme(
      data: DesignSystemTheme.of(context),
      child: const _DialogContent(),
    ),
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
      body: Padding(
        padding: ModalPadding.insets(
          context,
          add: EdgeInsets.symmetric(
            vertical: theme.spacing.xl,
            horizontal: theme.spacing.md,
          ),
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
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              LocaleKeys.marketingConsentPopupDesc.tr(),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ).padding(
              bottom: 40,
              top: 16,
            ),
            const Spacer(),
            Observer(
              builder: (context) {
                final futureStatus = userPreferencesStore.updateMarketingConsentFuture.status;
                if (futureStatus == FutureStatus.pending) {
                  return const LoadingIndicator();
                }
                return Column(
                  children: [
                    ButtonPrimary(
                      key: Keys.marketingConsentAcceptButton,
                      onPressed: () => _updateMarketingConsent(context, consent: true),
                      child: Text(
                        LocaleKeys.signMeUpBtn.tr(),
                      ),
                    ),
                    if (futureStatus == FutureStatus.rejected)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          LocaleKeys.somethingWentWrong.tr(),
                          style: TextStyle(
                            color: theme.palette.textErrorPrimary,
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
        ),
      ),
    );
  }
}

Future<void> _updateMarketingConsent(
  BuildContext context, {
  required bool consent,
}) async {
  await ProviderScope.containerOf(context, listen: false)
      .read(userPreferencesStorePOD)
      .updateMarketingContact(
        consent: consent,
        fromPopup: true,
      );

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
