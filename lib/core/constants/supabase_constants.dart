/// أسماء الجداول (Tables) بقاعدة البيانات
/// مثال : trainer, subscriber, measurements, expence, notifications
class SupabaseTables {
  SupabaseTables._();
}

/// أسماء الأعمدة (Columns) لو احتجنا نشير لعمود معين بأكتر من مكان بالكود
/// مثال :subscriber_id, trainer_id
class SupabaseColumns {
  SupabaseColumns._();
}

/// أسماء الـ Storage Buckets (لرفع صور القياسات، صور البروفايل، إلخ)
/// مثال : measurement_photos, profile_avatars
class SupabaseBuckets {
  SupabaseBuckets._();
}

/// أسماء الـ RPC Functions لو احتجنا استعلامات مخصصة بقاعدة البيانات
/// مثال : calculate_profit_ratio, get_subscriber_progress
class SupabaseFunctions {
  SupabaseFunctions._();
}