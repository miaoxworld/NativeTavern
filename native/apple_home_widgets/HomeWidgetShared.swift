import Foundation
import SwiftUI
import WidgetKit
#if canImport(AppIntents)
import AppIntents
#endif

enum HomeWidgetConstants {
  static let defaultAppGroupId = "group.com.miaomiaoxworld.nativetavern"
  static let appGroupPlistKey = "NTAppGroupId"
  static let snapshotKey = "home_widget_snapshot"
  static let launchUriKey = "home_widget_launch_uri"
  static let channelName = "com.nativetavern/home_widgets"

  static let momentsKind = "NativeTavernMomentsWidget"
  static let chatsKind = "NativeTavernChatsWidget"
  static let charactersKind = "NativeTavernCharactersWidget"
  static let statusKind = "NativeTavernStatusWidget"

  static var appGroupId: String {
    Bundle.main.object(forInfoDictionaryKey: appGroupPlistKey) as? String
      ?? defaultAppGroupId
  }
}

enum HomeWidgetStore {
  static var defaults: UserDefaults {
    UserDefaults(suiteName: HomeWidgetConstants.appGroupId) ?? .standard
  }

  static var containerURL: URL? {
    FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: HomeWidgetConstants.appGroupId
    )
  }

  static func indexKey(for kind: String) -> String {
    "home_widget_index_\(kind)"
  }

  static func pinnedIndex(for kind: String) -> Int? {
    let key = indexKey(for: kind)
    guard defaults.object(forKey: key) != nil else { return nil }
    return defaults.integer(forKey: key)
  }

  static func itemCount(for kind: String, in snapshot: [String: Any]? = nil) -> Int {
    let data = snapshot ?? self.snapshot()
    switch kind {
    case HomeWidgetConstants.chatsKind:
      return (data["chats"] as? [Any])?.count ?? 0
    case HomeWidgetConstants.charactersKind:
      return (data["characters"] as? [Any])?.count ?? 0
    case HomeWidgetConstants.momentsKind:
      return (data["moments"] as? [Any])?.count ?? 0
    default:
      return 1
    }
  }

  static func advance(kind: String, by delta: Int) {
    let count = max(1, itemCount(for: kind))
    let current = pinnedIndex(for: kind) ?? 0
    let next = ((current + delta) % count + count) % count
    defaults.set(next, forKey: indexKey(for: kind))
  }

  static func saveSnapshotJSON(_ json: String) {
    defaults.set(json, forKey: HomeWidgetConstants.snapshotKey)
  }

  static func snapshot() -> [String: Any] {
    guard let raw = defaults.string(forKey: HomeWidgetConstants.snapshotKey),
          let data = raw.data(using: .utf8),
          let object = try? JSONSerialization.jsonObject(with: data),
          let map = object as? [String: Any]
    else {
      return [:]
    }
    return map
  }

  static func labels() -> [String: String] {
    guard let raw = snapshot()["labels"] as? [String: Any] else { return [:] }
    var mapped: [String: String] = [:]
    for (key, value) in raw {
      if let text = value as? String {
        mapped[key] = text
      }
    }
    return mapped
  }

  static func intervalSeconds() -> Int {
    let settings = snapshot()["settings"] as? [String: Any] ?? [:]
    let value = (settings["slideIntervalSeconds"] as? NSNumber)?.intValue
      ?? settings["slideIntervalSeconds"] as? Int
    return max(5, value ?? 8)
  }

  static func image(named fileName: String) -> UIImageCompat? {
    guard let container = containerURL else { return nil }
    let url = container.appendingPathComponent("images").appendingPathComponent(fileName)
    guard let data = try? Data(contentsOf: url) else { return nil }
    return UIImageCompat(data: data)
  }

  static func setLaunchURI(_ value: String) {
    defaults.set(value, forKey: HomeWidgetConstants.launchUriKey)
  }

  static func takeLaunchURI() -> String? {
    let value = defaults.string(forKey: HomeWidgetConstants.launchUriKey)
    defaults.removeObject(forKey: HomeWidgetConstants.launchUriKey)
    return value
  }
}

#if os(macOS)
import AppKit
typealias UIImageCompat = NSImage
#else
import UIKit
typealias UIImageCompat = UIImage
#endif

