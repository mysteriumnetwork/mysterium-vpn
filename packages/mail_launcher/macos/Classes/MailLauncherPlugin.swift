import Cocoa
import FlutterMacOS

private let channelName = "network.mysterium/mail_launcher"

/// Apps that register a `mailto:` handler but are not mail clients.
/// Zoom, Teams, Slack etc. claim the scheme to deep-link into their own flows
/// (meeting invites, etc.). Filter them out so the picker only shows real mail apps.
private let excludedBundleIds: Set<String> = [
  "us.zoom.xos",
  "com.microsoft.teams",
  "com.microsoft.teams2",
  "com.tinyspeck.slackmacgap",
  "com.skype.skype",
]

public final class MailLauncherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger)
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
      open(bundleId: identifier, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func listInstalled() -> [[String: String]] {
    guard let mailto = URL(string: "mailto:") else { return [] }
    let urls = NSWorkspace.shared.urlsForApplications(toOpen: mailto)
    var seen = Set<String>()
    var apps: [[String: String]] = []
    for url in urls {
      guard let bundleId = Bundle(url: url)?.bundleIdentifier else { continue }
      guard !excludedBundleIds.contains(bundleId) else { continue }
      guard seen.insert(bundleId).inserted else { continue }
      let name = FileManager.default.displayName(atPath: url.path)
      apps.append(["name": name, "identifier": bundleId])
    }
    return apps
  }

  private func open(bundleId: String, result: @escaping FlutterResult) {
    guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) else {
      result(FlutterError(code: "NOT_FOUND", message: "Mail app not installed", details: bundleId))
      return
    }
    let config = NSWorkspace.OpenConfiguration()
    config.activates = true
    NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "OPEN_FAILED", message: error.localizedDescription, details: bundleId))
        } else {
          result(true)
        }
      }
    }
  }
}
