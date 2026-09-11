import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/rss_notification_service.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';

final rssNotificationServiceProvider = Provider<RssNotificationService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final dio = Dio(); // Basic Dio instance for RSS fetching
  return RssNotificationService(dio, prefs);
});

final notificationsProvider = FutureProvider<List<RssNotification>>((ref) async {
  final service = ref.watch(rssNotificationServiceProvider);
  return service.fetchNotifications();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).valueOrNull ?? [];
  final service = ref.watch(rssNotificationServiceProvider);
  final dismissed = service.dismissedIds;
  
  return notifications.where((n) => !dismissed.contains(n.id)).length;
});
