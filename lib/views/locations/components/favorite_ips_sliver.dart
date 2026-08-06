import 'dart:async';

import 'package:circle_flags/circle_flags.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/favorite_ip_item_loading.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Content of the Favorite tab in Locations: saved-IP cards with an
/// "Unavailable IPs" section, or the locked / downgraded-plan states.
class FavoriteIpsSliver extends HookConsumerWidget {
  const FavoriteIpsSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(favoriteIpsStorePOD);
    final analytics = ref.watch(analyticsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final displayStore = ref.watch(connectionDisplayStorePOD);
    final handleToggleConnection = useHandleToggleConnection();
    final handleSubscribe = useHandleSubscribe();

    useEffect(() {
      store.refreshAvailability();
      return null;
    }, [store]);

    Future<void> handleConnect(FavoriteIp favorite) async {
      // A tap on the connected favorite is a disconnect toggle, so it gets no
      // connect-attempt analytics.
      if (vpnStore.isConnected && displayStore.connectionIP == favorite.ip) {
        await handleToggleConnection(location: favorite.location, targetIp: favorite.ip);
        return;
      }

      // The store owns the analytics payload — it knows the IP's availability.
      store
        ..recordConnectClicked(favorite)
        ..setConnectingIp(favorite.ip);
      try {
        await handleToggleConnection(location: favorite.location, targetIp: favorite.ip);
      } finally {
        store.setConnectingIp(null);
      }
      store.recordConnectOutcome(favorite, connectedIp: vpnStore.vpnConnection?.connectionIP);
    }

    Future<void> handleRemove(FavoriteIp favorite) => removeFavoriteIpWithUndo(store, favorite.ip);

    Future<void> handleUpgrade() async {
      unawaited(analytics.logFavoriteIpUpgradePlanClicked());
      await handleSubscribe();
    }

    return Observer(
      builder: (context) {
        // Read the location lists HERE (not lazily inside the card builders):
        // an Observer only tracks observables read during its own build, so
        // reading them later would miss the lists finishing loading.
        final names = _FavoriteIpNames(
          datacenter: locationsStore.dcLocationsFuture.value,
          residential: locationsStore.residentialLocationsFuture.value,
        );

        if (!store.isEnabled) {
          return store.favorites.isEmpty
              ? _LockedPromo(onUpgrade: handleUpgrade)
              : _DowngradedList(favorites: store.favorites, names: names, onUpgrade: handleUpgrade);
        }

        // Initial load only: once a value exists, list changes keep showing it.
        if (store.future.value == null) {
          return const _FavoritesLoading();
        }

        if (store.favorites.isEmpty) {
          return const _EmptyState();
        }

        return _FavoritesList(
          available: store.availableFavorites,
          unavailable: store.unavailableFavorites,
          connectedIp: vpnStore.isConnected ? displayStore.connectionIP : null,
          connectingIp: store.connectingIp,
          names: names,
          onConnect: handleConnect,
          onRemove: handleRemove,
        );
      },
    );
  }
}

/// Resolves a favorite's country/place labels from the loaded location lists,
/// so they follow the app locale instead of the locale they were saved in.
///
/// Holds the lists as plain values read during the owning [Observer]'s build;
/// falls back to the stored strings while the lists are still loading.
@immutable
class _FavoriteIpNames {
  /// Indexes both lists by lowercased country code once, so resolving a card
  /// is a map lookup instead of a scan of every country.
  factory _FavoriteIpNames({
    required VPNLocations? datacenter,
    required VPNLocations? residential,
  }) => _FavoriteIpNames._(_byCountry(datacenter), _byCountry(residential));

  const _FavoriteIpNames._(this._datacenter, this._residential);

  final Map<String, VPNLocation> _datacenter;
  final Map<String, VPNLocation> _residential;

  static Map<String, VPNLocation> _byCountry(VPNLocations? locations) => {
    for (final location in locations?.allLocations ?? const <VPNLocation>{})
      location.countryCode.toLowerCase(): location,
  };

  /// Country name plus the city / IP-type line, resolved together so the
  /// country lookup happens once per card.
  ({String name, String place}) labelsOf(BuildContext context, FavoriteIp favorite) {
    final country = (favorite.ipType == IPType.datacenter
        ? _datacenter
        : _residential)[favorite.countryCode.toLowerCase()];
    final city = favorite.isCountryPick
        ? null
        : country?.children?.firstWhereOrNull((it) => it.id == favorite.locationId);
    return (
      name: country?.getName(context) ?? favorite.displayName(context),
      place:
          city?.getName(context) ??
          (favorite.city.isNotEmpty ? favorite.city : favorite.ipType.localizedLabel),
    );
  }
}

/// Column shell shared by the saved-IP list states.
class _CardsColumn extends StatelessWidget {
  const _CardsColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Theme.of(context).spacing.ms,
      children: children,
    ),
  );
}

class _FavoritesLoading extends StatelessWidget {
  const _FavoritesLoading();

  @override
  Widget build(BuildContext context) => const _CardsColumn(
    children: [
      FavoriteIpItemLoading(),
      FavoriteIpItemLoading(),
      FavoriteIpItemLoading(),
      FavoriteIpItemLoading(),
      FavoriteIpItemLoading(),
    ],
  );
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({
    required this.available,
    required this.unavailable,
    required this.connectedIp,
    required this.connectingIp,
    required this.names,
    required this.onConnect,
    required this.onRemove,
  });

