import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String trainerId;
  final String? subscriberId;
  final String? type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.trainerId,
    this.subscriberId,
    this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.data = const {},
  });

  NotificationType? get notificationType {
    switch (type) {
      case NotificationTypeValues.subscriptionExpiry:
        return NotificationType.subscriptionExpiry;
      case NotificationTypeValues.overdueMeasurement:
        return NotificationType.overdueMeasurement;
      case NotificationTypeValues.newProgramNeeded:
        return NotificationType.newProgramNeeded;
      case NotificationTypeValues.progressUpdate:
        return NotificationType.progressUpdate;
      default:
        return null;
    }
  }

  String get displayTitle {
    if (title.trim().isNotEmpty) return title;

    switch (notificationType) {
      case NotificationType.subscriptionExpiry:
        return AppStrings.notificationSubscriptionExpiryTitle;
      case NotificationType.overdueMeasurement:
        return AppStrings.notificationOverdueMeasurementTitle;
      case NotificationType.newProgramNeeded:
        return AppStrings.notificationNewProgramNeededTitle;
      default:
        return message.isNotEmpty
            ? message
            : AppStrings.notificationFallbackTitle;
    }
  }

  String get displayMessage {
    if (message.trim().isNotEmpty) return message;

    switch (notificationType) {
      case NotificationType.subscriptionExpiry:
        return AppStrings.notificationSubscriptionExpiryBody;
      case NotificationType.overdueMeasurement:
        return AppStrings.notificationOverdueMeasurementBody;
      case NotificationType.newProgramNeeded:
        return AppStrings.notificationNewProgramNeededBody;
      default:
        return AppStrings.notificationFallbackTitle;
    }
  }

  String get formattedDateText {
    final local = createdAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(local.year, local.month, local.day);
    final daysAgo = today.difference(thatDay).inDays;
    final locale = AppLocale.code;
    final time = DateFormat.jm(locale).format(local);

    if (daysAgo == 0) {
      return '${AppStrings.notificationsToday} • $time';
    }

    if (daysAgo == 1) {
      return '${AppStrings.notificationsYesterday} • $time';
    }

    return '${DateFormat('EEEE d MMMM', locale).format(local)} • $time';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json[SupabaseColumns.id] as String,
      trainerId: json[SupabaseColumns.trainerId] as String,
      subscriberId: json[SupabaseColumns.subscriberId]?.toString(),
      type: json[SupabaseColumns.type]?.toString(),
      title: json[SupabaseColumns.title]?.toString() ?? '',
      message: json[SupabaseColumns.message]?.toString() ?? '',
      isRead: json[SupabaseColumns.isRead] as bool? ?? false,
      createdAt: DateTime.parse(json[SupabaseColumns.createdAt] as String),
      data: Map<String, dynamic>.from(json['data'] ?? const {}),
    );
  }
}
