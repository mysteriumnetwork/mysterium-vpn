import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/blocker_type.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/settings/views/settings_picker_card.dart';
import 'package:mysterium_vpn/features/vpn/store/dns_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class BlockerPicker extends StatelessWidget {
  const BlockerPicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final dnsStore = getIt<DNSStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final authSessionStore = getIt<AuthSessionStore>();

    return Observer(
      builder: (_) {
        final isLoading =
            dnsStore.malwareContentBlockerFuture.status == FutureStatus.pending ||
            dnsStore.notSafeContentBlockerFuture.status == FutureStatus.pending;
        final current = dnsStore.blockerType;

        return SettingsPickerCard<BlockerType>(
          title: LocaleKeys.blockerSettingLbl.tr(),
          position: position,
          value: current,
          items: _availableTypes(dnsStore, current),
          labelOf: (t) => t.localeKey.tr(),
          onChanged: (type) => _applyBlockerType(type, dnsStore, analyticsStore),
          enabled: !isLoading && authSessionStore.isAuthenticated,
          isLoading: isLoading,
        );
      },
    );
  }

  static List<BlockerType> _availableTypes(DNSStore dnsStore, BlockerType current) => [
    BlockerType.none,
    if (!dnsStore.hideMalwareContentBlocker || current == BlockerType.malware) BlockerType.malware,
    if (!dnsStore.hideNotSafeContentBlocker || current == BlockerType.nsfwAndMalware)
      BlockerType.nsfwAndMalware,
  ];

  /// Applies blocker type by toggling malware/NSFW flags in a safe order:
  /// disable dependent (NSFW) before dependency (malware), enable dependency
  /// before dependent. Rolls back the first toggle if the second fails.
  static Future<void> _applyBlockerType(
    BlockerType type,
    DNSStore dnsStore,
    AnalyticsStore analyticsStore,
  ) async {
    final wasMalware = dnsStore.malwareContentBlocker;
    final wasNsfw = dnsStore.notSafeContentBlocker;
    final targetMalware = type != BlockerType.none;
    final targetNsfw = type == BlockerType.nsfwAndMalware;

    // 1. Disable NSFW first (before disabling its dependency, malware).
    if (wasNsfw && !targetNsfw) {
      await dnsStore.toggleNotSafeContentBlocker();
      analyticsStore.logEvent(AnalyticsEvent.nsfwOff);
    }

    // 2. Toggle malware; rollback NSFW on failure.
    if (wasMalware != targetMalware) {
      try {
        await dnsStore.toggleMalwareBlocker();
        analyticsStore.logEvent(
          targetMalware ? AnalyticsEvent.malwareOn : AnalyticsEvent.malwareOff,
        );
      } catch (_) {
        if (wasNsfw && !targetNsfw) {
          await dnsStore.toggleNotSafeContentBlocker();
        }
        rethrow;
      }
    }

    // 3. Enable NSFW last (after its dependency, malware); rollback malware on failure.
    if (!wasNsfw && targetNsfw) {
      try {
        await dnsStore.toggleNotSafeContentBlocker();
        analyticsStore.logEvent(AnalyticsEvent.nsfwOn);
      } catch (_) {
        if (wasMalware != targetMalware) {
          await dnsStore.toggleMalwareBlocker();
        }
        rethrow;
      }
    }
  }
}