struct HomeWidgetEntry: TimelineEntry {
  let date: Date
  let kind: String
  let index: Int
  let snapshot: [String: Any]

  var labels: [String: String] {
    HomeWidgetStore.labels()
  }
}

struct HomeWidgetProvider: TimelineProvider {
  let kind: String

  func placeholder(in context: Context) -> HomeWidgetEntry {
    HomeWidgetEntry(date: Date(), kind: kind, index: 0, snapshot: [:])
  }

  func getSnapshot(in context: Context, completion: @escaping (HomeWidgetEntry) -> Void) {
    completion(entry(at: Date(), index: 0))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<HomeWidgetEntry>) -> Void) {
    let snapshot = HomeWidgetStore.snapshot()
    let interval = HomeWidgetStore.intervalSeconds()
    let count = max(1, HomeWidgetStore.itemCount(for: kind, in: snapshot))
    let now = Date()
    if let pinned = HomeWidgetStore.pinnedIndex(for: kind) {
      completion(
        Timeline(
          entries: [entry(at: now, index: pinned % count, snapshot: snapshot)],
          policy: .after(now.addingTimeInterval(15 * 60))
        )
      )
      return
    }
    var entries: [HomeWidgetEntry] = []
    let limit = min(count * 4, 40)
    for offset in 0..<limit {
      let date = now.addingTimeInterval(TimeInterval(offset * interval))
      entries.append(entry(at: date, index: offset % count, snapshot: snapshot))
    }
    let policy = TimelineReloadPolicy.after(
      now.addingTimeInterval(TimeInterval(limit * interval))
    )
    completion(Timeline(entries: entries, policy: policy))
  }

  private func entry(at date: Date, index: Int, snapshot: [String: Any] = HomeWidgetStore.snapshot()) -> HomeWidgetEntry {
    HomeWidgetEntry(date: date, kind: kind, index: index, snapshot: snapshot)
  }
}

#if canImport(AppIntents)
@available(iOS 17.0, macOS 14.0, *)
struct AdvanceHomeWidgetIntent: AppIntent {
  static var title: LocalizedStringResource = "Advance NativeTavern widget"
  static var isDiscoverable: Bool { false }

  @Parameter(title: "Kind")
  var kind: String

  @Parameter(title: "Delta")
  var delta: Int

  init() {
    kind = HomeWidgetConstants.chatsKind
    delta = 1
  }

  init(kind: String, delta: Int) {
    self.kind = kind
    self.delta = delta
  }

  func perform() async throws -> some IntentResult {
    HomeWidgetStore.advance(kind: kind, by: delta)
    WidgetCenter.shared.reloadTimelines(ofKind: kind)
    return .result()
  }
}
#endif

struct NativeTavernMomentsWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: HomeWidgetConstants.momentsKind,
      provider: HomeWidgetProvider(kind: HomeWidgetConstants.momentsKind)
    ) { entry in
      MomentsWidgetView(entry: entry)
        .widgetChrome(entry)
        .widgetURL(url(from: entry, arrayKey: "moments"))
    }
    .configurationDisplayName(Text("Moments"))
    .description(Text("See recent moments from your tavern."))
    .supportedFamilies(HomeWidgetFamilies.all)
  }
}

struct NativeTavernChatsWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: HomeWidgetConstants.chatsKind,
      provider: HomeWidgetProvider(kind: HomeWidgetConstants.chatsKind)
    ) { entry in
      ChatsWidgetView(entry: entry)
        .widgetChrome(entry)
        .widgetURL(url(from: entry, arrayKey: "chats"))
    }
    .configurationDisplayName(Text("Chats"))
    .description(Text("Cycle through the latest messages in recent chats."))
    .supportedFamilies(HomeWidgetFamilies.all)
  }
}

struct NativeTavernCharactersWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: HomeWidgetConstants.charactersKind,
      provider: HomeWidgetProvider(kind: HomeWidgetConstants.charactersKind)
    ) { entry in
      CharactersWidgetView(entry: entry)
        .widgetChrome(entry)
        .widgetURL(url(from: entry, arrayKey: "characters"))
    }
    .configurationDisplayName(Text("Characters"))
    .description(Text("Browse your character cards from the home screen."))
    .supportedFamilies(HomeWidgetFamilies.all)
  }
}

