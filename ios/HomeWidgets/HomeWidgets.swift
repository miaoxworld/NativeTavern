import SwiftUI
import WidgetKit

@main
struct HomeWidgets: WidgetBundle {
  var body: some Widget {
    NativeTavernMomentsWidget()
    NativeTavernChatsWidget()
    NativeTavernCharactersWidget()
    NativeTavernStatusWidget()
    #if os(iOS) && canImport(ActivityKit)
    if #available(iOS 16.1, *) {
      NativeTavernLiveActivityWidget()
    }
    #endif
  }
}
