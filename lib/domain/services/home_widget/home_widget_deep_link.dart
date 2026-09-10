import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';

/// Parses widget URLs and maps them onto GoRouter locations.
class HomeWidgetDeepLinkParser {
  const HomeWidgetDeepLinkParser();

  HomeWidgetDeepLink parse(Uri uri) {
    return HomeWidgetDeepLink.tryParse(uri) ??
        const HomeWidgetDeepLink(target: HomeWidgetDeepLinkTarget.home);
  }

  bool isWidgetUri(Uri uri) => HomeWidgetDeepLink.tryParse(uri) != null;
}
