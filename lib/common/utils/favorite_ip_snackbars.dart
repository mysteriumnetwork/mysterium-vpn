import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/snackbar.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Snackbar actions are small tertiary buttons throughout the favorites flow.
Widget _action(String label, VoidCallback onPressed) =>
    ButtonTertiary(onPressed: onPressed, size: ButtonSize.small, child: Text(label));

/// Reports that the plan's favorite limit is full, offering [onManage] as a
/// shortcut to the list the user has to prune to save a new IP.
void showFavoriteIpLimitSnackbar({required VoidCallback onManage}) {
  showSnackbar(
    S.current.favoriteIpLimitReached,
    action: _action(S.current.manageFavoriteIpsBtn, onManage),
  );
}

/// Removes [ip] from the favorites and shows the removal snackbar with an
/// Undo action; a successful undo replaces it with the added confirmation.
/// Shared by the favorites tab and the connection-card heart.
Future<void> removeFavoriteIpWithUndo(FavoriteIpsStore store, String ip) async {
  await store.remove(ip);
  showSnackbar(
    S.current.favoriteIpRemovedToast,
    type: SnackbarType.info,
    action: _action(S.current.undo, () async {
      if (await store.undoRemove()) {
        showSnackbar(S.current.favoriteIpAddedToast, type: SnackbarType.info);
      }
    }),
  );
}
