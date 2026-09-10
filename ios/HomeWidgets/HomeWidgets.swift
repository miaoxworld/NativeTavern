import SwiftUI
import WidgetKit

@main
struct HomeWidgets: WidgetBundle {
  var body: some Widget {
    NativeTavernMomentsWidget()
    NativeTavernChatsWidget()
    NativeTavernCharactersWidget()
    NativeTavernStatusWidget()
  }
}
