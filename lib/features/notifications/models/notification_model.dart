import 'package:glow_up/core/constants/app_enums.dart';
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
      case 'subscription_expiry':
        return NotificationType.subscriptionExpiry;
      case 'overdue_measurement':
        return NotificationType.overdueMeasurement;
      case 'new_program_needed':
        return NotificationType.newProgramNeeded;
      default:
        return null;
    }
  }

  String get displayTitle {
    if (title.trim().isNotEmpty) return title;

    switch (notificationType) {
      case NotificationType.subscriptionExpiry:
        return 'اشتراكك على وشك الانتهاء';
      case NotificationType.overdueMeasurement:
        return 'تأخر قياساتك';
      case NotificationType.newProgramNeeded:
        return 'تحتاج إلى برنامج تدريبي جديد';
      default:
        return message.isNotEmpty ? message : 'إشعار جديد';
    }
  }

  String get displayMessage {
    if (message.trim().isNotEmpty) return message;

    switch (notificationType) {
      case NotificationType.subscriptionExpiry:
        return 'تبقى 1 يوم فقط على انتهاء اشتراكك الحالي.';
      case NotificationType.overdueMeasurement:
        return 'لم يتم تسجيل قياساتك خلال المدة المحددة.';
      case NotificationType.newProgramNeeded:
        return 'مر أكثر من 28 يوم على برنامجك الحالي، ويجب مراجعة خطة جديدة.';
      default:
        return 'إشعار جديد';
    }
  }

  String get formattedDateText {
    final local = createdAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(local.year, local.month, local.day);
    final daysAgo = today.difference(thatDay).inDays;
    final time = DateFormat.jm('ar').format(local);

    if (daysAgo == 0) {
      return 'اليوم • $time';
    }

    if (daysAgo == 1) {
      return 'أمس • $time';
    }

    return '${DateFormat('EEEE d MMMM', 'ar').format(local)} • $time';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString();
    final rawTitle = json['title']?.toString() ?? '';
    final rawMessage =
        json['body']?.toString() ?? json['message']?.toString() ?? '';

    return NotificationModel(
      id:
          json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      trainerId: json['trainer_id']?.toString() ?? 'demo_trainer',
      subscriberId: json['subscriber_id']?.toString(),
      type: rawType,
      title: rawTitle,
      message: rawMessage,
      isRead: json['is_read'] ?? false,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      data: Map<String, dynamic>.from(json['data'] ?? const {}),
    );
  }
}
