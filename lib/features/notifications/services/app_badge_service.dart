import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';

/// بتحدّث الرقم يلي بيبين على أيقونة التطبيق بالشاشة الرئيسية للجهاز
/// (launcher badge) حسب عدد الإشعارات غير المقروءة.
///
/// مش كل الأجهزة بتدعمها: iOS بيدعمها دايماً، وبأندرويد بتشتغل على
/// اللانشرات يلي بتدعم العدّادات (Samsung One UI مثلاً) وبتنتجاهل
/// بصمت على غيرها — فأي فشل هون ما بيأثر على باقي التطبيق.
abstract class AppBadgeService {
  AppBadgeService._();

  static Future<void> update(int unreadCount) async {
    try {
      if (!await AppBadgePlus.isSupported()) return;
      AppBadgePlus.updateBadge(unreadCount);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update app badge: $e');
      }
    }
  }
}
