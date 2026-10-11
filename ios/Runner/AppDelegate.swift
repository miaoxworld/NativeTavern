import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Register region detection channel
    let messenger = engineBridge.applicationRegistrar.messenger()
    let regionChannel = FlutterMethodChannel(name: "com.nativetavern/region",
                                              binaryMessenger: messenger)
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
      let requestedScale = (arguments?["devicePixelRatio"] as? NSNumber)
        .map { CGFloat($0.doubleValue) }
      result(self?.synchronizeLive2DContentScale(requestedScale: requestedScale) ?? 0)
    }
  }

  private func synchronizeLive2DContentScale(requestedScale: CGFloat?) -> Int {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }

    return windows.reduce(0) { count, window in
      let validRequestedScale = requestedScale.flatMap { scale in
        scale.isFinite && scale >= 1 ? scale : nil
      }
      return count + synchronizeLive2DContentScale(in: window, fallbackScale: validRequestedScale)
    }
  }

  private func synchronizeLive2DContentScale(in view: UIView, fallbackScale: CGFloat?) -> Int {
    let className = NSStringFromClass(type(of: view))
    var matchedViews = 0

    if className == "Live2DGLView" || className.hasSuffix(".Live2DGLView") {
      // A display transition can change scale without creating a new view.
      // Read each surface's traits rather than applying one screen's scale to
      // every connected scene.
      let displayScale = view.traitCollection.displayScale
      let scale = displayScale.isFinite && displayScale >= 1
        ? displayScale : (fallbackScale ?? 1)
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
      count + synchronizeLive2DContentScale(in: subview, fallbackScale: fallbackScale)
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
}
