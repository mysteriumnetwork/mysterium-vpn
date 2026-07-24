import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Key of the red unread-dot overlay on [NewsCenterBellButton].
const newsCenterUnreadBadgeKey = Key('news-center-unread-badge');

/// Header bell that opens the News Center. Gated behind the `newsCenterEnabled`
/// flag, it eagerly loads the feed so the unread badge reflects unread items
/// before the page is opened.
class NewsCenterBellButton extends HookConsumerWidget {
  const NewsCenterBellButton({super.key});

  static const _dotSize = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigStorePOD);
    final store = ref.watch(newsCenterStorePOD);

    final enabled = useComputedValue(() => config.newsCenterEnabled);
    final hasUnread = useComputedValue(() => store.unreadCount > 0);

    // Eagerly load once the feature is enabled so the badge is accurate before
    // the user opens the page. `ensureLoaded` (not `load`) so this doesn't
    // re-fetch every time the bell remounts — e.g. the header is absent on the
    // Products tab, so leaving it would otherwise trigger a fresh fetch.
    useEffect(() {
      if (enabled) {
        store.ensureLoaded();
      }
      return null;
    }, [enabled]);

    if (!enabled) {
      return const SizedBox.shrink();
    }

    final palette = Theme.of(context).palette;

    return IconButton(
      key: K.newsCenterBell,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(UntitledUI.bell_01, size: 24),
          if (hasUnread)
            Positioned(
              top: -1,
              right: -1,
              child: Container(
                key: newsCenterUnreadBadgeKey,
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: palette.iconErrorPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.bgSidePanel, width: 1.5),
                ),
              ),
            ),
        ],
      ),
      onPressed: () => Beamer.of(context).beamToNamed(Routes.newsCenter.path),
    );
  }
}
