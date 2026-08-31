import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/features/notifications/services/notification_service.dart';

void main() {
  group('subscriberIdFrom — العقد مع الـ edge function', () {
    test('reads the exact payload the edge function sends', () {
      // نفس الشكل الموجود بـ sendFcmNotification:
      //   data: { subscriberId, type }
      final data = <String, dynamic>{
        'subscriberId': 'abc-123',
        'type': 'subscription_expiry',
      };

      expect(NotificationService.subscriberIdFrom(data), 'abc-123');
    });

    test('non-string values still resolve (FCM stringifies data)', () {
      expect(NotificationService.subscriberIdFrom({'subscriberId': 42}), '42');
    });

    test('a payload without the key means "just open the app"', () {
      expect(
        NotificationService.subscriberIdFrom({'type': 'subscription_expiry'}),
        isNull,
      );
      expect(NotificationService.subscriberIdFrom(null), isNull);
      expect(NotificationService.subscriberIdFrom({}), isNull);
    });

    test('an empty id is treated as absent, not as a route to "/clients/"', () {
      expect(
        NotificationService.subscriberIdFrom({'subscriberId': ''}),
        isNull,
      );
    });

    test('the key is subscriberId — not snake_case', () {
      // لو حدا غيّر الـ edge function لـ subscriber_id، هالاختبار بيوقف
      // بدل ما ينكسر فتح ملف العميل بصمت عند المستخدم.
      expect(
        NotificationService.subscriberIdFrom({'subscriber_id': 'abc'}),
        isNull,
        reason: 'the app reads "subscriberId"; keep the edge function in sync',
      );
    });
  });
}
