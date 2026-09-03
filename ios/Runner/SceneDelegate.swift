import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    handle(connectionOptions: connectionOptions)
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    var handledNativeDocument = false
    for context in URLContexts {
      if handleIncomingURL(context.url) {
        handledNativeDocument = true
      }
    }
    if !handledNativeDocument {
      super.scene(scene, openURLContexts: URLContexts)
    }
  }

  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if let url = userActivity.webpageURL, handleIncomingURL(url) {
      return
    }
    super.scene(scene, continue: userActivity)
  }

  private func handle(connectionOptions: UIScene.ConnectionOptions) {
    for context in connectionOptions.urlContexts {
      _ = handleIncomingURL(context.url)
    }
    if let url = connectionOptions.userActivities.compactMap(\.webpageURL).first {
      _ = handleIncomingURL(url)
    }
  }

  @discardableResult
  private func handleIncomingURL(_ url: URL) -> Bool {
    (UIApplication.shared.delegate as? AppDelegate)?.handleIncomingURL(url) ?? false
  }
}
