import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
  });

  String _typeLabel(NotificationModel item) {
    switch (item.notificationType) {
      case null:
        return AppStrings.notificationTypeGeneral;
      case NotificationType.subscriptionExpiry:
        return AppStrings.notificationTypeSubscription;
      case NotificationType.overdueMeasurement:
        return AppStrings.notificationTypeMeasurements;
      case NotificationType.newProgramNeeded:
        return AppStrings.notificationTypeProgram;
      case NotificationType.progressUpdate:
        return AppStrings.notificationTypeProgress;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = notification.displayTitle;
    final body = notification.displayMessage;
    final dateText = notification.formattedDateText;
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final isRead = notification.isRead;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.smMd),
        border:
            isRead
                ? null
                : Border(
                  right: BorderSide(color: colorScheme.primary, width: 3),
                ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppRadius.smMd,
          horizontal: AppRadius.md,
        ),
        tileColor: isRead ? Colors.transparent : appColors.primarySoftBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.smMd),
        ),
        leading: Container(
          width: AppSpacing.md,
          height: AppSpacing.md,
          margin: const EdgeInsets.only(top: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isRead ? Colors.transparent : colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color:
                      isRead ? appColors.textSecondary : colorScheme.onSurface,
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Text(
              _typeLabel(notification),
              style: TextStyle(
                color: appColors.textSecondary,
                fontSize: AppSizes.iconXxs,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
                style: TextStyle(
                  color:
                      isRead
                          ? appColors.textTertiary
                          : appColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                dateText,
                style: TextStyle(
                  color: appColors.textTertiary,
                  fontSize: AppSizes.iconXxs,
                ),
              ),
            ],
          ),
        ),
        trailing:
            isRead
                ? null
                : IconButton(
                  icon: const Icon(Icons.done),
                  color: colorScheme.primary,
                  tooltip: AppStrings.notificationsMarkAsRead,
                  onPressed: onMarkAsRead,
                ),
        onTap: onTap,
      ),
    );
  }
}
