# iPhone Duo adaptation

Official documentation checked on 2026-10-11:

- [Three steps to make your app shine on iPhone Duo](https://developer.apple.com/iphone-duo/prepare/)
- [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)
- [Prepare and submit your apps for iPhone Duo, October 5](https://developer.apple.com/news/?id=kkphp5qo)
- [Xcode platform and host requirements](https://developer.apple.com/support/xcode/)
- [Xcode 27.1 release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-27_1-release-notes)
- [UIView reserved regions](https://developer.apple.com/documentation/uikit/uiview/reservedregions(kind:options:))
- [UITraitCollection.verticalBarEdge](https://developer.apple.com/documentation/uikit/uitraitcollection/verticalbaredge)
- [UIBackgroundExtensionView](https://developer.apple.com/documentation/uikit/uibackgroundextensionview)
- [Flutter UIScene migration](https://flutter.dev/to/uiscene-migration)

## Requirements and implementation

Apple specifies dynamic resizing from container bounds, current display traits,
and active reserved regions, rather than device models, screen-size lists, or
orientation-based layout decisions. Build with Xcode 27.1 / iOS 27.1 SDK or later
to use the complete display. Apps built with SDK 26 or earlier run in a
compatibility layout; SDK 27 fills more space but still avoids the status bar.
This is a build SDK requirement, not a reason to raise the deployment target
from iOS 15.

NativeTavern uses Flutter-drawn bars, so UIKit does not automatically reposition
its navigation widgets. The custom `NativeTavernViewController` sends current
host-view bounds, the system's vertical bar edge, and active division/occlusion
regions over `com.nativetavern/window_geometry`. New APIs have both an SDK
compile guard and an iOS availability check. Layout, safe-area, and trait
updates publish changed geometry. The host also registers the system traits
that affect the vertical bar edge. Reserved-region frames already include
their interactive-content margins, so they are forwarded without expanding
them a second time. No device identification or main-screen
dimensions are used.

The iOS host adopts the UIScene lifecycle using `FlutterSceneDelegate` and the
existing custom-host storyboard. Plugins and application method channels are
registered in `didInitializeImplicitFlutterEngine` through the engine bridge,
so launch no longer depends on an app-delegate window. This is required by the
iOS 27.1 runtime: the previous lifecycle terminated at
`UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption` during the first
actual Duo launch. Debug builds also disable Xcode's debug-dylib launcher, which
failed to find this application's entry point with Xcode 27.1 RC.

`AppViewport` checks that native geometry matches the current Flutter frame,
combines native regions with Flutter display features, and updates local
`MediaQuery` dimensions, insets, and feature coordinates. It conservatively
uses the largest unobstructed rectangle when a fold or camera occludes content;
equal-sized panes prefer the bottom/right pane. An inactive, flat fold does not
divide the interface. The entire routed tree keeps the same element positions,
including dialogs, so resizing retains its navigation and editing state.
The main shell and chat routes explicitly opt in to sharing the vertical bar
column. For these routes, the column's native safe-area width determines the
rail width, and active occlusion frames determine where its controls begin.
Occlusions contained in the column are handled by that rail, instead of
excluding the entire column and adding a second rail alongside it. Folding
regions and occlusions outside the column still constrain the usable pane.
Other full-screen routes retain the conservative side insets. Route changes
update this preference without replacing the routed child tree.

The theme background fills the whole host view. The physical vertical bar
column and custom navigation/action rails use the theme surface color.
Controls stay below the reported camera/status-indicator regions and above
the bottom safe area; rails scroll when their remaining height is limited.
The status-bar
strip is part of the display and does not require an opaque black background.
Apple documents extending backgrounds outside the safe area, with
`UIBackgroundExtensionView` for UIKit images. Our solid Flutter surfaces paint
that area directly without resizing or wrapping the native Flutter host.
Using both panes simultaneously for separate chat and character views is a
future enhancement; the current approach keeps every screen accessible in one
usable pane.

The main tab navigation follows the native physical edge, independent of RTL
reading direction, and shares the status column rather than reserving another
column for the menu. Where native bar geometry is unavailable, it chooses a rail
or bottom bar from container width. Chat
page actions also follow the native edge, keeping the title above the content.
Active TTS pause/stop controls stack vertically with the other page actions.
Chat messages and input share a maximum reading width of 900 logical pixels;
input menus use that container width and wrap tools as space shrinks. The visual
novel message panel sizes from its remaining space above the input and keyboard,
instead of the full window height. Character grids recalculate columns from
available width and use even column counts in wide containers.
Card labels take the height their text requires instead of a fixed fraction of
the tile, so names remain visible when more columns fit in the inner display.

Live2D synchronizes scale again when window metrics change and re-reads the
Flutter view scale on each synchronization attempt. Native surfaces use their
own current `traitCollection.displayScale`, avoiding a shared scale across
different scenes.

## Verification

Automated coverage is in `test/adaptive_window_layout_test.dart` and
`test/chat_screen_lifecycle_test.dart`. It exercises native geometry messages,
vertical and horizontal folds (including zero-thickness divisions), camera
occlusion, unfolding, stale snapshots, invalid region values, state retention,
short navigation rails, navigation selection, input menu boundaries, and a
visual novel panel with keyboard insets. It also checks active TTS controls and
a formatting popup during resizing. The shared-column test checks indicator
avoidance, menu placement and hit testing on both physical edges under RTL,
the folded pane, and draft retention. Existing popup, home/group navigation,
settings/play navigation, and Live2D lifecycle tests cover adjacent behavior.

The eight adaptation/lifecycle tests and 22 adjacent regression tests pass.
Changed Dart files pass the repository format check; the new layout components
and their tests pass static analysis. The host fallback passes an Objective-C
syntax/type check against the installed simulator SDK. The Xcode project,
property list, and storyboard also pass their format/syntax checks.

The native host passes Objective-C syntax/type checks against both the older
SDK fallback and the installed iOS 27.1 simulator SDK, including its new API
branch. The complete application compiles successfully with Xcode 27.1 and the
iOS 27.1 simulator SDK, including the UIScene migration. An ordinary
`flutter run --debug --no-pub` also completes successfully and connects to the
Dart VM service on the official Duo simulator.

Actual simulator checks cover launch, main navigation, built-in character
cards, character details, and a chat with a built-in greeting. Closed, fully
open, partially folded, and rotated layouts were exercised. The character grid
reflows, navigation follows the physical bar edge, and a typed chat draft
survives display/pose transitions. The initial status-column background used
the content color `#0F0F0F`, next to the rail's `#1A1A1A`. The surface correction
was verified in Default Dark and Default Light, including closed and partially
folded transitions. The subsequent layout correction places menu controls in
that same column below the status indicators, rather than just matching two
adjacent columns' colors. Screenshots use display 1 for the outer screen and
display 3 for the inner screen; the default capture can select an inactive
display and is not sufficient verification.

For the shared-column change, `flutter run --debug --no-pub` failed during an
online Swift package refresh. The existing dependency cache resolved with
`-skipPackageUpdates`, and an Xcode Debug simulator build using the resolved
package versions succeeded. That persistent app bundle was installed with
`simctl`, preserving simulator data. This was a development simulator build,
not release packaging. Release artifacts must still use `./build_ios.sh`.

The final shared-column app was checked on the closed outer display and fully
open and partially folded inner display. Its main menu stays in the physical
status column, below the reported occlusions; partially folded content now
uses the right pane beside that column. AI Config navigation was clicked in
the column, and the chat toolbar's Back button was clicked there successfully.
Chat actions also start below the status indicators and their surface fills
the column's height. Installed Runner, Flutter kernel, and Info.plist hashes
match the final Debug build. The eight adaptation/lifecycle tests were rerun
after the final layout adjustment. The simulator remains open on the fully
expanded AI Configuration page in Default Dark for inspection.

This is simulator validation, not physical-device acceptance. The fresh
simulator uses local-only AI consent and has no configured API provider. Remote
generation, live voice/TTS, Live2D assets, camera activation, and RTL still need
their configured acceptance scenarios. Half-folded screens currently use one
unobstructed pane; the second pane carries the theme background.

### Simulator setup status (2026-10-11)

Apple provides an official iPhone Duo simulator in Xcode 27.1. The current
Duo preparation page recommends Xcode 27.1 RC, whose host requirement is
macOS Tahoe 26.6 or later. This Apple silicon Mac has now been updated to
macOS Tahoe 26.7.1 (25G241), which meets the host requirement. It has
Flutter 3.44.9 and CocoaPods 1.16.2.

Xcode 27.1 RC (27A9275) is installed at `/Applications/Xcode-27.1-RC.app`,
its first-launch setup is complete, and `xcode-select` points to its developer
directory. The installer passes Apple's package-signature check. The official
iOS 27.1 simulator runtime (24A94232, arm64, 7.85 GB) is installed and available;
iOS 18.3.1 and iOS 26.5 are also installed. The official iPhone Duo simulator
`NativeTavern iPhone Duo` (`88844716-720F-4393-BFCD-ECFA16FC5DC5`) has been
created and booted, and its system home screen has been captured successfully.
NativeTavern 0.1.17+41 is installed and running on it. Device Hub required a
restart after its preview stopped refreshing; the simulator data was retained.
The App Store lookup currently lists Xcode 27.0, which is below the Duo
requirement; updating through the App Store alone does not complete this setup.

Do not rename an existing iPhone/iPad simulator as Duo: it would not exercise
the native bar-edge and reserved-region APIs. The release notes also state
that the first Simulator launch can take several minutes; StandBy and most
app-extension debugging are unavailable in the Duo simulator runtime.

Before claiming device acceptance or distributing a Duo-optimized build:

1. Select Xcode 27.1 or later and compile the new native branch against that SDK.
2. Use Device Hub's resizable simulator and the Duo simulator for closed, fully
   open, and partially folded poses, rotating and resizing within each pose.
3. Test main navigation, character grids, a populated chat, visual novel mode,
   menus/dialogs/sheets, long model names, keyboard and voice input, and Live2D
   across transitions. Verify drafts, message scroll position, active generation,
   TTS, and navigation remain continuous. Check both physical bar edges and RTL.
4. Activate the inner camera and check that controls avoid the newly active
   occlusion. Confirm inactive fold regions do not unnecessarily restrict content.
5. Follow `docs/release-runbook.md` and build release artifacts using
   `./build_ios.sh`. This adaptation does not itself publish a release.

Apple's October 5 notice also requires Duo screenshots for App Store submissions
starting April 2027. Prepare assets using the current
[screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)
and preview them in App Store Connect when preparing a release.
