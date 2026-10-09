import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/url_launcher.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Whether an in-app webview can be shown.
///
/// `webview_flutter` ships no Windows or Linux implementation, so no platform
/// instance is registered there and constructing a [WebViewController] throws.
/// Asking the plugin (rather than testing the host platform) keeps this correct
/// if an implementation is ever added.
bool supportsInAppWebView() => WebViewPlatform.instance != null;

/// Shows the webview screen from [builder] as a modal, falling back to [uri] in
/// the default browser when [isSupported] reports no webview.
///
/// Open every in-app webview through this so the fallback cannot be forgotten;
/// [source] tags the `web_redirect` analytics event on the browser path.
/// [isSupported] is injectable because [WebViewPlatform.instance] can only be
/// set once per process, so tests cannot reach both branches through it.
Future<void> openInAppWebView(
  BuildContext context, {
  required Uri uri,
  required RedirectSource source,
  required WidgetBuilder builder,
  bool Function() isSupported = supportsInAppWebView,
}) async {
  if (!isSupported()) {
    await openUrlLink(uri, source: source);
    return;
  }
  await showModal<void>(context, builder: builder);
}

/// What the webview is currently showing. One value rather than two booleans,
/// so the loading and failed states cannot contradict each other.
enum _Load { loading, done, failed }

/// `NSURLErrorCancelled`. WKWebView reports a superseded main-frame navigation
/// as a failure, and the collector's token-for-cookie redirect guarantees one —
/// treating it as fatal would cover a page that is loading perfectly well.
/// There is no [WebResourceErrorType] for it, so the raw code is the only seam.
const _iosNavigationCancelled = -999;

/// In-app webview modal: an opaque toolbar (title + close) above a webview that
/// fills the space below it.
///
/// Shared by every in-app webview so the chrome, the loading overlay and the
/// safe-area handling live in one place.
class InAppWebViewScreen extends HookWidget {
  const InAppWebViewScreen({
    required this.uri,
    this.title,
    this.textDirection,
    this.shouldClose,
    super.key,
  });

  final Uri uri;

  /// Fixed toolbar title. When null, the loaded page's own title is shown.
  final String? title;

  /// Forces a text direction, for content that is English-only regardless of
  /// the app's locale. Null keeps the ambient direction.
  final TextDirection? textDirection;

  /// Closes the modal when it returns true for a finished navigation — used to
  /// detect that a hosted flow has run to completion.
  final bool Function(Uri url)? shouldClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final load = useState(_Load.loading);
    final pageTitle = useState('');
    final closed = useRef(false);

    final controller = useMemoized(() {
      final controller = WebViewController();
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (error) {
              // Subresource failures (an analytics beacon, a font) must not
              // replace a page that otherwise rendered; only a main-frame
              // failure means there is nothing to show.
              final fatal =
                  (error.isForMainFrame ?? true) && error.errorCode != _iosNavigationCancelled;
              if (fatal) {
                load.value = _Load.failed;
              }
            },
            onPageFinished: (url) async {
              // Android follows a main-frame error with onPageFinished for its
              // built-in error page; without this the retry overlay is torn
              // down and the user is left on `net::ERR_...`.
              if (load.value == _Load.failed) {
                return;
              }
              load.value = _Load.done;
              if (!closed.value && (shouldClose?.call(Uri.parse(url)) ?? false)) {
                closed.value = true;
                // maybePop + isCurrent: this fires from a platform callback, so
                // the modal may already be leaving, and popping then takes the
                // route underneath with it.
                if (context.mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
                  await Navigator.of(context).maybePop();
                }
                return;
              }
              // Only when the caller wants the page's own title; the setter
              // already ignores an unchanged value across redirects.
              if (title == null) {
                pageTitle.value = await controller.getTitle() ?? '';
              }
            },
          ),
        )
        ..loadRequest(uri);
      return controller;
    });

    final screen = ModalScaffold(
      autoApplyPadding: false,
      showGradient: false,
      // The toolbar below owns the close control; suppress the default app bar.
      appbar: const PreferredSize(preferredSize: Size.zero, child: SizedBox()),
      body: Column(
        children: [
          _WebViewBar(title: title ?? pageTitle.value, onClose: () => Navigator.of(context).pop()),
          Expanded(
            // Hosted pages cannot see Android's insets, so their own bottom
            // controls would sit under the navigation bar. Reserve it here.
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
              // Mounted immediately so the WebView initializes and
              // `onPageFinished` fires (an unmounted WebView never loads). The
              // overlay hides the surface the native view paints while loading.
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (load.value != _Load.done)
                    Positioned.fill(
                      child: ColoredBox(
                        color: theme.palette.bgPopover,
                        child: Center(
                          child: load.value == _Load.failed
                              ? _LoadFailed(
                                  onRetry: () {
                                    load.value = _Load.loading;
                                    controller.reload();
                                  },
                                )
                              : const LoadingIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Back must step through a hosted flow (rating → review form), not tear the
    // modal down and lose what the user has written.
    final withBack = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        if (await controller.canGoBack()) {
          await controller.goBack();
          return;
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: screen,
    );

    final direction = textDirection;
    return direction == null ? withBack : Directionality(textDirection: direction, child: withBack);
  }
}

/// Opaque toolbar: the current page [title] and a fixed close button. Being a
/// solid, themed bar (not floating over content), the × is always legible and
/// reliably tappable.
class _WebViewBar extends StatelessWidget {
  const _WebViewBar({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // `ModalScaffold`'s app bar makes the inner Scaffold zero the body's
    // padding/viewPadding, so pull the status-bar inset from the view (as
    // `ModalAppbar`/`Header` do) rather than from MediaQuery here.
    final topInset = ScreenType.topSafeAreaInset(context);
    return Material(
      color: theme.palette.bgSidePanel,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(width: theme.spacing.xl),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.textMd.semibold.copyWith(
                    color: theme.palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(UntitledUI.x_close, color: theme.palette.iconPrimary),
                iconSize: 24,
                tooltip: S.current.closeBtn,
              ),
              SizedBox(width: theme.spacing.s),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown in place of the loading overlay when the page could not be loaded, so
/// a failed navigation surfaces instead of spinning forever.
class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.s,
        children: [
          Text(
            S.current.somethingWentWrong,
            textAlign: TextAlign.center,
            style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textPrimary),
          ),
          ButtonSecondary(onPressed: onRetry, child: Text(S.current.tryAgainBtn)),
        ],
      ),
    );
  }
}
