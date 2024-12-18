import StoreKit

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#endif

public class StorekitExtensionsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
      let channel = FlutterMethodChannel(
        name: "storekit_extensions", binaryMessenger: registrar.messenger())
    #elseif os(macOS)
      let channel = FlutterMethodChannel(
        name: "storekit_extensions", binaryMessenger: registrar.messenger)
    #endif

    let instance = StorekitExtensionsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isEligibleForIntroOffer":
      guard let args = call.arguments as? [String: Any],
        let productId = args["productId"] as? String
      else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
        return
      }
      isEligibleForIntroOffer(productId: productId, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func isEligibleForIntroOffer(productId: String, result: @escaping FlutterResult) {
    Task {
      do {
        if #available(macOS 12.0, iOS 15.0, *) {
          let product = try await Product.products(for: [productId]).first
          let eligibility = try await product?.subscription?.isEligibleForIntroOffer ?? false
          result(eligibility)
        } else {
          result(
            FlutterError(
              code: "UNSUPPORTED_VERSION", message: "macOS version not supported", details: nil))
        }
      } catch {
        result(
          FlutterError(
            code: "ERROR", message: "Failed to check eligibility",
            details: error.localizedDescription))
      }
    }
  }
}