  final List<FavoriteIp> available;
  final List<FavoriteIp> unavailable;
  final String? connectedIp;
  final String? connectingIp;
  final _FavoriteIpNames names;
  final void Function(FavoriteIp) onConnect;
  final void Function(FavoriteIp) onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _CardsColumn(
      children: [
        for (final favorite in available)
          _FavoriteCard(
            favorite: favorite,
            names: names,
            state: favorite.ip == connectingIp
                ? _CardState.connecting
                : favorite.ip == connectedIp
                ? _CardState.connected
                : _CardState.idle,
            onTap: () => onConnect(favorite),
            onFavoriteTap: () => onRemove(favorite),
          ),
        if (unavailable.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.md),
            child: Text(
              S.current.favoriteIpsUnavailableHeading,
              style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textTertiary),
            ),
          ),
          for (final favorite in unavailable)
            _FavoriteCard(
              favorite: favorite,
              names: names,
              state: _CardState.unavailable,
              // Not connectable, but still removable.
              onFavoriteTap: () => onRemove(favorite),
            ),
        ],
      ],
    );
  }
}

class _DowngradedList extends StatelessWidget {
  const _DowngradedList({required this.favorites, required this.names, required this.onUpgrade});

  final List<FavoriteIp> favorites;
  final _FavoriteIpNames names;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) => _CardsColumn(
    children: [
      _UpgradeBanner(onUpgrade: onUpgrade),
      for (final favorite in favorites)
        _FavoriteCard(
          favorite: favorite,
          names: names,
          state: _CardState.unavailable,
          type: SavedIpCardType.locked,
        ),
    ],
  );
}

/// How a favorite card renders: its connection state, or unavailable (the
/// backend can't serve the IP, or the plan no longer allows favorites).
enum _CardState { idle, connecting, connected, unavailable }

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.favorite,
    required this.names,
    required this.state,
    this.type = SavedIpCardType.favorite,
    this.onTap,
    this.onFavoriteTap,
  });

  final FavoriteIp favorite;
  final _FavoriteIpNames names;
  final _CardState state;
  final SavedIpCardType type;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final (:name, :place) = names.labelsOf(context, favorite);
    return SavedIpCard(
      countryIcon: switch (state) {
        _CardState.connecting => LoadingIndicator(color: Theme.of(context).palette.iconPrimary),
        _CardState.connected => const _ConnectedCheck(),
        _ => CircleFlag(favorite.countryCode, size: 24),
      },
      name: name,
      subtitle: switch (state) {
        _CardState.connecting => '${S.current.connecting}...',
        _CardState.connected => '${S.current.connected} · $place',
        _ => place,
      },
      ipAddress: favorite.ip,
      badgeLabel: favorite.badgeLabel,
      type: type,
      status: switch (state) {
        _CardState.connected => SavedIpCardStatus.connected,
        _CardState.unavailable => SavedIpCardStatus.disabled,
        _ => SavedIpCardStatus.idle,
      },
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
    );
  }
}

/// Brand icon in a tinted circle. Figma: brand-500 glyph on brand-100/900.
class _CircleBadge extends StatelessWidget {
  const _CircleBadge({required this.icon, this.size = 48, this.iconSize = 24});

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return DecoratedIcon(
      icon: icon,
      decoration: IconDecoration(
        iconSize: iconSize,
        iconColor: palette.bgBrandPrimary,
        backgroundColor: palette.bgBrand,
        padding: EdgeInsets.all((size - iconSize) / 2),
        borderRadius: BorderRadius.all(theme.radius.full),
      ),
    );
  }
}

/// Green check circle marking the connected favorite (mirrors the connected
/// marker on location list items).
class _ConnectedCheck extends StatelessWidget {
  const _ConnectedCheck();

  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    decoration: const BoxDecoration(color: Palette.success, shape: BoxShape.circle),
    child: const Center(child: Icon(UntitledUI.check, size: 16, color: Palette.white)),
  );
}

class _UpgradeBanner extends StatelessWidget {
  const _UpgradeBanner({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.s),
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
      ),
      child: Row(
        spacing: theme.spacing.ms,
        children: [
          const _CircleBadge(icon: UntitledUI.lock_01, size: 32, iconSize: 16),
          Expanded(
            child: Text(
              S.current.favoriteIpsNotAvailableOnPlan,
              style: theme.textStyles.textSm.regular.copyWith(color: palette.textSecondary),
            ),
          ),
          ButtonTertiary(
            onPressed: onUpgrade,
            size: ButtonSize.small,
            child: Text(S.current.subscriptionUpgrade),
          ),
        ],
      ),
    );
  }
}

/// Centered promo column constrained to the Figma width (~335 px on
/// desktop); on mobile the sliver is narrower than the cap anyway.
class _PromoColumn extends StatelessWidget {
  const _PromoColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.xl3),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: theme.spacing.md,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return _PromoColumn(
      children: [
        const Center(child: _CircleBadge(icon: UntitledUI.heart)),
        Text(
          S.current.favoriteIpsEmptyTitle,
          textAlign: TextAlign.center,
          style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
        ),
        Text(
          S.current.favoriteIpsEmptyBody,
          textAlign: TextAlign.center,
          style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
        ),
      ],
    );
  }
}

class _LockedPromo extends StatelessWidget {
  const _LockedPromo({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final isWide = ScreenType.of(context) >= ScreenType.tablet;
    final button = ButtonPrimary(
      onPressed: onUpgrade,
      child: Text(S.current.favoriteIpsUpgradePlan),
    );
    return _PromoColumn(
      children: [
        const Center(child: _CircleBadge(icon: UntitledUI.lock_01)),
        Text(
          S.current.favoriteIpsLockedTitle,
          textAlign: TextAlign.center,
          style: theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
        ),
        Text(
          S.current.favoriteIpsLockedBody,
          textAlign: TextAlign.center,
          style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
        ),
        SizedBox(height: theme.spacing.s),
        // Figma: the button hugs its label on desktop, spans on mobile.
        if (isWide) Center(child: button) else button,
      ],
    );
  }
}
