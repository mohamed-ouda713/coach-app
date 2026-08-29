/// حالة اشتراك المشترك — تستخدم بالـ Home + الإشعارات
enum SubscriptionStatus {
  active,

  /// باقي [SubscriptionThresholds.expiringSoonDays] أيام أو أقل على
  /// الانتهاء. ملاحظة مقصودة: الـ push بينبعت قبل يوم واحد بس
  /// (supabase/functions/send-notifications) — الشارة تنبيه مبكر
  /// بتشوفه المدرب وهي بالتطبيق، والإشعار تذكير أخير.
  expiringSoon,
  expired,
}

/// حدود حساب حالة الاشتراك — مكان واحد بدل رقم مبعثر بالكود.
class SubscriptionThresholds {
  SubscriptionThresholds._();

  static const int expiringSoonDays = 3;
}

/// هدف المشترك — Feature 3 (بروفايل المشترك)
enum FitnessGoal {
  weightLoss, // خسارة وزن
  muscleGain, // زيادة كتلة
  generalFitness, // لياقة عامة
  recovery, // تعافي
}

/// نوع الإشعار — Feature 6
enum NotificationType {
  subscriptionExpiry, // قبل يوم واحد من الانتهاء
  overdueMeasurement, // بعد يوم / 3 أيام من تأخر القياس
  newProgramNeeded, // بعد 28 يوم على البرنامج التدريبي
  progressUpdate, // تقدم ممتاز هذا الشهر — إشعار إيجابي/تحفيزي
}

/// نوع البرنامج التدريبي — Post-MVP (Feature: Exercise Programs Module)
enum ProgramType { gym, home }

/// نوع الحركة المالية — Feature 5 (Financial)
enum TransactionType { income, expense }
