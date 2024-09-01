import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/rest_store.dart';
import 'package:styled_widget/styled_widget.dart';

class NotificationsForm extends HookConsumerWidget {
  const NotificationsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(restApiStorePOD);
    final height = getMediaHeight(context);

    return Column(
      children: [
        HeaderTitle(
          text: LocaleKeys.almostThere.tr(),
        ).padding(bottom: height * 0.02),
        const SvgIcon(
          asset: Assets.notifications,
        ).padding(bottom: height * 0.03),
        EasyText(
          LocaleKeys.dontMissOut.tr(),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ).padding(bottom: height * 0.05),
        Column(
          children: [
            _BulletItem(text: LocaleKeys.productUpdates.tr()),
            _BulletItem(text: LocaleKeys.newServers.tr()),
            _BulletItem(text: LocaleKeys.getTips.tr()),
            _BulletItem(text: LocaleKeys.monitorStatus.tr()),
          ],
        ).padding(bottom: height * 0.03),
        Observer(
          builder: (context) {
            final status = store.setNotificationsApprovalFuture.status;

            return Column(
              children: [
                EasyButton(
                  useSystemColor: false,
                  color: Palette.purple,
                  width: 250,
                  onPressed: status != FutureStatus.pending
                      ? () async {
                          setNotificationApproval(
                            store: store,
                            status: true,
                            context: context,
                          );
                        }
                      : null,
                  child: status != FutureStatus.pending
                      ? EasyText(
                          LocaleKeys.turnOnNotificationsBtn.tr(),
                          color: Palette.white,
                        )
                      : const LoadingIndicator(
                          radius: 20,
                          strokeWidth: 1.5,
                        ),
                ).padding(bottom: height * 0.01),
                if (status != FutureStatus.pending)
                  TextButton(
                    child: EasyText(LocaleKeys.maybeLaterBtn.tr()),
                    onPressed: () {
                      setNotificationApproval(
                        store: store,
                        status: false,
                        context: context,
                      );
                    },
                  ),
              ],
            ).padding(bottom: 50);
          },
        ),
      ],
    ).scrollable().padding(horizontal: 20);
  }

  Future<void> setNotificationApproval({
    required bool status,
    required RestStore store,
    required BuildContext context,
  }) async {
    await store.setNotificationsApproval(status: status);
    if (context.mounted) {
      context.beamToReplacementNamed(Routes.main.toRoute);
    }
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SvgIcon(
            asset: Assets.checkmark,
          ).paddingDirectional(end: 16),
          EasyText(
            text,
            maxLines: 3,
          ).expanded(),
        ],
      ).padding(bottom: 16, horizontal: 20);
}
