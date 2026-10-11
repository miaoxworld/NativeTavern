#import "NativeTavernViewController.h"

@interface NativeTavernViewController ()
@property(nonatomic, strong) FlutterMethodChannel *geometryChannel;
@property(nonatomic, copy) NSDictionary *lastGeometry;
@end

@implementation NativeTavernViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.geometryChannel = [FlutterMethodChannel
      methodChannelWithName:@"com.nativetavern/window_geometry"
            binaryMessenger:self.binaryMessenger];
  __weak NativeTavernViewController *weakSelf = self;
  [self.geometryChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    if ([call.method isEqualToString:@"getGeometry"]) {
      result([weakSelf currentGeometry]);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 270100
  if (@available(iOS 27.1, *)) {
    [self registerForTraitChanges:UITraitCollection.systemTraitsAffectingVerticalBarEdge
                      withAction:@selector(publishGeometry)];
  }
#endif
}

- (NSDictionary *)currentGeometry {
  CGRect bounds = self.view.bounds;
  NSMutableArray *regions = [NSMutableArray array];
  NSString *barEdge = @"none";
  BOOL supportsVerticalBars = NO;

  // Compile the documented APIs only when the selected SDK provides them.
  // This keeps development with older SDKs possible, without runtime selectors
  // or device-model assumptions. Duo distribution requires SDK 27.1 or later.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 270100
  if (@available(iOS 27.1, *)) {
    supportsVerticalBars = YES;
    switch (self.traitCollection.verticalBarEdge) {
      case UIVerticalBarEdgeLeading: barEdge = @"left"; break;
      case UIVerticalBarEdgeTrailing: barEdge = @"right"; break;
      default: break;
    }
    NSArray<UIViewReservedRegionKind *> *kinds = @[
      [UIViewReservedRegionKind divisionRegionKind],
      [UIViewReservedRegionKind occlusionRegionKind]
    ];
    for (UIViewReservedRegionKind *kind in kinds) {
      BOOL isDivision = [kind isEqual:[UIViewReservedRegionKind divisionRegionKind]];
      for (UIViewReservedRegion *region in [self.view reservedRegionsOfKind:kind]) {
        if (!region.active) continue;
        // UIKit includes the interactive-content margins in frame already.
        // Expanding it again would unnecessarily shrink the usable pane.
        CGRect frame = region.frame;
        // Leave zero-width/height divisions intact: an active fold can still
        // separate content without occupying pixels.
        [regions addObject:@{
          @"x": @(frame.origin.x), @"y": @(frame.origin.y),
          @"width": @(frame.size.width), @"height": @(frame.size.height),
          @"kind": isDivision ? @"division" : @"occlusion"
        }];
      }
    }
  }
#endif

  return @{
    @"width": @(bounds.size.width), @"height": @(bounds.size.height),
    @"supportsVerticalBars": @(supportsVerticalBars),
    @"verticalBarEdge": barEdge, @"regions": regions
  };
}

- (void)publishGeometry {
  if (!self.geometryChannel) return;
  NSDictionary *geometry = [self currentGeometry];
  if ([geometry isEqualToDictionary:self.lastGeometry]) return;
  self.lastGeometry = geometry;
  [self.geometryChannel invokeMethod:@"geometryChanged" arguments:geometry];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self publishGeometry];
}

- (void)viewSafeAreaInsetsDidChange {
  [super viewSafeAreaInsetsDidChange];
  [self publishGeometry];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  [self publishGeometry];
}

@end
