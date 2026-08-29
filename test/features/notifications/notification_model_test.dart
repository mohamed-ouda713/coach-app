import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';
import 'package:intl/date_symbol_data_local.dart';

Map<String, dynamic> row({
  String? title,
  String? message,
  String? type,
  String? subscriberId,
  bool isRead = false,
  DateTime? createdAt,
}) => {
  SupabaseColumns.id: 'n1',
  SupabaseColumns.trainerId: 't1',
  SupabaseColumns.subscriberId: subscriberId,
  SupabaseColumns.type: type,
  SupabaseColumns.title: title,
  SupabaseColumns.message: message,
  SupabaseColumns.isRead: isRead,
  SupabaseColumns.createdAt:
      (createdAt ?? DateTime(2026, 8, 28, 10)).toIso8601String(),
};

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
    AppLocale.current = AppLocale.arabic;
  });

  group('fromJson', () {
    test('reads a full row', () {
      final n = NotificationModel.fromJson(
        row(
          title: 'عنوان',
          message: 'نص',
          type: 'subscription_expiry',
          subscriberId: 's1',
          isRead: true,
        ),
      );

      expect(n.id, 'n1');
      expect(n.trainerId, 't1');
      expect(n.subscriberId, 's1');
      expect(n.title, 'عنوان');
      expect(n.isRead, isTrue);
      expect(n.notificationType, NotificationType.subscriptionExpiry);
    });

    test('tolerates the nullable columns the edge function may omit', () {
      final n = NotificationModel.fromJson(row());

      expect(n.title, '');
      expect(n.message, '');
      expect(n.subscriberId, isNull);
      expect(n.type, isNull);
      expect(n.isRead, isFalse);
    });

    test('maps every type value the edge function writes', () {
      const pairs = {
        NotificationTypeValues.subscriptionExpiry:
            NotificationType.subscriptionExpiry,
        NotificationTypeValues.overdueMeasurement:
            NotificationType.overdueMeasurement,
        NotificationTypeValues.newProgramNeeded:
            NotificationType.newProgramNeeded,
        NotificationTypeValues.progressUpdate: NotificationType.progressUpdate,
      };

      pairs.forEach((value, expected) {
        expect(
          NotificationModel.fromJson(row(type: value)).notificationType,
          expected,
          reason: 'type "$value" must map — it is written by the edge function',
        );
      });
    });

    test('an unknown type degrades instead of throwing', () {
      expect(
        NotificationModel.fromJson(row(type: 'something_new')).notificationType,
        isNull,
      );
    });
  });

  group('displayTitle', () {
    test('prefers the stored title', () {
      expect(
        NotificationModel.fromJson(
          row(title: 'تنبيه انتهاء اشتراك ⚠️'),
        ).displayTitle,
        'تنبيه انتهاء اشتراك ⚠️',
      );
    });

    test('falls back per type when the title column is empty', () {
      expect(
        NotificationModel.fromJson(
          row(type: NotificationTypeValues.subscriptionExpiry),
        ).displayTitle,
        AppStrings.notificationSubscriptionExpiryTitle,
      );
      expect(
        NotificationModel.fromJson(
          row(type: NotificationTypeValues.overdueMeasurement),
        ).displayTitle,
        AppStrings.notificationOverdueMeasurementTitle,
      );
    });

    test('with no title and no type it shows the message, then a fallback', () {
      expect(
        NotificationModel.fromJson(row(message: 'نص الإشعار')).displayTitle,
        'نص الإشعار',
      );
      expect(
        NotificationModel.fromJson(row()).displayTitle,
        AppStrings.notificationFallbackTitle,
      );
    });
  });

  group('displayMessage', () {
    test('prefers the stored message', () {
      expect(
        NotificationModel.fromJson(row(message: 'رسالة')).displayMessage,
        'رسالة',
      );
    });

    test('falls back per type', () {
      expect(
        NotificationModel.fromJson(
          row(type: NotificationTypeValues.newProgramNeeded),
        ).displayMessage,
        AppStrings.notificationNewProgramNeededBody,
      );
    });
  });

  group('formattedDateText', () {
    test('today', () {
      final n = NotificationModel.fromJson(
        row(createdAt: DateTime.now().subtract(const Duration(hours: 1))),
      );
      expect(n.formattedDateText, contains(AppStrings.notificationsToday));
    });

    test('yesterday', () {
      final now = DateTime.now();
      final n = NotificationModel.fromJson(
        row(
          createdAt: DateTime(
            now.year,
            now.month,
            now.day,
            12,
          ).subtract(const Duration(days: 1)),
        ),
      );
      expect(n.formattedDateText, contains(AppStrings.notificationsYesterday));
    });

    test('older dates show a weekday and month, not "today"', () {
      final n = NotificationModel.fromJson(
        row(createdAt: DateTime.now().subtract(const Duration(days: 9))),
      );
      expect(
        n.formattedDateText,
        isNot(contains(AppStrings.notificationsToday)),
      );
      expect(
        n.formattedDateText,
        isNot(contains(AppStrings.notificationsYesterday)),
      );
      expect(n.formattedDateText.trim(), isNotEmpty);
    });
  });
}
