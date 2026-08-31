import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/features/notifications/services/app_badge_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a failing badge plugin never breaks the caller', () async {
    // شارة أيقونة التطبيق مش مدعومة على كل الأجهزة، والقناة مش موجودة
    // أصلاً بالاختبارات. المهم إنّ الفشل ما يوقف تحديث الإشعارات —
    // AppBadgeService بتُستدعى جوّا fetchNotifications قبل emit.
    await expectLater(AppBadgeService.update(3), completes);
    await expectLater(AppBadgeService.update(0), completes);
  });
}
