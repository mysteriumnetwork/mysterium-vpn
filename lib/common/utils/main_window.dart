import 'package:window_manager/window_manager.dart';

// On Windows `getCurrent()` resolves through GetActiveWindow(), which is null
// whenever our window is not the active one — including while it is hidden in
// the tray, exactly when we need it back. Cache the first window it hands out.
Window? _mainWindow;

Window? get mainWindow => _mainWindow ??= WindowManager.instance.getCurrent();

/// Brings the window back from hidden or minimized and gives it focus.
void showMainWindow() {
  final window = mainWindow;
  if (window == null) {
    return;
  }
  if (!window.isVisible) {
    window.show();
  }
  if (window.isMinimized) {
    window.restore();
  }
  window.focus();
}
