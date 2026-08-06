import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/snackbar.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Removes [ip] from the favorites and shows the removal snackbar with an
/// Undo action; a successful undo replaces it with the added confirmation.
/// Shared by the favorites tab and the connection-card heart.
Future<void> removeFavoriteIpWithUndo(FavoriteIpsStore store, String ip) async {
  await store.remove(ip);
  showSnackbar(
    S.current.favoriteIpRemovedToast,
    type: SnackbarType.info,
    action: ButtonTertiary(
      onPressed: () async {
        if (await store.undoRemove()) {
          showSnackbar(S.current.favoriteIpAddedToast, type: SnackbarType.info);
        }
      },
      size: ButtonSize.small,
      child: Text(S.current.undo),
    ),
  );
}
