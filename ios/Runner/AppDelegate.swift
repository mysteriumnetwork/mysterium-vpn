import Flutter
import StoreKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "storekit_extension", binaryMessenger: controller.binaryMessenger)

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

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func isEligibleForIntroOffer(productId: String, result: @escaping FlutterResult) {
      if #available(iOS 15.0, *) {
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