struct NativeTavernStatusWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: HomeWidgetConstants.statusKind,
      provider: HomeWidgetProvider(kind: HomeWidgetConstants.statusKind)
    ) { entry in
      StatusWidgetView(entry: entry)
        .widgetChrome(entry)
        .widgetURL(statusURL(entry))
    }
    .configurationDisplayName(Text("Status"))
    .description(Text("Current model, tokens used, and provider credits."))
    .supportedFamilies(HomeWidgetFamilies.all)
  }
}

enum HomeWidgetFamilies {
  static var all: [WidgetFamily] {
    var families: [WidgetFamily] = [.systemSmall, .systemMedium, .systemLarge]
    #if os(iOS)
    families.append(.systemExtraLarge)
    if #available(iOS 16.0, *) {
      families.append(contentsOf: [
        .accessoryCircular,
        .accessoryRectangular,
        .accessoryInline,
      ])
    }
    #else
    if #available(macOS 14.0, *) {
      families.append(.systemExtraLarge)
    }
    #endif
    return families
  }
}

private func isAccessoryFamily(_ family: WidgetFamily) -> Bool {
  #if os(iOS)
  if #available(iOS 16.0, *) {
    switch family {
    case .accessoryCircular, .accessoryRectangular, .accessoryInline:
      return true
    default:
      return false
    }
  }
  #endif
  return false
}

private struct WidgetChromeModifier: ViewModifier {
  let entry: HomeWidgetEntry
  @Environment(\.widgetFamily) private var family

  func body(content: Content) -> some View {
    let palette = HomeWidgetPalette(snapshot: entry.snapshot)
    let accessory = isAccessoryFamily(family)
    let tinted = content.tint(palette.primary)
    if accessory {
      tinted
    } else if #available(iOS 17.0, macOS 14.0, *) {
      tinted.containerBackground(for: .widget) {
        palette.card
      }
    } else {
      tinted.background(palette.card)
    }
  }
}

private extension View {
  func widgetChrome(_ entry: HomeWidgetEntry) -> some View {
    modifier(WidgetChromeModifier(entry: entry))
  }
}

struct HomeWidgetPalette {
  let isDark: Bool
  let primary: Color
  let accent: Color
  let background: Color
  let card: Color
  let textPrimary: Color
  let textSecondary: Color

  init(snapshot: [String: Any]) {
    let theme = snapshot["theme"] as? [String: Any] ?? [:]
    isDark = theme["isDark"] as? Bool ?? true
    primary = Color(hex: theme["primary"] as? String)
      ?? Color(red: 0.39, green: 0.40, blue: 0.95)
    accent = Color(hex: theme["accent"] as? String)
      ?? Color(red: 0.55, green: 0.36, blue: 0.96)
    background = Color(hex: theme["background"] as? String)
      ?? Color(red: 0.06, green: 0.06, blue: 0.06)
    card = Color(hex: theme["card"] as? String)
      ?? Color(red: 0.15, green: 0.15, blue: 0.15)
    textPrimary = Color(hex: theme["textPrimary"] as? String) ?? .primary
    textSecondary = Color(hex: theme["textSecondary"] as? String) ?? .secondary
  }
}

private extension Color {
  init?(hex: String?) {
    guard var value = hex?.trimmingCharacters(in: .whitespacesAndNewlines),
          !value.isEmpty
    else {
      return nil
    }
    if value.hasPrefix("#") {
      value.removeFirst()
    }
    guard value.count == 6 || value.count == 8,
          let parsed = UInt64(value, radix: 16)
    else {
      return nil
    }
    let hasAlpha = value.count == 8
    let a = hasAlpha ? Double((parsed >> 24) & 0xFF) / 255 : 1
    let r = Double((parsed >> (hasAlpha ? 16 : 16)) & 0xFF) / 255
    let g = Double((parsed >> (hasAlpha ? 8 : 8)) & 0xFF) / 255
    let b = Double(parsed & 0xFF) / 255
    self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
  }
}

