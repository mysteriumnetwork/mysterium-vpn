import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/notifications/notifications_form.dart';

class NotificationsMobileView extends HookConsumerWidget {
  const NotificationsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiStore = ref.watch(restApiStorePOD);

    return BaseLayout(
      header: const BaseAppBar(),
      child: Observer(
        builder: (context) {
          final status = apiStore.notificationsApprovalFuture?.status;

          if (status == FutureStatus.pending) {
            return LoadingIndicator(
              message: LocaleKeys.checkingNotificationsApproval.tr(),
            );
          } else if (status == FutureStatus.rejected) {
            return RetryOnErrorWidget(
              error: LocaleKeys.emailIsRequired.tr(),
              onRetry: apiStore.checkNotificationsApproval,
            );
          }
          return const NotificationsForm();
        },
      ),
    );
  }
}
