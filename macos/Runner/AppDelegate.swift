import Cocoa
import FlutterMacOS
import StoreKit

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool)
    -> Bool
  {
    if !flag {
      for window in NSApp.windows {
        if !window.isVisible {
          window.setIsVisible(true)
        }
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
      }
    }
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller: FlutterViewController =
      mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "storekit_extension", binaryMessenger: controller.engine.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "isEligibleForIntroOffer" {
        guard let args = call.arguments as? [String: Any],
          let productId = args["productId"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
          return
        }
        self.isEligibleForIntroOffer(productId: productId, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func isEligibleForIntroOffer(productId: String, result: @escaping FlutterResult) {
    if #available(macOS 12.0, *) {
      Task {
        do {
          let product = try await Product.products(for: [productId]).first
          let eligibility = try await product?.subscription?.isEligibleForIntroOffer ?? false

          result(eligibility)
        } catch {
          result(
            FlutterError(
              code: "ERROR", message: "Failed to check eligibility",
              details: error.localizedDescription))
        }
      }
    } else {
      result(
        FlutterError(
          code: "UNSUPPORTED_VERSION", message: "macOS 12.0 or higher is required", details: nil))
    }
  }
}