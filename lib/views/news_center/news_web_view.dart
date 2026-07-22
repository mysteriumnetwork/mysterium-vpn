import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens a News Center item's content in an in-app webview modal (via
/// [showModal] — this is a dialog, not a route).
Future<void> showNewsWebView(BuildContext context, Uri uri) async {
  await showModal<void>(context, builder: (_) => _NewsWebViewScreen(uri: uri));
}

/// Full-bleed in-app webview with a bare × whose colour flips black/white to
/// contrast the opened page's background (probed on load).
class _NewsWebViewScreen extends HookWidget {
  const _NewsWebViewScreen({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The webview surface colour (seen before the page paints). The app surface
    // so it is never white; becomes the page's own colour once probed.
    final surfaceColor = theme.palette.bgPopover;

    // `setBackgroundColor` is unimplemented on the desktop webview (macOS throws
    // "opaque is not implemented"), so the native surface colour is only set on
    // mobile. The Flutter-side load overlay + glyph tint still adapt everywhere.
    final canSetSurfaceColor = isMobile();

    final isLoading = useState(true);
    // Contrasting glyph colour for the ×, probed from the page on load.
    final glyph = useState<Color?>(null);
    // `onPageFinished` fires on every navigation/redirect; the one-time page
    // setup (overscroll + background probe) must run only once.
    final didInit = useRef(false);

    final controller = useMemoized(() {
      final controller = WebViewController();
      // Set before load so overscroll isn't white from the first frame.
      if (canSetSurfaceColor) {
        controller.setBackgroundColor(surfaceColor);
      }
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) async {
              isLoading.value = false;
              if (didInit.value) {
                return;
              }
              didInit.value = true;
              await _disableOverscroll(controller);
              final background = await _probeBackground(controller);
              if (canSetSurfaceColor && background != null) {
                await controller.setBackgroundColor(background);
              }
              glyph.value = _glyphFor(background);
            },
          ),
        )
        ..loadRequest(uri);
      return controller;
    });

    // Falls back to the theme icon colour until the probe resolves (or fails).
    final glyphColor = glyph.value ?? theme.palette.iconPrimary;

    // English-only content, forced left-to-right like the rest of the feature.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ModalScaffold(
        autoApplyPadding: false,
        showGradient: false,
        // Suppress the default × (it inherits the theme and can vanish against
        // page content); we render our own contrast-tinted one instead.
        appbar: const PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
        body: Stack(
          children: [
            // Mounted immediately so the WebView initializes and `onPageFinished`
            // fires (an unmounted WebView never loads). The overlay hides the
            // surface the native view paints while it loads.
            WebViewWidget(controller: controller),
            if (isLoading.value)
              Positioned.fill(
                child: ColoredBox(
                  color: surfaceColor,
                  child: const Center(child: LoadingIndicator()),
                ),
              ),
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(theme.spacing.md),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(UntitledUI.x_close, color: glyphColor),
                    iconSize: 24,
                    // Hover/focus/press highlight follows the glyph colour so a
                    // faint contrasting circle fades in behind the ×.
                    hoverColor: glyphColor.withValues(alpha: 0.16),
                    focusColor: glyphColor.withValues(alpha: 0.16),
                    highlightColor: glyphColor.withValues(alpha: 0.24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The close × colour that contrasts [background] — white on a dark page, black
/// on a light one. A null background (transparent/unreadable page → white
/// canvas) is treated as light.
Color _glyphFor(Color? background) {
  if (background == null) {
    return Palette.black;
  }
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Palette.white
      : Palette.black;
}

/// Suppresses the scroll bounce/rubber-band so there's no white overscroll area
/// past the top/bottom of the page.
///
/// Prefers the Flutter-side API [WebViewController.setOverScrollMode] (maps to
/// the native `scrollView.bounces = false` on iOS/Android). That native path
/// isn't implemented on macOS, so a CSS `overscroll-behavior` fallback (works on
/// modern WebKit/Blink) covers it. Both are best-effort.
Future<void> _disableOverscroll(WebViewController controller) async {
  try {
    await controller.setOverScrollMode(WebViewOverScrollMode.never);
  } catch (_) {
    // Unimplemented on some platforms (e.g. macOS) — the CSS below covers it.
  }
  const js = '''
(function () {
  var css = 'html, body { overscroll-behavior: none !important; }';
  var style = document.createElement('style');
  style.appendChild(document.createTextNode(css));
  (document.head || document.documentElement).appendChild(style);
})();
''';
  try {
    await controller.runJavaScript(js);
  } catch (_) {
    // Cosmetic only — ignore if the page blocks script injection.
  }
}

/// Reads the opened page's effective background colour (for the webview surface
/// and the contrast glyph).
///
/// Prefers the page's base background (`body`, then `html`) — the colour the
/// overscroll area should match — falling back to the element under the top-
/// right corner. Returns null when the page is transparent / unreadable (the
/// browser then paints its white canvas), so the caller keeps the app surface
/// colour instead of forcing white. Requires unrestricted JavaScript.
Future<Color?> _probeBackground(WebViewController controller) async {
  const js = r'''
(function () {
  function opaque(c) { return c && c !== 'transparent' && !/rgba\(0, *0, *0, *0\)/.test(c); }
  var body = getComputedStyle(document.body).backgroundColor;
  if (opaque(body)) return body;
  var html = getComputedStyle(document.documentElement).backgroundColor;
  if (opaque(html)) return html;
  var el = document.elementFromPoint(window.innerWidth - 24, 24);
  while (el) {
    var c = getComputedStyle(el).backgroundColor;
    if (opaque(c)) return c;
    el = el.parentElement;
  }
  return '';
})();
''';
  try {
    final result = await controller.runJavaScriptReturningResult(js);
    final rgba = _parseRgba(result.toString());
    if (rgba == null || rgba.$4 == 0) {
      return null;
    }
    return Color.fromARGB(255, rgba.$1, rgba.$2, rgba.$3);
  } catch (_) {
    return null;
  }
}

/// Extracts (r, g, b, a) from a CSS `rgb(...)`/`rgba(...)` string (as returned
/// by `getComputedStyle`), tolerating quotes some platforms add, comma- or
/// space-separated components, and a missing alpha (defaults to 1).
(int, int, int, double)? _parseRgba(String raw) {
  final match = RegExp(r'(\d+)[,\s]+(\d+)[,\s]+(\d+)(?:[,\s/]+([\d.]+))?').firstMatch(raw);
  if (match == null) {
    return null;
  }
  final alpha = match.group(4) == null ? 1.0 : (double.tryParse(match.group(4)!) ?? 1.0);
  return (
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
    alpha,
  );
}
