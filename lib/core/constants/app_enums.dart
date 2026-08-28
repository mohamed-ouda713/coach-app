/// حالة اشتراك المشتركة — تستخدم بالـ Home + الإشعارات
enum SubscriptionStatus {
  active,
  expiringSoon, // قبل الانتهاء بيوم واحد
  expired,
}

/// هدف المشتركة — Feature 3 (بروفايل المشتركة)
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
