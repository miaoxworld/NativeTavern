import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RssNotification {
  final String id;
  final String title;
  final String link;
  final DateTime published;
  final String content;

  RssNotification({
    required this.id,
    required this.title,
    required this.link,
    required this.published,
    required this.content,
  });
}

class RssNotificationService {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const _dismissedIdsKey = 'rss_dismissed_ids';

  RssNotificationService(this._dio, this._prefs);

  Future<List<RssNotification>> fetchNotifications() async {
    const url = String.fromEnvironment('RSS_FEED_URL');
    if (url.isEmpty) return [];

    try {
      final response = await _dio.get<String>(url, options: Options(responseType: ResponseType.plain));
      final document = XmlDocument.parse(response.data.toString());
      final entries = document.findAllElements('entry');

      final notifications = <RssNotification>[];
      for (final entry in entries) {
        final id = entry.findElements('id').firstOrNull?.innerText ?? '';
        final title = entry.findElements('title').firstOrNull?.innerText ?? '';
        final link = entry.findElements('link').firstOrNull?.getAttribute('href') ?? '';
        final publishedStr = entry.findElements('updated').firstOrNull?.innerText ?? 
                             entry.findElements('published').firstOrNull?.innerText ?? '';
        final content = entry.findElements('summary').firstOrNull?.innerText ?? 
                        entry.findElements('content').firstOrNull?.innerText ?? '';

        if (title.isNotEmpty) {
          DateTime? published;
          if (publishedStr.isNotEmpty) {
            published = DateTime.tryParse(publishedStr);
          }
          // Use link or title as fallback ID if Atom feed doesn't provide one
          final finalId = id.isNotEmpty ? id : (link.isNotEmpty ? link : title);
          
          notifications.add(RssNotification(
            id: finalId,
            title: title,
            link: link,
            published: published ?? DateTime.now(),
            content: content,
          ));
        }
      }
      
      // Sort newest first
      notifications.sort((a, b) => b.published.compareTo(a.published));
      return notifications;
    } catch (e) {
      // Return empty list on failure so it doesn't break the app
      return [];
    }
  }

  Set<String> get dismissedIds {
    return _prefs.getStringList(_dismissedIdsKey)?.toSet() ?? {};
  }

  Future<void> dismissAll(List<String> ids) async {
    final current = dismissedIds;
    current.addAll(ids);
    await _prefs.setStringList(_dismissedIdsKey, current.toList());
  }
}