private func arrayItem(_ entry: HomeWidgetEntry, key: String) -> [String: Any]? {
  let items = entry.snapshot[key] as? [[String: Any]] ?? []
  guard !items.isEmpty else { return nil }
  return items[entry.index % items.count]
}

private func url(from entry: HomeWidgetEntry, arrayKey: String) -> URL? {
  if let item = arrayItem(entry, key: arrayKey),
     let raw = item["deepLink"] as? String {
    return URL(string: raw)
  }
  return URL(string: "nativetavern://widget/home")
}

private func statusURL(_ entry: HomeWidgetEntry) -> URL? {
  let status = entry.snapshot["status"] as? [String: Any]
  if let raw = status?["deepLink"] as? String {
    return URL(string: raw)
  }
  return URL(string: "nativetavern://widget/aiConfig")
}

struct MomentsWidgetView: View {
  let entry: HomeWidgetEntry

  var body: some View {
    let item = arrayItem(entry, key: "moments")
    WidgetCard(
      title: entry.labels["moments"] ?? "Moments",
      heading: item?["authorName"] as? String,
      bodyText: item?["body"] as? String,
      emptyText: entry.labels["emptyMoments"] ?? "Nobody has posted yet.",
      imageName: item.flatMap { item in
        let id = item["id"] as? String
        return id.map { "moment_\($0).img" }
      },
      palette: HomeWidgetPalette(snapshot: entry.snapshot)
    )
  }
}

struct ChatsWidgetView: View {
  let entry: HomeWidgetEntry

  var body: some View {
    let item = arrayItem(entry, key: "chats")
    let index = item?["messageIndex"] as? Int ?? 0
    let count = item?["messageCount"] as? Int ?? 0
    let subtitle: String? = {
      guard let name = item?["characterName"] as? String else { return nil }
      if count > 0 {
        return "\(name) · \(index + 1)/\(count)"
      }
      return name
    }()
    WidgetCard(
      title: entry.labels["chats"] ?? "Chats",
      heading: subtitle,
      bodyText: item?["body"] as? String,
      emptyText: entry.labels["emptyChats"] ?? "No chats yet.",
      imageName: (item?["characterId"] as? String).map { "chat_\($0).img" },
      kind: HomeWidgetConstants.chatsKind,
      labels: entry.labels,
      palette: HomeWidgetPalette(snapshot: entry.snapshot)
    )
  }
}

struct CharactersWidgetView: View {
  let entry: HomeWidgetEntry

  var body: some View {
    let item = arrayItem(entry, key: "characters")
    WidgetCard(
      title: entry.labels["characters"] ?? "Characters",
      heading: item?["name"] as? String,
      bodyText: item?["description"] as? String,
      emptyText: entry.labels["emptyCharacters"] ?? "No characters yet.",
      imageName: (item?["id"] as? String).map { "character_\($0).img" },
      kind: HomeWidgetConstants.charactersKind,
      labels: entry.labels,
      palette: HomeWidgetPalette(snapshot: entry.snapshot)
    )
  }
}

struct StatusWidgetView: View {
  let entry: HomeWidgetEntry
  @Environment(\.widgetFamily) private var family

