import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';
import 'package:glow_up/features/notifications/widgets/notification_list_item.dart';

sealed class _Entry {
  const _Entry();
}

class _SectionHeader extends _Entry {
  const _SectionHeader(this.label, this.count);

  final String label;
  final int count;
}

class _NotificationEntry extends _Entry {
  const _NotificationEntry(this.notification);

  final NotificationModel notification;
}

class NotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel notification) onNotificationTap;
  final Function(NotificationModel notification) onMarkAsRead;

  const NotificationsList({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
    required this.onMarkAsRead,
  });

  List<_Entry> _buildEntries() {
    final unread = notifications.where((n) => !n.isRead).toList();
    final read = notifications.where((n) => n.isRead).toList();

    return [
      if (unread.isNotEmpty) ...[
        _SectionHeader(AppStrings.notificationsUnreadSection, unread.length),
        ...unread.map(_NotificationEntry.new),
      ],
      if (read.isNotEmpty) ...[
        _SectionHeader(AppStrings.notificationsReadSection, read.length),
        ...read.map(_NotificationEntry.new),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries();

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.mdLg,
        horizontal: AppSpacing.lgAlt,
      ),
      itemCount: entries.length,
      separatorBuilder: (context, index) {
        final next = entries[index + 1];
        if (next is _SectionHeader) {
          return const SizedBox(height: AppSpacing.lgAlt);
        }
        return Divider(color: context.appColors.border, height: 1);
      },
      itemBuilder: (context, index) {
        final entry = entries[index];

        return switch (entry) {
          _SectionHeader(:final label, :final count) => Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.smMd,
              top: AppSpacing.xs,
            ),
            child: Text(
              '$label ($count)',
              style: AppTextStyles.h5.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
          _NotificationEntry(:final notification) => NotificationListItem(
            notification: notification,
            onTap: () => onNotificationTap(notification),
            onMarkAsRead: () => onMarkAsRead(notification),
          ),
        };
      },
    );
  }
}
