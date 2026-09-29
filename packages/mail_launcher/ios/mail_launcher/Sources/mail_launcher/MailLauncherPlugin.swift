import Flutter
import UIKit

private struct KnownMailApp {
  let name: String
  /// URL scheme used both for detection (canOpenURL) and launching to inbox.
  /// The host app's Info.plist must declare these in `LSApplicationQueriesSchemes`.
  let scheme: String
}

private let channelName = "network.mysterium/mail_launcher"

/// Order matters — the order returned to Dart is the order shown to the user.
private let knownApps: [KnownMailApp] = [
  KnownMailApp(name: "Apple Mail", scheme: "message"),
  KnownMailApp(name: "Gmail", scheme: "googlegmail"),
  KnownMailApp(name: "Outlook", scheme: "ms-outlook"),
  KnownMailApp(name: "Spark", scheme: "readdle-spark"),
  KnownMailApp(name: "Airmail", scheme: "airmail"),
  KnownMailApp(name: "Yahoo Mail", scheme: "ymail"),
  KnownMailApp(name: "Fastmail", scheme: "fastmail"),
  KnownMailApp(name: "Superhuman", scheme: "superhuman"),
  KnownMailApp(name: "ProtonMail", scheme: "protonmail"),
  KnownMailApp(name: "Dispatch", scheme: "x-dispatch"),
]

public final class MailLauncherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    let instance = MailLauncherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "listInstalled":
      result(listInstalled())
    case "open":
      guard let args = call.arguments as? [String: Any],
            let identifier = args["identifier"] as? String, !identifier.isEmpty else {
        result(FlutterError(code: "INVALID_ARGS", message: "identifier required", details: nil))
        return
      }
      open(scheme: identifier, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func listInstalled() -> [[String: String]] {
    let app = UIApplication.shared
    return knownApps.compactMap { entry -> [String: String]? in
      guard let url = URL(string: "\(entry.scheme)://"), app.canOpenURL(url) else { return nil }
      return ["name": entry.name, "identifier": entry.scheme]
    }
  }

  private func open(scheme: String, result: @escaping FlutterResult) {
    guard let url = URL(string: "\(scheme)://") else {
      result(false)
      return
    }
    DispatchQueue.main.async {
      UIApplication.shared.open(url, options: [:]) { success in
        result(success)
      }
    }
  }
}
