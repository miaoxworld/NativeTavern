import Flutter
import Foundation
import WidgetKit
#if canImport(ActivityKit)
import ActivityKit

public struct NativeTavernLiveAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    public var chatId: String
    public var characterId: String
    public var characterName: String
    public var avatarFileName: String?
    public var snippet: String
    public var phase: String // "generating" | "speaking" | "idle"
    public var providerLabel: String
    public var deepLink: String
    public var startedAt: Date
    public var updatedAt: Date
    public var tokensToday: Int

    public init(
      chatId: String,
      characterId: String,
      characterName: String,
      avatarFileName: String? = nil,
      snippet: String,
      phase: String,
      providerLabel: String,
      deepLink: String,
      startedAt: Date,
      updatedAt: Date,
      tokensToday: Int
    ) {
      self.chatId = chatId
      self.characterId = characterId
      self.characterName = characterName
      self.avatarFileName = avatarFileName
      self.snippet = snippet
      self.phase = phase
      self.providerLabel = providerLabel
      self.deepLink = deepLink
      self.startedAt = startedAt
      self.updatedAt = updatedAt
      self.tokensToday = tokensToday
    }
  }

  public var initialChatId: String

  public init(initialChatId: String) {
    self.initialChatId = initialChatId
  }
}
#endif

enum HomeWidgetPlugin {
  static let channelName = "com.nativetavern/home_widgets"
  static let snapshotKey = "home_widget_snapshot"
  static let liveKey = "home_widget_live"
  static let launchUriKey = "home_widget_launch_uri"
  static var appGroupId: String {
    Bundle.main.object(forInfoDictionaryKey: "NTAppGroupId") as? String
      ?? "group.com.miaomiaoxworld.nativetavern"
  }

  static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroupId) ?? .standard
  }

  private static var channel: FlutterMethodChannel?

  #if canImport(ActivityKit)
  @available(iOS 16.1, *)
  private static var currentActivity: Activity<NativeTavernLiveAttributes>?
  #endif

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
    case "startLive":
      let args = call.arguments as? [String: Any]
      let json = args?["json"] as? String
      if let json {
        defaults.set(json, forKey: liveKey)
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
          startLiveActivity(from: json)
        }
        #endif
      }
      result(nil)
    case "updateLive":
      let args = call.arguments as? [String: Any]
      let json = args?["json"] as? String
      if let json {
        defaults.set(json, forKey: liveKey)
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
          updateLiveActivity(from: json)
        }
        #endif
      }
      result(nil)
    case "endLive":
      let args = call.arguments as? [String: Any]
      let json = args?["json"] as? String
      if let json {
        defaults.set(json, forKey: liveKey)
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
          endLiveActivity(from: json)
        }
        #endif
      } else {
        defaults.removeObject(forKey: liveKey)
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
          endAllLiveActivities()
        }
        #endif
      }
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

  #if canImport(ActivityKit)
  @available(iOS 16.1, *)
  private static func parseContentState(from json: String) -> (String, NativeTavernLiveAttributes.ContentState)? {
    guard let data = json.data(using: .utf8),
          let map = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    else {
      return nil
    }
    let chatId = map["chatId"] as? String ?? ""
    let characterId = map["characterId"] as? String ?? ""
    let characterName = map["characterName"] as? String ?? "Assistant"
    let avatarFileName = map["characterAvatar"] as? String
    let snippet = map["snippet"] as? String ?? ""
    let phase = map["phase"] as? String ?? "generating"
    let providerLabel = map["providerLabel"] as? String ?? "LLM"
    let deepLink = map["deepLink"] as? String ?? "nativetavern://widget/chat?id=\(chatId)"
    let tokensToday = (map["tokensToday"] as? NSNumber)?.intValue ?? map["tokensToday"] as? Int ?? 0

    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let startedAt = (map["startedAt"] as? String).flatMap { isoFormatter.date(from: $0) }
      ?? ISO8601DateFormatter().date(from: map["startedAt"] as? String ?? "")
      ?? Date()
    let updatedAt = (map["updatedAt"] as? String).flatMap { isoFormatter.date(from: $0) }
      ?? ISO8601DateFormatter().date(from: map["updatedAt"] as? String ?? "")
      ?? Date()

    let state = NativeTavernLiveAttributes.ContentState(
      chatId: chatId,
      characterId: characterId,
      characterName: characterName,
      avatarFileName: avatarFileName,
      snippet: snippet,
      phase: phase,
      providerLabel: providerLabel,
      deepLink: deepLink,
      startedAt: startedAt,
      updatedAt: updatedAt,
      tokensToday: tokensToday
    )
    return (chatId, state)
  }

  @available(iOS 16.1, *)
  private static func startLiveActivity(from json: String) {
    guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
    guard let (chatId, contentState) = parseContentState(from: json) else { return }

    if let existing = currentActivity {
      Task {
        if #available(iOS 16.2, *) {
          await existing.update(ActivityContent(state: contentState, staleDate: nil))
        } else {
          await existing.update(using: contentState)
        }
      }
      return
    }

    for act in Activity<NativeTavernLiveAttributes>.activities {
      Task {
        if #available(iOS 16.2, *) {
          await act.end(ActivityContent(state: contentState, staleDate: nil), dismissalPolicy: .immediate)
        } else {
          await act.end(using: contentState, dismissalPolicy: .immediate)
        }
      }
    }

    let attributes = NativeTavernLiveAttributes(initialChatId: chatId)
    do {
      if #available(iOS 16.2, *) {
        let content = ActivityContent(state: contentState, staleDate: Date().addingTimeInterval(300))
        currentActivity = try Activity.request(attributes: attributes, content: content, pushType: nil)
      } else {
        currentActivity = try Activity.request(attributes: attributes, contentState: contentState, pushType: nil)
      }
    } catch {
      print("Failed to start Live Activity: \(error)")
    }
  }

  @available(iOS 16.1, *)
  private static func updateLiveActivity(from json: String) {
    guard let (_, contentState) = parseContentState(from: json) else { return }
    if let act = currentActivity {
      Task {
        if #available(iOS 16.2, *) {
          await act.update(ActivityContent(state: contentState, staleDate: Date().addingTimeInterval(300)))
        } else {
          await act.update(using: contentState)
        }
      }
    } else {
      startLiveActivity(from: json)
    }
  }

  @available(iOS 16.1, *)
  private static func endLiveActivity(from json: String) {
    let contentState = parseContentState(from: json)?.1
    endAllLiveActivities(finalState: contentState)
  }

  @available(iOS 16.1, *)
  private static func endAllLiveActivities(finalState: NativeTavernLiveAttributes.ContentState? = nil) {
    let activities = Activity<NativeTavernLiveAttributes>.activities
    currentActivity = nil
    for act in activities {
      Task {
        if let finalState {
          if #available(iOS 16.2, *) {
            await act.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
          } else {
            await act.end(using: finalState, dismissalPolicy: .immediate)
          }
        } else {
          if #available(iOS 16.2, *) {
            await act.end(nil, dismissalPolicy: .immediate)
          } else {
            await act.end(dismissalPolicy: .immediate)
          }
        }
      }
    }
  }
  #endif
}