  var body: some View {
    let status = entry.snapshot["status"] as? [String: Any] ?? [:]
    let health = status["health"] as? String ?? "needsKey"
    let healthLabel = statusHealthLabel(health, labels: entry.labels)
    let provider = status["providerLabel"] as? String ?? status["provider"] as? String ?? ""
    let model = status["model"] as? String ?? ""
    let today = jsonInt(status["tokensToday"])
    let total = jsonInt(status["tokensTotal"])
    let palette = HomeWidgetPalette(snapshot: entry.snapshot)
    if isAccessoryFamily(family) {
      StatusAccessoryView(
        family: family,
        provider: provider,
        health: health,
        healthLabel: healthLabel,
        today: today,
        palette: palette
      )
    } else {
      VStack(alignment: .leading, spacing: 6) {
        Text(entry.labels["status"] ?? "Status")
          .font(.caption.weight(.semibold))
          .foregroundStyle(palette.textSecondary)
        Text(provider)
          .font(.headline)
          .foregroundStyle(palette.textPrimary)
          .lineLimit(1)
        Text(model)
          .font(.caption)
          .foregroundStyle(palette.textSecondary)
          .lineLimit(1)
        Text(healthLabel)
          .font(.caption.weight(.medium))
          .foregroundStyle(healthColor(health, palette: palette))
        Text("\(entry.labels["tokensToday"] ?? "Today"): \(formatTokens(today))")
          .font(.caption)
          .foregroundStyle(palette.textPrimary)
        Text("\(entry.labels["tokensTotal"] ?? "Total"): \(formatTokens(total))")
          .font(.caption)
          .foregroundStyle(palette.textPrimary)
        if let remaining = status["remoteRemaining"] as? Double {
          Text("\(entry.labels["remoteCredits"] ?? "Credits"): \(String(format: "%.2f", remaining))")
            .font(.caption)
            .foregroundStyle(palette.textPrimary)
        } else {
          Text(entry.labels["remoteUnsupported"] ?? "Tracked locally")
            .font(.caption)
            .foregroundStyle(palette.textSecondary)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding()
    }
  }
}

struct StatusAccessoryView: View {
  let family: WidgetFamily
  let provider: String
  let health: String
  let healthLabel: String
  let today: Int
  let palette: HomeWidgetPalette

  var body: some View {
    #if os(iOS)
    if #available(iOS 16.0, *) {
      switch family {
      case .accessoryCircular:
        VStack(spacing: 2) {
          Image(systemName: healthSymbol(health))
            .font(.title3)
          Text(formatTokens(today))
            .font(.caption2.weight(.semibold))
            .minimumScaleFactor(0.6)
            .lineLimit(1)
        }
        .widgetAccentable()
      case .accessoryRectangular:
        VStack(alignment: .leading, spacing: 2) {
          Text(provider)
            .font(.headline)
            .lineLimit(1)
          Text(healthLabel)
            .font(.caption)
          Text(formatTokens(today))
            .font(.caption2)
        }
        .widgetAccentable()
      case .accessoryInline:
        Text("\(provider) · \(healthLabel)")
          .widgetAccentable()
      default:
        Text("\(provider) · \(healthLabel)")
      }
    } else {
      Text("\(provider) · \(healthLabel)")
    }
    #else
    Text("\(provider) · \(healthLabel)")
    #endif
  }
}

struct WidgetCard: View {
  let title: String
  let heading: String?
  let bodyText: String?
  let emptyText: String
  let imageName: String?
  var kind: String? = nil
  var labels: [String: String] = [:]
  var palette: HomeWidgetPalette
  @Environment(\.widgetFamily) private var family

  var body: some View {
    if isAccessoryFamily(family) {
      accessoryBody
    } else {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .top, spacing: 10) {
          if let imageName, let image = HomeWidgetStore.image(named: imageName) {
            Image(compat: image)
              .resizable()
              .scaledToFill()
              .frame(width: 44, height: 44)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
          VStack(alignment: .leading, spacing: 4) {
            Text(title)
              .font(.caption.weight(.semibold))
              .foregroundStyle(palette.textSecondary)
            if let heading, !heading.isEmpty {
              Text(heading)
                .font(.headline)
                .foregroundStyle(palette.textPrimary)
                .lineLimit(1)
            }
            Text((bodyText?.isEmpty == false) ? bodyText! : emptyText)
              .font(.caption)
              .foregroundStyle(
                bodyText?.isEmpty == false ? palette.textPrimary : palette.textSecondary
              )
              .lineLimit(5)
          }
        }
        if let kind, kind == HomeWidgetConstants.chatsKind ||
            kind == HomeWidgetConstants.charactersKind {
          navigationRow(kind: kind)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding()
    }
  }

  @ViewBuilder
  private var accessoryBody: some View {
    let text = (heading?.isEmpty == false ? heading! : title)
    #if os(iOS)
    if #available(iOS 16.0, *) {
      switch family {
      case .accessoryCircular:
        ZStack {
          if let imageName, let image = HomeWidgetStore.image(named: imageName) {
            Image(compat: image)
              .resizable()
              .scaledToFill()
          } else {
            Text(String(text.prefix(1)))
              .font(.headline.weight(.semibold))
          }
        }
        .clipShape(Circle())
        .widgetAccentable()
      case .accessoryRectangular:
        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.caption2)
          Text(text)
            .font(.headline)
            .lineLimit(1)
          if let bodyText, !bodyText.isEmpty {
            Text(bodyText)
              .font(.caption2)
              .lineLimit(2)
          }
        }
        .widgetAccentable()
      case .accessoryInline:
        Text(text).widgetAccentable()
      default:
        Text(text)
      }
    } else {
      Text(text)
    }
    #else
    Text(text)
    #endif
  }

  @ViewBuilder
  private func navigationRow(kind: String) -> some View {
    if #available(iOS 17.0, macOS 14.0, *) {
      HStack {
        Spacer()
        #if canImport(AppIntents)
        Button(intent: AdvanceHomeWidgetIntent(kind: kind, delta: -1)) {
          Image(systemName: "chevron.left")
        }
        .accessibilityLabel(Text(labels["previous"] ?? "Previous"))
        Button(intent: AdvanceHomeWidgetIntent(kind: kind, delta: 1)) {
          Image(systemName: "chevron.right")
        }
        .accessibilityLabel(Text(labels["next"] ?? "Next"))
        #endif
      }
      .buttonStyle(.plain)
    }
  }
}

