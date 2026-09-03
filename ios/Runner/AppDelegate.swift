import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let url = launchOptions?[.url] as? URL, isNativeTavernDocument(url) {
      initialFilePath = copyIncomingFile(url)
    }

    _ = prepareBackupVisibility()

    var filteredOptions = launchOptions
    if let url = launchOptions?[.url] as? URL, isNativeTavernDocument(url) {
      filteredOptions?.removeValue(forKey: .url)
    }
    return super.application(application, didFinishLaunchingWithOptions: filteredOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let messenger = engineBridge.applicationRegistrar.messenger()
    let regionChannel = FlutterMethodChannel(
      name: "com.nativetavern/region",
      binaryMessenger: messenger
    )
    let live2DRenderScaleChannel = FlutterMethodChannel(
      name: "com.nativetavern/live2d_render_scale",
      binaryMessenger: messenger
    )

    regionChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getStorefrontCountry" {
        self?.getStorefrontCountry(result: result)
      } else if call.method == "isChinaRegion" {
        self?.isChinaRegion(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    live2DRenderScaleChannel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "synchronizeContentScale" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let arguments = call.arguments as? [String: Any]
      let requestedScale = (arguments?["devicePixelRatio"] as? NSNumber).map { CGFloat(truncating: $0) }
      result(self?.synchronizeLive2DContentScale(requestedScale: requestedScale) ?? 0)
    }

    let fileOpenChannel = FlutterMethodChannel(
      name: "com.nativetavern/file_open",
      binaryMessenger: messenger
    )
    self.fileOpenChannel = fileOpenChannel
    fileOpenChannel.setMethodCallHandler { [weak self] call, result in
      if call.method == "getInitialFile" {
        result(self?.initialFilePath)
        self?.initialFilePath = nil
      } else if call.method == "prepareBackupVisibility" {
        result(self?.prepareBackupVisibility())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    let iCloudChannel = FlutterMethodChannel(
      name: "com.nativetavern/icloud",
      binaryMessenger: messenger
    )
    iCloudChannel.setMethodCallHandler { [weak self] call, result in
      self?.handleICloudCall(call, result: result)
    }
  }

  private var fileOpenChannel: FlutterMethodChannel?
  private var initialFilePath: String?

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if isNativeTavernDocument(url) {
      deliverOpenedFile(url)
      return true
    }
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if let url = userActivity.webpageURL, isNativeTavernDocument(url) {
      deliverOpenedFile(url)
      return true
    }
    return super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )
  }

  @discardableResult
  func handleIncomingURL(_ url: URL) -> Bool {
    guard isNativeTavernDocument(url) else { return false }
    deliverOpenedFile(url)
    return true
  }

  private func deliverOpenedFile(_ url: URL) {
    let filePath = copyIncomingFile(url) ?? url.path
    if let channel = fileOpenChannel {
      channel.invokeMethod("onFileOpened", arguments: filePath)
    } else {
      initialFilePath = filePath
    }
  }

  private func isNativeTavernDocument(_ url: URL) -> Bool {
    let ext = url.pathExtension.lowercased()
    return ["ntx", "ntb", "ntm", "jsonl"].contains(ext)
  }

  /// Copies a security-scoped Files URL into a readable temp path.
  private func copyIncomingFile(_ url: URL) -> String? {
    let accessing = url.startAccessingSecurityScopedResource()
    defer {
      if accessing {
        url.stopAccessingSecurityScopedResource()
      }
    }

    let tempDir = FileManager.default.temporaryDirectory
    let destination = tempDir.appendingPathComponent(url.lastPathComponent)
    do {
      if FileManager.default.fileExists(atPath: destination.path) {
        try FileManager.default.removeItem(at: destination)
      }
      try FileManager.default.copyItem(at: url, to: destination)
      return destination.path
    } catch {
      return url.path
    }
  }

  /// Exposes only `NativeTavern/Backups` in the Files app by hiding sibling data.
  private func prepareBackupVisibility() -> String {
    let fileManager = FileManager.default
    guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return ""
    }
    let nativeTavern = documents.appendingPathComponent("NativeTavern", isDirectory: true)
    let backups = nativeTavern.appendingPathComponent("Backups", isDirectory: true)
    try? fileManager.createDirectory(at: backups, withIntermediateDirectories: true)

    hideItem(at: nativeTavern, hidden: false)
    if let children = try? fileManager.contentsOfDirectory(
      at: nativeTavern,
      includingPropertiesForKeys: [.isHiddenKey],
      options: []
    ) {
      for child in children {
        hideItem(at: child, hidden: child.lastPathComponent != "Backups")
      }
    }

    if let rootItems = try? fileManager.contentsOfDirectory(
      at: documents,
      includingPropertiesForKeys: [.isHiddenKey],
      options: []
    ) {
      for item in rootItems where item.lastPathComponent != "NativeTavern" {
        hideItem(at: item, hidden: true)
      }
    }

    return backups.path
  }

  private func hideItem(at url: URL, hidden: Bool) {
    var itemURL = url
    var values = URLResourceValues()
    values.isHidden = hidden
    try? itemURL.setResourceValues(values)
  }

  private func synchronizeLive2DContentScale(requestedScale: CGFloat?) -> Int {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }

    return windows.reduce(0) { count, window in
      let validRequestedScale = requestedScale.flatMap { scale in
        scale.isFinite && scale >= 1 ? scale : nil
      }
      let scale = validRequestedScale ?? window.screen.scale
      return count + synchronizeLive2DContentScale(in: window, scale: scale)
    }
  }

  private func synchronizeLive2DContentScale(in view: UIView, scale: CGFloat) -> Int {
    let className = NSStringFromClass(type(of: view))
    var matchedViews = 0

    if className == "Live2DGLView" || className.hasSuffix(".Live2DGLView") {
      matchedViews = 1
      if abs(view.contentScaleFactor - scale) > 0.001 ||
          abs(view.layer.contentsScale - scale) > 0.001 {
        NSLog(
          "Live2D iOS render scale: %gx/%gx -> %gx",
          view.contentScaleFactor,
          view.layer.contentsScale,
          scale
        )
        view.contentScaleFactor = scale
        view.layer.contentsScale = scale
        view.setNeedsLayout()
        view.layoutIfNeeded()
      }
    }

    return view.subviews.reduce(matchedViews) { count, subview in
      count + synchronizeLive2DContentScale(in: subview, scale: scale)
    }
  }

  private func getStorefrontCountry(result: @escaping FlutterResult) {
    if #available(iOS 13.0, *) {
      // Use SKStorefront for iOS 13+
      if let storefront = SKPaymentQueue.default().storefront {
        result(storefront.countryCode)
        return
      }
    }

    // Fallback: Use device locale
    let countryCode = Locale.current.regionCode ?? Locale.current.identifier
    result(countryCode)
  }

  /// Comprehensive China region detection
  /// Checks multiple sources: SKStorefront, system locale, preferred languages, timezone
  private func isChinaRegion(result: @escaping FlutterResult) {
    var reasons: [String] = []

    // 1. Check SKStorefront (App Store region)
    if #available(iOS 13.0, *) {
      if let storefront = SKPaymentQueue.default().storefront {
        let code = storefront.countryCode.uppercased()
        if code == "CHN" || code == "CN" {
          reasons.append("storefront:\(code)")
        }
      }
    }

    // 2. Check system locale region
    if let regionCode = Locale.current.regionCode?.uppercased() {
      if regionCode == "CN" || regionCode == "CHN" {
        reasons.append("locale_region:\(regionCode)")
      }
    }

    // 3. Check preferred languages (if user has Chinese as preferred)
    let preferredLanguages = Locale.preferredLanguages
    for lang in preferredLanguages {
      // Check for zh-Hans-CN, zh-CN, zh_CN patterns
      let langLower = lang.lowercased()
      if langLower.hasPrefix("zh") && (langLower.contains("-cn") || langLower.contains("_cn") || langLower.contains("-hans-cn")) {
        reasons.append("preferred_lang:\(lang)")
        break
      }
    }

    // 4. Check timezone (Asia/Shanghai, Asia/Chongqing, etc.)
    let timezone = TimeZone.current.identifier
    if timezone.hasPrefix("Asia/Shanghai") ||
       timezone.hasPrefix("Asia/Chongqing") ||
       timezone.hasPrefix("Asia/Harbin") ||
       timezone.hasPrefix("Asia/Urumqi") ||
       timezone == "PRC" {
      reasons.append("timezone:\(timezone)")
    }

    // 5. Check locale identifier
    let localeId = Locale.current.identifier.lowercased()
    if localeId.contains("zh_cn") || localeId.contains("zh-cn") || localeId.contains("zh_hans_cn") {
      reasons.append("locale_id:\(localeId)")
    }

    // Log for debugging
    print("RegionService iOS: reasons=\(reasons)")

    // Return true if any China indicator is found
    let isChina = !reasons.isEmpty
    result(["isChina": isChina, "reasons": reasons])
  }

  private static var iCloudContainerId: String {
    if let containers = Bundle.main.object(forInfoDictionaryKey: "NSUbiquitousContainers") as? [String: Any],
       let containerId = containers.keys.first {
      return containerId
    }
    return "iCloud.com.miaomiaoxworld.nativetavern"
  }

  private func handleICloudCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getContainerPath":
      result(iCloudDocumentsPath())
    case "ensureDownloaded":
      let args = call.arguments as? [String: Any]
      let path = args?["path"] as? String
      result(ensureICloudFileDownloaded(path))
    case "copyFile":
      let args = call.arguments as? [String: Any]
      let sourcePath = args?["sourcePath"] as? String
      let fileName = args?["fileName"] as? String
      result(copyToICloud(sourcePath: sourcePath, fileName: fileName))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func iCloudDocumentsURL() -> URL? {
    guard let container = FileManager.default.url(
      forUbiquityContainerIdentifier: Self.iCloudContainerId
    ) else {
      return FileManager.default.url(forUbiquityContainerIdentifier: nil)
        .map { $0.appendingPathComponent("Documents") }
    }
    let documents = container.appendingPathComponent("Documents")
    try? FileManager.default.createDirectory(
      at: documents,
      withIntermediateDirectories: true
    )
    return documents
  }

  private func iCloudDocumentsPath() -> String? {
    iCloudDocumentsURL()?.path
  }

  private func ensureICloudFileDownloaded(_ path: String?) -> Bool {
    guard let path, !path.isEmpty else { return false }
    let url = URL(fileURLWithPath: path)
    do {
      try FileManager.default.startDownloadingUbiquitousItem(at: url)
      return FileManager.default.fileExists(atPath: path)
    } catch {
      return FileManager.default.fileExists(atPath: path)
    }
  }

  private func copyToICloud(sourcePath: String?, fileName: String?) -> Bool {
    guard let sourcePath, let fileName, let destinationDir = iCloudDocumentsURL() else {
      return false
    }
    let source = URL(fileURLWithPath: sourcePath)
    let destination = destinationDir.appendingPathComponent(fileName)
    let coordinator = NSFileCoordinator()
    var coordinationError: NSError?
    var copied = false
    coordinator.coordinate(
      writingItemAt: destination,
      options: .forReplacing,
      error: &coordinationError
    ) { writerURL in
      do {
        if FileManager.default.fileExists(atPath: writerURL.path) {
          try FileManager.default.removeItem(at: writerURL)
        }
        try FileManager.default.copyItem(at: source, to: writerURL)
        copied = true
      } catch {
        copied = false
      }
    }
    return copied && coordinationError == nil
  }
}
