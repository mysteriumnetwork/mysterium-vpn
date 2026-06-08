import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/residential_education_modal.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Watches for a user-initiated residential connection and, after a short
/// dwell in the connected state, presents the residential-IP education surface
/// (full modal or 30-day reminder) per `ResidentialEducationStore.decide`.
///
/// Mount once in the home shell, wrapping its content. [connectedCardKey]
/// anchors the reminder popover to the connection card on the map.
///
/// Guards (re-checked right before presenting — after the dwell and the state
/// read): still connected, still residential, the active home tab allows it,
/// and no education surface already in flight. If any fail the surface is
/// skipped — see the spec for the full edge-case matrix.
class ResidentialEducationTrigger extends ConsumerStatefulWidget {
  const ResidentialEducationTrigger({
    required this.connectedCardKey,
    required this.child,
    super.key,
  });

  /// Anchor for the reminder popover (the connection card on the map).
  final GlobalKey connectedCardKey;

  /// The home-shell content this trigger wraps. Rendered unchanged.
  final Widget child;

  @override
  ConsumerState<ResidentialEducationTrigger> createState() => _ResidentialEducationTriggerState();
}

class _ResidentialEducationTriggerState extends ConsumerState<ResidentialEducationTrigger> {
  /// Time the connection must stay connected-on-residential before presenting.
  static const _dwell = Duration(seconds: 2);

  ReactionDisposer? _disposer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final vpnStore = ref.read(vpnStorePOD);
    _disposer = reaction<int>((_) => vpnStore.userConnectEpoch, (_) {
      if (vpnStore.location?.ipType != IPType.residential) {
        return;
      }
      _timer?.cancel();
      _timer = Timer(_dwell, _present);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposer?.call();
    super.dispose();
  }

  Future<void> _present() async {
    if (!mounted) {
      return;
    }
    final eduStore = ref.read(residentialEducationStorePOD);
    final tabsStore = ref.read(homeTabsStorePOD);
    final analytics = ref.read(analyticsStorePOD);
    final remoteConfig = ref.read(remoteConfigStorePOD);

    // After the dwell window: only count the connect if it held.
    if (!_connectedOnResidential) {
      return;
    }
    if (!eduStore.tryBeginUi()) {
      return;
    }

    final now = DateTime.now();
    try {
      final action = await eduStore.recordConnectAndDecide(
        now,
        connectThreshold: remoteConfig.residentialEducationConnectThreshold,
        reminderInterval: remoteConfig.residentialReminderInterval,
      );
      // Re-evaluate every guard after the storage round-trip: the user may have
      // disconnected or switched tabs while it was in flight.
      if (!mounted || !_connectedOnResidential) {
        return;
      }
      final tab = tabsStore.selected;
      // The modal may show on the map or locations tab; the reminder anchors to
      // the connection card, which only lives on the map tab.
      final canShowModal = tab == HomeTab.map || tab == HomeTab.locations;
      final canShowReminder = tab == HomeTab.map && widget.connectedCardKey.currentContext != null;

      switch (action) {
        case EducationAction.showModal when canShowModal:
          analytics.logEvent(AnalyticsEvent.residentialEducationShown);
          await showResidentialEducationModal(context);
          // Persist only after the modal is dismissed (per spec).
          await eduStore.markModalShown(now);
          analytics.logEvent(AnalyticsEvent.residentialEducationDismissed);

        // Reminder skipped without burning the clock when its anchor isn't on
        // screen — it retries on the next qualifying connect.
        case EducationAction.showReminder when canShowReminder:
          analytics.logEvent(AnalyticsEvent.residentialReminderShown);
          await showInfoPopover(
            context: context,
            anchorKey: widget.connectedCardKey,
            title: LocaleKeys.ipTypeResidentialTooltipTitle.tr(),
            body: LocaleKeys.ipTypeResidentialTooltipBody.tr(),
            actionLabel: LocaleKeys.residentialEducationGotIt.tr(),
          );
          // Persist only after the reminder is dismissed (per spec).
          await eduStore.markReminderShown(now);
          analytics.logEvent(AnalyticsEvent.residentialReminderDismissed);

        case _:
          break;
      }
    } finally {
      eduStore.endUi();
    }
  }

  /// Read fresh on each call so guards reflect state at the moment they run.
  bool get _connectedOnResidential {
    final vpnStore = ref.read(vpnStorePOD);
    return vpnStore.isConnected && vpnStore.location?.ipType == IPType.residential;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