private extension Image {
  init(compat image: UIImageCompat) {
    #if os(macOS)
    self.init(nsImage: image)
    #else
    self.init(uiImage: image)
    #endif
  }
}

private func statusHealthLabel(_ health: String, labels: [String: String]) -> String {
  switch health {
  case "ready": return labels["providerReady"] ?? "Ready"
  case "local": return labels["providerLocal"] ?? "Local"
  case "unreachable": return labels["providerUnreachable"] ?? "Unreachable"
  default: return labels["providerNeedsKey"] ?? "API key needed"
  }
}

private func healthSymbol(_ health: String) -> String {
  switch health {
  case "ready": return "checkmark.circle.fill"
  case "local": return "desktopcomputer"
  case "unreachable": return "wifi.slash"
  default: return "key.fill"
  }
}

private func healthColor(_ health: String, palette: HomeWidgetPalette) -> Color {
  switch health {
  case "ready": return palette.accent
  case "local": return palette.primary
  case "unreachable": return Color.red
  default: return palette.textSecondary
  }
}

private func jsonInt(_ value: Any?) -> Int {
  (value as? NSNumber)?.intValue ?? value as? Int ?? 0
}

private func formatTokens(_ value: Int) -> String {
  if value >= 1_000_000 {
    return String(format: "%.1fM", Double(value) / 1_000_000)
  }
  if value >= 1000 {
    return String(format: "%.1fk", Double(value) / 1000)
  }
  return "\(value)"
}

#if os(iOS) && canImport(ActivityKit)
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

@available(iOS 16.1, *)
public struct NativeTavernLiveActivityWidget: Widget {
  public init() {}

  public var body: some WidgetConfiguration {
    ActivityConfiguration(for: NativeTavernLiveAttributes.self) { context in
      LiveActivityLockScreenBannerView(state: context.state)
        .widgetURL(URL(string: context.state.deepLink.isEmpty ? "nativetavern://widget/home" : context.state.deepLink))
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          HStack(spacing: 8) {
            if let avatar = context.state.avatarFileName,
               let image = HomeWidgetStore.image(named: avatar) {
              Image(compat: image)
                .resizable()
                .scaledToFill()
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            } else {
              Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 16))
                .foregroundColor(.purple)
            }
            Text(context.state.characterName)
              .font(.headline)
              .lineLimit(1)
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          HStack(spacing: 4) {
            Text(sanitizedProvider(context.state.providerLabel))
              .font(.caption2.weight(.semibold))
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(Capsule().fill(Color.purple.opacity(0.25)))
            phaseIcon(context.state.phase)
          }
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack(alignment: .leading, spacing: 4) {
            let labelText = context.state.snippet.isEmpty
              ? (context.state.phase == "speaking" ? "Reading reply..." : "Generating reply...")
              : context.state.snippet
            Text(labelText)
              .font(.subheadline)
              .lineLimit(3)
              .foregroundStyle(.secondary)
            if context.state.tokensToday > 0 {
              HStack {
                Spacer()
                Text("Tokens: \(formatTokens(context.state.tokensToday))")
                  .font(.caption2)
                  .foregroundStyle(.secondary)
              }
            }
          }
          .padding(.top, 4)
        }
      } compactLeading: {
        if let avatar = context.state.avatarFileName,
           let image = HomeWidgetStore.image(named: avatar) {
          Image(compat: image)
            .resizable()
            .scaledToFill()
            .frame(width: 18, height: 18)
            .clipShape(Circle())
        } else {
          Image(systemName: "sparkles")
            .foregroundStyle(.purple)
        }
      } compactTrailing: {
        phaseIcon(context.state.phase)
      } minimal: {
        if let avatar = context.state.avatarFileName,
           let image = HomeWidgetStore.image(named: avatar) {
          Image(compat: image)
            .resizable()
            .scaledToFill()
            .frame(width: 18, height: 18)
            .clipShape(Circle())
        } else {
          Image(systemName: "bubble.left.fill")
            .foregroundStyle(.purple)
        }
      }
      .widgetURL(URL(string: context.state.deepLink.isEmpty ? "nativetavern://widget/home" : context.state.deepLink))
    }
  }
}

