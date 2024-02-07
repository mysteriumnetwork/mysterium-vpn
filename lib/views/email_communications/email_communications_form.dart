import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/forms/forms.dart';
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
import 'package:reactive_forms/reactive_forms.dart';
import 'package:styled_widget/styled_widget.dart';

class EmailCommunicationsForm extends HookConsumerWidget {
  const EmailCommunicationsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(restApiStorePOD);
    final form = useMemoized(approval);
    final height = getMediaHeight(context);

    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          HeaderTitle(
            text: LocaleKeys.emailCommunications.tr(),
          ),
          const SvgIcon(
            asset: Assets.checkEmail,
          ).padding(bottom: height * 0.03),
          EasyText(
            LocaleKeys.emailCommunicationDesc1.tr(),
            maxLines: 3,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
          ).padding(bottom: height * 0.02),
          EasyText(
            LocaleKeys.emailCommunicationDesc2.tr(),
            maxLines: 3,
            textAlign: TextAlign.center,
          ).padding(bottom: height * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReactiveCheckbox(
                formControlName: 'approval',
              ),
              EasyText(
                LocaleKeys.emaillCommunicationsApproval.tr(),
                fontWeight: FontWeight.w700,
              ).fittedBox().expanded(),
            ],
          ).padding(bottom: height * 0.04),
          Visibility(
            visible: false,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                    ),
                children: [
                  TextSpan(text: '${LocaleKeys.questions.tr()} ${LocaleKeys.tap.tr()}'),
                  TextSpan(
                    text: LocaleKeys.here.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.pink,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                    mouseCursor: MaterialStateMouseCursor.clickable,
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(text: LocaleKeys.moreInfo.tr()),
                ],
              ),
            ).padding(bottom: height * 0.06),
          ),
          Observer(
            builder: (context) {
              final status = store.setEmailCommunicationApprovalFuture.status;

              return ReactiveFormConsumer(
                builder: (context, form, child) => EasyButton(
                  useSystemColor: false,
                  color: Palette.purple,
                  width: 250,
                  onPressed: status != FutureStatus.pending
                      ? () async {
                          final status = form.control('approval').value as bool;
                          await store.setEmailCommunicationApproval(status: status);
                          if (context.mounted) {
                            context.beamToNamed(Routes.notifications.toRoute);
                          }
                        }
                      : null,
                  child: status != FutureStatus.pending
                      ? EasyText(
                          LocaleKeys.nextBtn.tr(),
                          color: Palette.white,
                        )
                      : const LoadingIndicator(
                          radius: 20,
                          strokeWidth: 1.5,
                        ),
                ),
              ).padding(bottom: 50);
            },
          ),
        ],
      ).scrollable().padding(horizontal: 20),
    );
  }
}
