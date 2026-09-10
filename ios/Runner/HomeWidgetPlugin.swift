import Flutter
import Foundation
import WidgetKit

enum HomeWidgetPlugin {
  static let channelName = "com.nativetavern/home_widgets"
  static let snapshotKey = "home_widget_snapshot"
  static let launchUriKey = "home_widget_launch_uri"
  static var appGroupId: String {
    Bundle.main.object(forInfoDictionaryKey: "NTAppGroupId") as? String
      ?? "group.com.miaomiaoxworld.nativetavern"
  }

  static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroupId) ?? .standard
  }

  private static var channel: FlutterMethodChannel?

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    self.channel = channel
    channel.setMethodCallHandler { call, result in
      handle(call, result: result)
    }
  }

  static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getContainerPath":
      let url = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupId
      )
      if let url {
        try? FileManager.default.createDirectory(
          at: url.appendingPathComponent("images"),
          withIntermediateDirectories: true
        )
      }
      result(url?.path)
    case "saveSnapshot":
      let args = call.arguments as? [String: Any]
      if let json = args?["json"] as? String {
        defaults.set(json, forKey: snapshotKey)
      }
      result(nil)
    case "reloadWidgets":
      WidgetCenter.shared.reloadAllTimelines()
      result(nil)
    case "takeLaunchUri":
      let value = defaults.string(forKey: launchUriKey)
      defaults.removeObject(forKey: launchUriKey)
      result(value)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  static func ingestLaunchURL(_ url: URL) -> Bool {
    guard url.scheme == "nativetavern" else { return false }
    defaults.set(url.absoluteString, forKey: launchUriKey)
    channel?.invokeMethod("onLaunchUri", arguments: url.absoluteString)
    return true
  }
}
