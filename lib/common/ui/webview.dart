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

/// Tracks a hosted page whose loaded URL may be a discovery fallback of the
/// one the caller asked for.
class WebViewTarget {
  WebViewTarget(this.original);

  final Uri original;

  /// The URL last loaded. Null until first resolved.
  Uri? current;

  Future<void>? _reported;

  Future<Uri> resolve() async => current = await resolveWebUrl(original);

  /// Reports [failed] when it is the page this target loaded. Errors further
  /// along a hosted flow, on someone else's site, say nothing about our domain.
  void recover(Uri? failed) {
    final loaded = current ?? original;
    if (failed?.host == loaded.host) {
      _reported ??= reportWebUrlFailure(original, loaded);
    }
  }

  /// Where a retry should go: a new URL once the domain has changed, or null
  /// to reload the failed page in place.
  Future<Uri?> retarget() async {
    final previous = current;
    final reported = _reported;
    _reported = null;
    // Resolving before the report lands would pick the same dead host.
    await reported;
    final next = await resolve();
    return next.host == previous?.host ? null : next;
  }

  /// [url] as the caller knows it: a fallback host mapped back to the original.
  Uri canonical(Uri url) {
    final loaded = current;
    return loaded != null && url.host == loaded.host ? url.replace(host: original.host) : url;
  }
}

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

    final target = useMemoized(() => WebViewTarget(uri));

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
                target.recover(Uri.tryParse(error.url ?? ''));
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
              final finished = target.canonical(Uri.parse(url));
              if (!closed.value && (shouldClose?.call(finished) ?? false)) {
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
        );
      target.resolve().then((resolved) async {
        if (context.mounted) {
          await controller.loadRequest(resolved);
        }
      }).ignore();
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
                                  onRetry: () async {
                                    load.value = _Load.loading;
                                    final next = await target.retarget();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    // Reload keeps a multi-step flow on its
                                    // page; only a new domain starts over.
                                    await (next == null
                                        ? controller.reload()
                                        : controller.loadRequest(next));
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