@available(iOS 16.1, *)
private struct LiveActivityLockScreenBannerView: View {
  let state: NativeTavernLiveAttributes.ContentState

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      if let avatar = state.avatarFileName,
         let image = HomeWidgetStore.image(named: avatar) {
        Image(compat: image)
          .resizable()
          .scaledToFill()
          .frame(width: 44, height: 44)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      } else {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(Color.purple.opacity(0.2))
            .frame(width: 44, height: 44)
          Image(systemName: "bubble.left.and.bubble.right.fill")
            .font(.system(size: 20))
            .foregroundStyle(.purple)
        }
      }

      VStack(alignment: .leading, spacing: 4) {
        HStack(alignment: .center) {
          Text(state.characterName)
            .font(.headline)
            .lineLimit(1)
          Spacer()
          HStack(spacing: 6) {
            Text(sanitizedProvider(state.providerLabel))
              .font(.caption2.weight(.medium))
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(Capsule().fill(Color.white.opacity(0.12)))
            phaseBadge(state.phase)
          }
        }

        let displayText = state.snippet.isEmpty
          ? (state.phase == "speaking" ? "Reading reply..." : "Generating reply...")
          : state.snippet
        Text(displayText)
          .font(.subheadline)
          .lineLimit(4)
          .foregroundStyle(.primary)

        if state.tokensToday > 0 {
          HStack {
            Spacer()
            Text("Tokens: \(formatTokens(state.tokensToday))")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
        }
      }
    }
    .padding(14)
    .activityBackgroundTint(Color.black.opacity(0.8))
  }
}

@available(iOS 16.1, *)
@ViewBuilder
private func phaseIcon(_ phase: String) -> some View {
  switch phase {
  case "speaking":
    Image(systemName: "waveform")
      .foregroundStyle(.blue)
      .font(.caption2)
  default:
    Image(systemName: "sparkles")
      .foregroundStyle(.purple)
      .font(.caption2)
  }
}

@available(iOS 16.1, *)
@ViewBuilder
private func phaseBadge(_ phase: String) -> some View {
  switch phase {
  case "speaking":
    HStack(spacing: 3) {
      Image(systemName: "waveform")
      Text("Speaking")
    }
    .font(.caption2.weight(.medium))
    .foregroundStyle(.blue)
  default:
    HStack(spacing: 3) {
      Image(systemName: "sparkles")
      Text("Generating")
    }
    .font(.caption2.weight(.medium))
    .foregroundStyle(.purple)
  }
}

private func sanitizedProvider(_ label: String) -> String {
  let restricted = ["OpenAI", "xAI (Grok)", "xAI", "Grok", "Claude", "Gemini", "OpenRouter"]
  if restricted.contains(label) {
    let lang = Locale.preferredLanguages.first?.lowercased() ?? ""
    if lang.hasPrefix("zh") {
      return "LLM"
    }
  }
  return label.isEmpty ? "LLM" : label
}
#endif

