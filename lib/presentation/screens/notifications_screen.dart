import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/presentation/providers/notification_providers.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final l10n = AppLocalizations.of(context);
    final service = ref.watch(rssNotificationServiceProvider);
    final dismissedIds = service.dismissedIds;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: l10n.dismissAll,
            onPressed: () {
              final notifications = notificationsAsync.valueOrNull ?? [];
              if (notifications.isEmpty) return;
              
              final ids = notifications.map((e) => e.id).toList();
              service.dismissAll(ids);
              ref.invalidate(unreadNotificationsCountProvider);
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(child: Text(l10n.noNotifications));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              final isUnread = !dismissedIds.contains(n.id);

              return ListTile(
                title: Text(
                  n.title,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(n.published),
                ),
                trailing: isUnread ? const Icon(Icons.circle, color: Colors.blue, size: 12) : null,
                onTap: () {
                  if (n.link.isNotEmpty) {
                    launchUrl(Uri.parse(n.link), mode: LaunchMode.externalApplication);
                  }
                  if (isUnread) {
                    service.dismissAll([n.id]);
                    ref.invalidate(unreadNotificationsCountProvider);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(l10n.error)),
      ),
    );
  }
}
